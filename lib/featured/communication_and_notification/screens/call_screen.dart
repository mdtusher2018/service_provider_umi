import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import '../../../core/config/flavor_config.dart';

// ─── Screen ───────────────────────────────────────────────────
class CallScreen extends ConsumerStatefulWidget {
  final String contactId;
  final String contactName;
  final String? contactImageUrl;
  final bool isIncoming;
  final String? channelId;
  final CallType callType;

  const CallScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    this.contactImageUrl,
    this.isIncoming = false,
    this.channelId,
    required this.callType,
  });

  @override
  ConsumerState<CallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends ConsumerState<CallScreen>
    with TickerProviderStateMixin {
  RtcEngine? _engine;
  CallState _callState = CallState.ringing;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  int _callDuration = 0;
  Timer? _timer;
  late AnimationController _pulseController;

  bool _localUserJoined = false;
  int? _remoteUid;

  // Video-specific state
  bool _isCameraOff = false;
  bool _isFrontCamera = true;
  bool _showControls = true;
  Timer? _controlsHideTimer;

  // Derived helpers
  bool get _isVideoCall => widget.callType == CallType.video;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    if (!widget.isIncoming) {
      _initAgoraAndCall();
    }
  }

  // ─── Agora init ─────────────────────────────────────────────
  Future<void> _initAgoraAndCall() async {
    setState(() => _callState = CallState.connecting);

    final statuses = await <Permission>[
      Permission.microphone,
      if (_isVideoCall) Permission.camera,
    ].request();

    if (statuses.values.any((s) => s != PermissionStatus.granted)) {
      _endCall();
      return;
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(
        RtcEngineContext(
          appId: FlavorConfig.instance.agoraAppId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            if (mounted) setState(() => _localUserJoined = true);
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            if (mounted) {
              setState(() {
                _remoteUid = remoteUid;
                _callState = CallState.connected;
              });
              _startTimer();
            }
          },
          onUserOffline: (_, __, ___) => _endCall(),
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            if (mounted) setState(() => _callState = CallState.ended);
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('Agora error: $err — $msg');
          },
        ),
      );

      if (_isVideoCall) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
        await _engine!.setDefaultAudioRouteToSpeakerphone(true);
        setState(() => _isSpeakerOn = true);
      } else {
        await _engine!.enableAudio();
        await _engine!.setDefaultAudioRouteToSpeakerphone(false);
      }

      final channelId =
          widget.channelId ??
          'call_${widget.contactId}_${DateTime.now().millisecondsSinceEpoch}';

      AppLogger.info(channelId);

      await _engine!.joinChannel(
        token:
            '007eJxTYHC7fzQniZUtmVf+p6+PllSvTfFkS+Grjw7+9rp6dLpb7xcFBgtzY0Pz1DTLRGNjQxNT4+REQxMzY3NL86REC6PkFBNDx9o3mQ2BjAzxomGsjAwQCOJzMiRnJOblpeZ4pjAwAABrax+G', // TODO: generate token from backend
        channelId: "channelId",
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
    } catch (e) {
      debugPrint('Agora init error: $e');
      if (mounted) setState(() => _callState = CallState.ringing);
    }
  }

  // ─── Timer ──────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _callDuration++);
    });
  }

  // ─── Call controls ───────────────────────────────────────────
  Future<void> _endCall() async {
    _timer?.cancel();
    _controlsHideTimer?.cancel();
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    if (mounted) {
      setState(() => _callState = CallState.ended);
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) context.pop();
    }
  }

  void _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _engine?.muteLocalAudioStream(_isMuted);
  }

  void _toggleSpeaker() async {
    setState(() => _isSpeakerOn = !_isSpeakerOn);
    await _engine?.setEnableSpeakerphone(_isSpeakerOn);
  }

  void _toggleCamera() async {
    setState(() => _isCameraOff = !_isCameraOff);
    await _engine?.muteLocalVideoStream(_isCameraOff);
  }

  void _switchCamera() async {
    setState(() => _isFrontCamera = !_isFrontCamera);
    await _engine?.switchCamera();
  }

  // ─── Video controls visibility ───────────────────────────────
  void _onVideoTap() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _scheduleHideControls();
  }

  void _scheduleHideControls() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  // ─── Helpers ─────────────────────────────────────────────────
  String get _durationString {
    final m = (_callDuration ~/ 60).toString().padLeft(2, '0');
    final s = (_callDuration % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _statusLabel {
    if (_callState == CallState.connected) return _durationString;
    if (_callState == CallState.connecting) return 'Connecting...';
    return widget.isIncoming ? 'Incoming call...' : 'Calling...';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controlsHideTimer?.cancel();
    _pulseController.dispose();
    _engine?.leaveChannel();
    _engine?.release();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  // ─── Build ───────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return _isVideoCall ? _buildVideoCallUI() : _buildAudioCallUI();
  }

  // ═══════════════════════════════════════════════════════════════
  //  AUDIO CALL UI
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAudioCallUI() {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: 16.paddingAll,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _endCall,
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Avatar with pulse
            _PulsingAvatar(
              name: widget.contactName,
              imageUrl: widget.contactImageUrl,
              pulseController: _pulseController,
              isConnected: _callState == CallState.connected,
            ),
            20.verticalSpace,

            // Name & ID
            AppText.h2(widget.contactName),
            6.verticalSpace,
            AppText.bodyMd(widget.contactId, color: AppColors.textSecondary),
            12.verticalSpace,

            // Status / timer
            AppText.bodyLg(
              _statusLabel,
              color: _callState == CallState.connected
                  ? AppColors.primary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),

            const Spacer(),

            // Controls
            if (_callState == CallState.connected)
              _buildAudioConnectedControls()
            else if (widget.isIncoming && _callState == CallState.ringing)
              _buildIncomingControls()
            else
              _buildOutgoingControl(),

            48.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildAudioConnectedControls() {
    return Padding(
      padding: 40.paddingH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CallControlBtn(
            icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: _isMuted ? 'Unmute' : 'Mute',
            onTap: _toggleMute,
            isActive: _isMuted,
          ),
          _CallControlBtn(
            icon: _isSpeakerOn
                ? Icons.volume_up_rounded
                : Icons.volume_down_rounded,
            label: 'Speaker',
            onTap: _toggleSpeaker,
            isActive: _isSpeakerOn,
          ),
          _EndCallBtn(onTap: _endCall),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  VIDEO CALL UI
  // ═══════════════════════════════════════════════════════════════
  Widget _buildVideoCallUI() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _callState == CallState.connected ? _onVideoTap : null,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Remote video (full screen) ──────────────────────
            _buildRemoteVideo(),

            // ── Local video (PiP) ───────────────────────────────
            if (_callState == CallState.connected && _localUserJoined)
              _buildLocalVideoPip(),

            // ── Top bar (back + name + status) ─────────────────
            _buildVideoTopBar(),

            // ── Bottom controls ─────────────────────────────────
            if (_callState == CallState.connected)
              _buildVideoConnectedControls()
            else if (widget.isIncoming && _callState == CallState.ringing)
              Positioned(
                bottom: 56,
                left: 0,
                right: 0,
                child: _buildIncomingControls(),
              )
            else
              Positioned(
                bottom: 56,
                left: 0,
                right: 0,
                child: _buildOutgoingControl(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteVideo() {
    if (_remoteUid != null && _callState == CallState.connected) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: "channelId"),
        ),
      );
    }
    // Waiting for remote — show avatar overlay on dark bg
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PulsingAvatar(
              name: widget.contactName,
              imageUrl: widget.contactImageUrl,
              pulseController: _pulseController,
              isConnected: false,
            ),
            24.verticalSpace,
            AppText.h2(widget.contactName, color: Colors.white),
            8.verticalSpace,
            AppText.bodyLg(
              _statusLabel,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalVideoPip() {
    return Positioned(
      top: 100,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 100,
          height: 140,
          child: Stack(
            children: [
              if (_isCameraOff || !_localUserJoined)
                Container(
                  color: const Color(0xFF2C2C3E),
                  child: Center(
                    child: Icon(
                      Icons.videocam_off_rounded,
                      color: Colors.white54,
                      size: 28,
                    ),
                  ),
                )
              else
                AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              // Switch camera button on PiP
              Positioned(
                bottom: 6,
                right: 6,
                child: GestureDetector(
                  onTap: _switchCamera,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.flip_camera_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _showControls || _callState != CallState.connected ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Colors.transparent],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _endCall,
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.h3(widget.contactName, color: Colors.white),
                        4.verticalSpace,
                        AppText.bodyMd(
                          _statusLabel,
                          color: _callState == CallState.connected
                              ? AppColors.primary
                              : Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoConnectedControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black87, Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CallControlBtn(
                icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                label: _isMuted ? 'Unmute' : 'Mute',
                onTap: _toggleMute,
                isActive: _isMuted,
                darkMode: true,
              ),
              _CallControlBtn(
                icon: _isCameraOff
                    ? Icons.videocam_off_rounded
                    : Icons.videocam_rounded,
                label: _isCameraOff ? 'Start Cam' : 'Stop Cam',
                onTap: _toggleCamera,
                isActive: _isCameraOff,
                darkMode: true,
              ),
              _CallControlBtn(
                icon: _isSpeakerOn
                    ? Icons.volume_up_rounded
                    : Icons.volume_down_rounded,
                label: 'Speaker',
                onTap: _toggleSpeaker,
                isActive: _isSpeakerOn,
                darkMode: true,
              ),
              _CallControlBtn(
                icon: Icons.flip_camera_ios_rounded,
                label: 'Flip',
                onTap: _switchCamera,
                darkMode: true,
              ),
              _EndCallBtn(onTap: _endCall, darkMode: true),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  SHARED CONTROLS
  // ═══════════════════════════════════════════════════════════════
  Widget _buildIncomingControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundCallBtn(
          icon: Icons.call_end_rounded,
          color: AppColors.error,
          onTap: _endCall,
        ),
        60.horizontalSpace,
        _RoundCallBtn(
          icon: _isVideoCall ? Icons.videocam_rounded : Icons.call_rounded,
          color: AppColors.success,
          onTap: _initAgoraAndCall,
        ),
      ],
    );
  }

  Widget _buildOutgoingControl() {
    return _RoundCallBtn(
      icon: Icons.call_end_rounded,
      color: AppColors.error,
      onTap: _endCall,
    );
  }
}

// ─── Pulsing Avatar ───────────────────────────────────────────
class _PulsingAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final AnimationController pulseController;
  final bool isConnected;

  const _PulsingAvatar({
    required this.name,
    this.imageUrl,
    required this.pulseController,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (_, child) {
        final scale = isConnected ? 1.0 : 1.0 + pulseController.value * 0.08;
        return Stack(
          alignment: Alignment.center,
          children: [
            if (!isConnected) ...[
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(
                    0.08 * (1 - pulseController.value),
                  ),
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(
                    0.12 * (1 - pulseController.value),
                  ),
                ),
              ),
            ],
            Transform.scale(scale: scale, child: child),
          ],
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipOval(
          child: AppAvatar(name: name, imageUrl: imageUrl, customSize: 100),
        ),
      ),
    );
  }
}

// ─── Call Control Button ──────────────────────────────────────
class _CallControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool darkMode;

  const _CallControlBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.darkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive
        ? AppColors.primary
        : darkMode
        ? Colors.white24
        : AppColors.grey100;
    final iconColor = isActive
        ? AppColors.white
        : darkMode
        ? Colors.white
        : AppColors.textPrimary;
    final labelColor = darkMode ? Colors.white70 : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          6.verticalSpace,
          AppText.bodyXs(label, color: labelColor),
        ],
      ),
    );
  }
}

// ─── End Call Button ──────────────────────────────────────────
class _EndCallBtn extends StatelessWidget {
  final VoidCallback onTap;
  final bool darkMode;

  const _EndCallBtn({required this.onTap, this.darkMode = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.call_end_rounded,
              color: AppColors.white,
              size: 22,
            ),
          ),
          6.verticalSpace,
          AppText.bodyXs(
            'End',
            color: darkMode ? Colors.white70 : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

// ─── Round Call Button (incoming accept/decline) ──────────────
class _RoundCallBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoundCallBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.white, size: 30),
      ),
    );
  }
}
