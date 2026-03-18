import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import '../../../core/config/flavor_config.dart';

// ─── Screen ───────────────────────────────────────────────────
class VideoCallScreen extends ConsumerStatefulWidget {
  final String contactId;
  final String contactName;
  final String? contactImageUrl;
  final bool isIncoming;
  final String? channelId;

  const VideoCallScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    this.contactImageUrl,
    this.isIncoming = false,
    this.channelId,
  });

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen>
    with TickerProviderStateMixin {
  RtcEngine? _engine;
  bool _localUserJoined = false;
  int? _remoteUid;
  bool _isIncoming = false;
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isFrontCamera = true;

  bool _showControls = true;
  int _callDuration = 0;
  Timer? _timer;
  Timer? _controlsHideTimer;

  @override
  void initState() {
    super.initState();
    _isIncoming = widget.isIncoming;
    // Force landscape-friendly full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (!widget.isIncoming) _initAgoraAndCall();
  }

  Future<void> _initAgoraAndCall() async {
    // Request camera + mic
    final perms = await [Permission.camera, Permission.microphone].request();

    if (perms[Permission.camera] != PermissionStatus.granted ||
        perms[Permission.microphone] != PermissionStatus.granted) {
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
            setState(() => _localUserJoined = true);
            _startTimer();
            _resetControlsTimer();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            setState(() => _remoteUid = remoteUid);
          },
          onUserOffline:
              (
                RtcConnection connection,
                int remoteUid,
                UserOfflineReasonType reason,
              ) {
                setState(() => _remoteUid = null);
                _endCall();
              },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('Agora video error: $err — $msg');
          },
        ),
      );

      await _engine!.enableVideo();
      await _engine!.startPreview();
      await _engine!.setEnableSpeakerphone(true);

      final channelId =
          widget.channelId ??
          'video_${widget.contactId}_${DateTime.now().millisecondsSinceEpoch}';

      await _engine!.joinChannel(
        token: '', // TODO: generate from backend
        channelId: channelId,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
    } catch (e) {
      debugPrint('Agora video init error: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _callDuration++);
    });
  }

  void _resetControlsTimer() {
    _controlsHideTimer?.cancel();
    setState(() => _showControls = true);
    _controlsHideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  Future<void> _endCall() async {
    _timer?.cancel();
    _controlsHideTimer?.cancel();
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    if (mounted) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Navigator.of(context).pop();
    }
  }

  void _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _engine?.muteLocalAudioStream(_isMuted);
    _resetControlsTimer();
  }

  void _toggleCamera() async {
    setState(() => _isCameraOff = !_isCameraOff);
    await _engine?.muteLocalVideoStream(_isCameraOff);
    _resetControlsTimer();
  }

  void _switchCamera() async {
    setState(() => _isFrontCamera = !_isFrontCamera);
    await _engine?.switchCamera();
    _resetControlsTimer();
  }

  String get _durationString {
    final m = (_callDuration ~/ 60).toString().padLeft(2, '0');
    final s = (_callDuration % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controlsHideTimer?.cancel();
    _engine?.leaveChannel();
    _engine?.release();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: GestureDetector(
        onTap: _resetControlsTimer,
        child: Stack(
          children: [
            // ─── Remote video (full screen) ───────
            _buildRemoteView(),

            // ─── Local video (picture-in-picture) ─
            _buildLocalPiP(),

            // ─── Overlay controls ─────────────────
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  // Top: timer
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_localUserJoined)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: AppText.labelLg(
                                _durationString,
                                color: AppColors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Bottom: controls
                  _buildControls(),
                ],
              ),
            ),

            // ─── Incoming call overlay ─────────────
            if (_isIncoming && _remoteUid == null && !_localUserJoined)
              _buildIncomingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteView() {
    if (_remoteUid != null) {
      return SizedBox.expand(
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine!,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: const RtcConnection(channelId: ''),
          ),
        ),
      );
    }
    // No remote user yet — show avatar placeholder
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAvatar(
              name: widget.contactName,
              imageUrl: widget.contactImageUrl,
              customSize: 120,
            ),
            const SizedBox(height: 16),
            AppText.h3(widget.contactName, color: AppColors.white),
            const SizedBox(height: 8),
            AppText.bodyMd(
              _localUserJoined
                  ? 'Waiting for ${widget.contactName}...'
                  : 'Connecting...',
              color: AppColors.white.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalPiP() {
    if (!_localUserJoined) return const SizedBox();
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: Container(
        width: 90,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _isCameraOff
              ? Container(
                  color: AppColors.grey800,
                  child: const Icon(
                    Icons.videocam_off_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                )
              : AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 32,
        top: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _VideoControlBtn(
            icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: _isMuted ? 'Unmute' : 'Mute',
            onTap: _toggleMute,
            isActive: _isMuted,
          ),
          _VideoControlBtn(
            icon: _isFrontCamera
                ? Icons.flip_camera_ios_rounded
                : Icons.flip_camera_android_rounded,
            label: 'Flip',
            onTap: _switchCamera,
          ),
          // End call
          GestureDetector(
            onTap: _endCall,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.call_end_rounded,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ),
          _VideoControlBtn(
            icon: _isCameraOff
                ? Icons.videocam_off_rounded
                : Icons.videocam_rounded,
            label: _isCameraOff ? 'Cam off' : 'Camera',
            onTap: _toggleCamera,
            isActive: _isCameraOff,
          ),
          _VideoControlBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppAvatar(
            name: widget.contactName,
            imageUrl: widget.contactImageUrl,
            customSize: 110,
          ),
          const SizedBox(height: 16),
          AppText.h2(widget.contactName, color: AppColors.white),
          const SizedBox(height: 8),
          AppText.bodyLg(
            'Incoming video call...',
            color: AppColors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decline
              _RoundVideoBtn(
                icon: Icons.call_end_rounded,
                color: AppColors.error,
                onTap: _endCall,
              ),
              const SizedBox(width: 72),
              // Accept
              _RoundVideoBtn(
                icon: Icons.videocam_rounded,
                color: AppColors.success,
                onTap: () {
                  setState(() => _isIncoming = false);
                  _initAgoraAndCall();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Video control button ─────────────────────────────────────
class _VideoControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  const _VideoControlBtn({
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 22),
          ),
          const SizedBox(height: 6),
          AppText.bodyXs(label, color: AppColors.white.withOpacity(0.8)),
        ],
      ),
    );
  }
}

class _RoundVideoBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _RoundVideoBtn({
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
              color: color.withOpacity(0.5),
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
