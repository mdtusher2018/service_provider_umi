import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/services/permission_service.dart';
import '../riverpod/call_provider.dart';
import '../riverpod/communication_and_notification_provider.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String contactId;
  final String contactName;
  final String? contactImageUrl;
  final String channelId;
  final bool isIncoming;
  final bool isVideoCall;
  final String? callId;

  const CallScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    this.contactImageUrl,
    required this.channelId,
    required this.isIncoming,
    this.isVideoCall = false,
    this.callId,
  });

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPermission = await PermissionService().requestCameraAndMicrophone();
      if (!hasPermission) {
        if (mounted) context.showSnackBar(AppLocalizations.of(context)!.micAndCameraPermissionsRequired, isError: true);
        return;
      }
      
      // Init Agora for both incoming and outgoing calls
      ref.read(callProvider(widget.channelId)).initAgora(
        isVideoCall: widget.isVideoCall,
        callId: widget.callId,
      );
    });
  }

  bool _hasEnded = false;

  void _performCallCleanup() {
    if (_hasEnded) return;
    _hasEnded = true;

    final callNotifier = ref.read(callProvider(widget.channelId));
    final isConnected = callNotifier.remoteUid != null;

    if (widget.callId != null) {
      if (isConnected) {
        // Call was connected — use 'end' API
        debugPrint('📞 [Call Action] Pressed END CALL for connected call (id: ${widget.callId})');
        ref.read(callHistoryProvider.notifier).end(widget.callId!);
      } else if (!widget.isIncoming) {
        // Caller ending before receiver answered — use 'cancel' API
        debugPrint('📞 [Call Action] Pressed CANCEL CALL before receiver answered (id: ${widget.callId})');
        ref.read(callHistoryProvider.notifier).cancel(widget.callId!);
      } else {
        // Receiver declining — use 'reject' API
        debugPrint('📞 [Call Action] Pressed REJECT CALL (id: ${widget.callId})');
        ref.read(callHistoryProvider.notifier).reject(widget.callId!);
      }
    }
    
    callNotifier.endCall();
  }

  void _endCall() {
    _performCallCleanup();
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callProvider(widget.channelId));
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _performCallCleanup();
        }
      },
      child: widget.isVideoCall ? _buildVideoCallUI(callState) : _buildAudioCallUI(callState),
    );
  }

  Widget _buildAudioCallUI(CallNotifier callState) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: 16.paddingAll,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _endCall,
                    child: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _PulsingAvatar(
              name: widget.contactName,
              imageUrl: widget.contactImageUrl,
              pulseController: _pulseController,
              isConnected: callState.remoteUid != null,
            ),
            20.verticalSpace,
            if (callState.remoteUid != null) ...[
              AppText.bodyLg('Connected', color: AppColors.textSecondary),
              12.verticalSpace,
              AppText.h2(callState.formattedDuration, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ] else ...[
              AppText.h2(widget.contactName),
              12.verticalSpace,
              AppText.bodyLg(
                widget.isIncoming && !callState.localUserJoined ? 'Incoming call...' : 'Calling...',
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ],
            const Spacer(),
            if (callState.remoteUid != null)
              _buildAudioConnectedControls(callState)
            else if (widget.isIncoming && !callState.localUserJoined)
              _buildIncomingControls(callState)
            else
              _buildOutgoingControl(),
            48.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCallUI(CallNotifier callState) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (callState.remoteUid != null)
              AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: callState.engine!,
                  canvas: VideoCanvas(uid: callState.remoteUid),
                  connection: RtcConnection(channelId: widget.channelId),
                ),
              )
            else
              Container(
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
                        widget.isIncoming && !callState.localUserJoined ? 'Incoming call...' : 'Calling...',
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
            if (callState.remoteUid != null && callState.localUserJoined && !callState.isCameraOff)
              Positioned(
                top: 100,
                right: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 140,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: callState.engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ),
            if (_showControls || callState.remoteUid == null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _endCall,
                          child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                        ),
                        16.horizontalSpace,
                        AppText.h3(widget.contactName, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            if (callState.remoteUid != null && _showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CallControlBtn(
                        icon: callState.isMuted ? Icons.mic_off : Icons.mic,
                        label: 'Mute',
                        onTap: callState.toggleMute,
                        isActive: callState.isMuted,
                        darkMode: true,
                      ),
                      _CallControlBtn(
                        icon: callState.isCameraOff ? Icons.videocam_off : Icons.videocam,
                        label: 'Video',
                        onTap: callState.toggleCamera,
                        isActive: callState.isCameraOff,
                        darkMode: true,
                      ),
                      _CallControlBtn(
                        icon: Icons.flip_camera_ios,
                        label: 'Flip',
                        onTap: callState.switchCamera,
                        darkMode: true,
                      ),
                      _EndCallBtn(onTap: _endCall, darkMode: true),
                    ],
                  ),
                ),
              )
            else if (widget.isIncoming && !callState.localUserJoined)
              Positioned(
                bottom: 56,
                left: 0,
                right: 0,
                child: _buildIncomingControls(callState),
              )
            else if (callState.remoteUid == null)
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

  Widget _buildAudioConnectedControls(CallNotifier callState) {
    return Padding(
      padding: 40.paddingH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _RoundCallBtn(
            icon: callState.isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            color: callState.isMuted ? AppColors.primary : AppColors.white,
            iconColor: callState.isMuted ? AppColors.white : AppColors.primary,
            border: Border.all(color: AppColors.grey200),
            onTap: callState.toggleMute,
          ),
          _RoundCallBtn(
            icon: Icons.call_end_rounded,
            color: AppColors.error,
            iconColor: AppColors.white,
            size: 64,
            onTap: _endCall,
          ),
          _RoundCallBtn(
            icon: callState.isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            color: callState.isSpeakerOn ? AppColors.primary : AppColors.white,
            iconColor: callState.isSpeakerOn ? AppColors.white : AppColors.primary,
            border: Border.all(color: AppColors.grey200),
            onTap: callState.toggleSpeaker,
          ),
        ],
      ),
    );
  }

  Widget _buildIncomingControls(CallNotifier callState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundCallBtn(icon: Icons.call_end_rounded, color: AppColors.error, iconColor: AppColors.white, size: 56, onTap: _endCall),
        60.horizontalSpace,
        _RoundCallBtn(
          icon: widget.isVideoCall ? Icons.videocam_rounded : Icons.call_rounded,
          color: AppColors.success,
          iconColor: AppColors.white,
          size: 56,
          onTap: () async {
            final hasPermission = await PermissionService().requestCameraAndMicrophone();
            if (hasPermission) {
              if (widget.callId != null) {
                ref.read(callHistoryProvider.notifier).accept(widget.callId!);
              }
              // We don't call initAgora again here because initState already called it.
            } else {
              if (mounted) context.showSnackBar(AppLocalizations.of(context)!.micAndCameraPermissionsRequired, isError: true);
            }
          },
        ),
      ],
    );
  }

  Widget _buildOutgoingControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundCallBtn(icon: Icons.call_end_rounded, color: AppColors.error, iconColor: AppColors.white, size: 64, onTap: _endCall),
      ],
    );
  }
}

