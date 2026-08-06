import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:service_provider_umi/core/config/app_config.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:service_provider_umi/data/repository/notification_and_history_repositiry.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';

final callProvider = ChangeNotifierProvider.autoDispose.family<CallNotifier, String>((ref, channelId) {
  final repository = ref.watch(notificationAndHistoryRepositiryProvider);
  return CallNotifier(channelId: channelId, repository: repository);
});

class CallNotifier extends ChangeNotifier {
  final String channelId;
  RtcEngine? engine;
  int? remoteUid;
  bool localUserJoined = false;
  bool isMuted = false;
  bool isCameraOff = false;
  bool isSpeakerOn = false;
  
  bool _isVideoCall = true;
  bool get isVideoCall => _isVideoCall;

  // Timer properties
  Timer? _callTimer;
  int callDurationInSeconds = 0;
  
  final NotificationAndHistoryRepositiry repository;

  CallNotifier({required this.channelId, required this.repository});

  Future<void> initAgora({required bool isVideoCall, String? callId}) async {
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
          engine?.setEnableSpeakerphone(isSpeakerOn); // Set speaker after joining
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
        onError: (ErrorCodeType err, String msg) {
          AppLogger.error("Agora Error: $err, msg: $msg");
        },
        onConnectionStateChanged: (RtcConnection connection, ConnectionStateType state, ConnectionChangedReasonType reason) {
          AppLogger.info("Agora Connection State: $state, reason: $reason");
        },
      ),
    );

    await engine!.enableAudio();
    if (_isVideoCall) {
      await engine!.enableVideo();
      await engine!.startPreview();
      isSpeakerOn = true;
    } else {
      await engine!.disableVideo();
      isSpeakerOn = false;
    }

    try {
      if (callId != null) {
        // Fetch token from backend using history callId
        AppLogger.info("Fetching Agora token for callId: $callId");
        final tokenResult = await repository.getAgoraToken(callId);
        
        String token = '';
        int uid = 0;

        tokenResult.when(
          success: (data) {
            token = data['token']?.toString() ?? '';
            uid = int.tryParse(data['uid']?.toString() ?? '0') ?? 0;
            AppLogger.success("Successfully fetched Agora token: uid $uid");
            return data;
          },
          failure: (error) {
            AppLogger.error("Failed to fetch Agora token: ${error.message}");
            return <String, dynamic>{};
          },
        );

        await engine!.joinChannel(
          token: token,
          channelId: channelId,
          uid: uid,
          options: const ChannelMediaOptions(),
        );
      } else {
        AppLogger.error("Cannot fetch Agora token: callId is null");
        // Still try to join with empty token
        await engine!.joinChannel(
          token: '',
          channelId: channelId,
          uid: 0,
          options: const ChannelMediaOptions(),
        );
      }
    } catch (e) {
      AppLogger.error("Exception while fetching token or joining channel: $e");
    }
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

  void toggleSpeaker() {
    isSpeakerOn = !isSpeakerOn;
    engine?.setEnableSpeakerphone(isSpeakerOn);
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
