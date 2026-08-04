import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:service_provider_umi/core/config/app_config.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

final callProvider = ChangeNotifierProvider.autoDispose.family<CallNotifier, String>((ref, channelId) {
  return CallNotifier(channelId: channelId);
});

class CallNotifier extends ChangeNotifier {
  final String channelId;
  RtcEngine? engine;
  int? remoteUid;
  bool localUserJoined = false;
  bool isMuted = false;
  bool isCameraOff = false;
  
  bool _isVideoCall = true;
  bool get isVideoCall => _isVideoCall;

  // Timer properties
  Timer? _callTimer;
  int callDurationInSeconds = 0;

  CallNotifier({required this.channelId});

  Future<void> initAgora({required bool isVideoCall}) async {
    _isVideoCall = isVideoCall;
    
    // Play ringing sound until someone joins
    FlutterRingtonePlayer.playRingtone();
    
    engine = createAgoraRtcEngine();
    await engine!.initialize(
      RtcEngineContext(
        appId: AppConfig.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          AppLogger.success("Local user joined channel: ${connection.channelId}");
          localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          AppLogger.success("Remote user joined: $remoteUid");
          this.remoteUid = remoteUid;
          FlutterRingtonePlayer.stop(); // Stop ringing when someone joins
          _startTimer();
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          AppLogger.warning("Remote user left: $remoteUid");
          this.remoteUid = null;
          FlutterRingtonePlayer.stop();
          _stopTimer();
          notifyListeners();
        },
      ),
    );

    await engine!.enableAudio();
    if (_isVideoCall) {
      await engine!.enableVideo();
      await engine!.startPreview();
    } else {
      await engine!.disableVideo();
    }

    // Since they don't have a token server, we pass null or empty string for testing if allowed by their Agora project
    await engine!.joinChannel(
      token: '', // Leave empty if your project is testing mode, else need a token
      channelId: channelId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void _startTimer() {
    _callTimer?.cancel();
    callDurationInSeconds = 0;
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDurationInSeconds++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _callTimer?.cancel();
    _callTimer = null;
  }

  String get formattedDuration {
    final minutes = (callDurationInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (callDurationInSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void toggleMute() {
    isMuted = !isMuted;
    engine?.muteLocalAudioStream(isMuted);
    notifyListeners();
  }

  void toggleCamera() {
    isCameraOff = !isCameraOff;
    engine?.muteLocalVideoStream(isCameraOff);
    notifyListeners();
  }

  void switchCamera() {
    engine?.switchCamera();
  }

  Future<void> endCall() async {
    FlutterRingtonePlayer.stop();
    _stopTimer();
    if (engine != null) {
      await engine!.leaveChannel();
      await engine!.release();
    }
  }

  @override
  void dispose() {
    endCall();
    super.dispose();
  }
}