class _PulsingAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final AnimationController pulseController;
  final bool isConnected;

  const _PulsingAvatar({required this.name, this.imageUrl, required this.pulseController, required this.isConnected});

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
                width: 140, height: 140,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.08 * (1 - pulseController.value))),
              ),
            ],
            Transform.scale(scale: scale, child: child),
          ],
        );
      },
      child: Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: ClipOval(child: AppAvatar(name: name, imageUrl: imageUrl, customSize: 100)),
      ),
    );
  }
}

class _CallControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool darkMode;

  const _CallControlBtn({required this.icon, required this.label, required this.onTap, this.isActive = false, this.darkMode = false});

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive ? AppColors.primary : (darkMode ? Colors.white24 : AppColors.grey100);
    final iconColor = isActive ? AppColors.white : (darkMode ? Colors.white : AppColors.textPrimary);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 22)),
          6.verticalSpace,
          AppText.bodyXs(label, color: darkMode ? Colors.white70 : AppColors.textSecondary),
        ],
      ),
    );
  }
}

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
          Container(width: 52, height: 52, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle), child: const Icon(Icons.call_end_rounded, color: AppColors.white, size: 22)),
          6.verticalSpace,
          AppText.bodyXs('End', color: darkMode ? Colors.white70 : AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _RoundCallBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final double size;
  final BoxBorder? border;
  
  const _RoundCallBtn({
    required this.icon,
    required this.color,
    this.iconColor = AppColors.white,
    required this.onTap,
    this.size = 56,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
        ),
        child: Icon(icon, color: iconColor, size: size * 0.45),
      ),
    );
  }
}
