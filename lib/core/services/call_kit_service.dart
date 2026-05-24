// lib/core/services/call_kit_service.dart

import 'dart:developer';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';

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
      appName: 'iUmi', // <-- change this
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

// lib/core/services/call_kit_listener_service.dart

class CallKitListenerService {
  /// Call once in main() after Firebase.initializeApp()
  static void init() {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
      if (event == null) return;
      log('CallKit event: ${event.event}  body: ${event.body}');

      switch (event.event) {
        case Event.actionCallAccept:
          _handleAccept(event.body);
          break;

        case Event.actionCallDecline:
          // User tapped Decline on lock screen — nothing to do in-app
          log('Call declined from lock screen');
          break;

        case Event.actionCallEnded:
          // CallKit auto-dismissed (timeout / remote ended)
          _popCallScreen();
          break;

        case Event.actionCallTimeout:
          // Rang for 30 s with no answer
          _popCallScreen();
          break;

        case Event.actionCallCallback:
          // User tapped "Call back" from missed-call notification
          // You can re-navigate to the call screen here if needed
          break;

        default:
          break;
      }
    });
  }

  // ─── Accept ───────────────────────────────────────────────────
  static void _handleAccept(Map<dynamic, dynamic> body) {
    final extra = (body['extra'] as Map<dynamic, dynamic>?) ?? {};

    final callerId = extra['callerId']?.toString() ?? '';
    final callerName = body['nameCaller']?.toString() ?? 'Unknown';
    final callerImage = extra['callerImage']?.toString();
    final channelId = extra['channelId']?.toString() ?? '';
    final isVideo = extra['callType']?.toString() == 'video';

    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      log('CallKitListenerService: no context, cannot navigate');
      return;
    }

    final extraMap = {
      'name': callerName,
      'imageUrl': callerImage ?? '',
      'channelId': channelId,
      'isIncoming': true,
    };

    if (isVideo) {
      context.push(AppRoutes.videoCallPath(callerId), extra: extraMap);
    } else {
      context.push(AppRoutes.audioCallPath(callerId), extra: extraMap);
    }
  }

  // ─── Dismiss call screen ──────────────────────────────────────
  static void popCallScreen() {
    final context = rootNavigatorKey.currentContext;
    if (context != null && context.canPop()) {
      context.pop();
    }
  }

  // private alias used inside this file
  static void _popCallScreen() => popCallScreen();
}
