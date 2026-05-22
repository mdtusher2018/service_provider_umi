// lib/core/services/call_kit_service.dart

import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallKitService {
  /// Shows the native incoming call screen (lock screen / notification)
  static Future<void> showIncomingCall({
    required String callId,
    required String callerId,
    required String callerName,
    required String? callerImage,
    required String channelId,
    required bool isVideo,
  }) async {
    final params = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'YourAppName', // <-- change this
      avatar: callerImage,
      handle: callerId,
      type: isVideo ? 1 : 0, // 0=audio, 1=video
      duration: 30000, // auto-dismiss after 30s
      textAccept: 'Accept',
      textDecline: 'Decline',
      // Missed call notification when user doesn't answer
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      android: const AndroidParams(
        isCustomNotification: true,
        isShowFullLockedScreen: true, // shows on lock screen
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#1A1A2E',
        actionColor: '#4CAF50',
        textColor: '#FFFFFF',
        incomingCallNotificationChannelName: 'Incoming Call',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        configureAudioSession: true,
        ringtonePath: 'system_ringtone_default',
      ),
      // Pass extra data — we'll read this on accept
      extra: {
        'callerId': callerId,
        'channelId': channelId,
        'callType': isVideo ? 'video' : 'audio',
        'callerImage': callerImage ?? '',
      },
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  static Future<void> endCall(String callId) async {
    await FlutterCallkitIncoming.endCall(callId);
  }

  static Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }
}
