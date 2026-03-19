import 'dart:async';
import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import '../../../core/config/flavor_config.dart';

// ─── Call state ───────────────────────────────────────────────
enum CallState { ringing, connecting, connected, ended }

// ─── Screen ───────────────────────────────────────────────────
class AudioCallScreen extends ConsumerStatefulWidget {
  final String contactId;
  final String contactName;
  final String? contactImageUrl;
  final bool isIncoming;
  final String? channelId;

  const AudioCallScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    this.contactImageUrl,
    this.isIncoming = false,
    this.channelId,
  });

  @override
  ConsumerState<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends ConsumerState<AudioCallScreen>
    with TickerProviderStateMixin {
  RtcEngine? _engine;
  CallState _callState = CallState.ringing;
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  int _callDuration = 0;
  Timer? _timer;
  late AnimationController _pulseController;

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

  Future<void> _initAgoraAndCall() async {
    setState(() => _callState = CallState.connecting);

    // Request mic permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
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
            setState(() => _callState = CallState.connected);
            _startTimer();
          },
          onUserOffline:
              (
                RtcConnection connection,
                int remoteUid,
                UserOfflineReasonType reason,
              ) {
                _endCall();
              },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            setState(() => _callState = CallState.ended);
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('Agora error: $err — $msg');
          },
        ),
      );

      await _engine!.enableAudio();
      await _engine!.setDefaultAudioRouteToSpeakerphone(false);

      final channelId =
          widget.channelId ??
          'call_${widget.contactId}_${DateTime.now().millisecondsSinceEpoch}';

      await _engine!.joinChannel(
        token: '', // TODO: generate token from your backend
        channelId: channelId,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
    } catch (e) {
      debugPrint('Agora init error: $e');
      setState(() => _callState = CallState.ringing);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _callDuration++);
    });
  }

  Future<void> _endCall() async {
    _timer?.cancel();
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    if (mounted) {
      setState(() => _callState = CallState.ended);
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.of(context).pop();
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

  String get _durationString {
    final m = (_callDuration ~/ 60).toString().padLeft(2, '0');
    final s = (_callDuration % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _engine?.leaveChannel();
    _engine?.release();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Back button ──────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
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

            // ─── Avatar with pulse ────────────────
            _PulsingAvatar(
              name: widget.contactName,
              imageUrl: widget.contactImageUrl,
              pulseController: _pulseController,
              isConnected: _callState == CallState.connected,
            ),
            20.verticalSpace,

            // ─── Name & number ────────────────────
            AppText.h2(widget.contactName),
            6.verticalSpace,
            AppText.bodyMd(widget.contactId, color: AppColors.textSecondary),
            12.verticalSpace,

            // ─── Status / timer ───────────────────
            AppText.bodyLg(
              _callState == CallState.connected
                  ? _durationString
                  : _callState == CallState.connecting
                  ? 'Connecting...'
                  : widget.isIncoming
                  ? 'Incoming call...'
                  : 'Calling...',
              color: _callState == CallState.connected
                  ? AppColors.primary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),

            const Spacer(),

            // ─── Controls ────────────────────────
            if (_callState == CallState.connected)
              _buildConnectedControls()
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

  Widget _buildConnectedControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CallControlBtn(
            icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: 'Mute',
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
          _CallControlBtn(
            icon: Icons.videocam_outlined,
            label: 'Video call',
            onTap: () {
              // Switch to video
            },
          ),
          _EndCallBtn(onTap: _endCall),
        ],
      ),
    );
  }

  Widget _buildIncomingControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decline
        _RoundCallBtn(
          icon: Icons.call_end_rounded,
          color: AppColors.error,
          onTap: _endCall,
        ),
        60.horizontalSpace,
        // Accept
        _RoundCallBtn(
          icon: Icons.call_rounded,
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

// ─── Pulsing avatar ───────────────────────────────────────────
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
            // Outer pulse rings
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

// ─── Call control buttons ─────────────────────────────────────
class _CallControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  const _CallControlBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.white : AppColors.textPrimary,
              size: 22,
            ),
          ),
          6.verticalSpace,
          AppText.bodyXs(label, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _EndCallBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _EndCallBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
          AppText.bodyXs('End', color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

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
