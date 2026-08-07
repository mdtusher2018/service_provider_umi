import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/services/call_kit_service.dart';
import 'package:service_provider_umi/firebase_options.dart';

class NotificationService {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Top-level — handles FCM when app is KILLED or BACKGROUND
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (message.data['type'] == 'incoming_call') {
      String callerName = message.data['callerName'] ?? 'Unknown Caller';
      String? callerImage = message.data['callerImage'];
      String callerId = message.data['callerId'] ?? '';

      if (message.data.containsKey('sender')) {
        try {
          final senderStr = message.data['sender'];
          if (senderStr is String) {
            final senderMap = jsonDecode(senderStr);
            callerName = senderMap['name'] ?? callerName;
            callerImage = senderMap['profile'] ?? callerImage;
            callerId = senderMap['id'] ?? callerId;
          }
        } catch (_) {}
      }

      await CallKitService.showIncomingCall(
        callId: message.data['callId'] ?? message.data['channelName'] ?? '',
        callerId: callerId,
        callerName: callerName,
        callerImage: callerImage,
        channelId: message.data['channelId'] ?? message.data['channelName'] ?? '',
        historyId: message.data['historyId'] ?? message.data['id'] ?? '',
        isVideo: message.data['callType'] == 'video' || message.data['type'] == 'video_call',
      );
    } else if (message.data['type'] == 'end_call') {
      final callId = message.data['callId'] ?? '';
      if (callId.isNotEmpty) await CallKitService.endCall(callId);
      // If the app somehow has a context, pop the screen too
      CallKitListenerService.popCallScreen();
    }
  }

  /// 🔹 INITIALIZE EVERYTHING
  static Future<void> init() async {
    // 1️⃣ Request notification permissions (iOS + Android 13)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      log('User declined notification permissions');
      return;
    }

    // 2️⃣ Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings: initSettings);

    if (Platform.isIOS) {
      String? apnsToken = await messaging.getAPNSToken();
      int retries = 0;
      while (apnsToken == null && retries < 3) {
        await Future.delayed(const Duration(seconds: 1));
        apnsToken = await messaging.getAPNSToken();
        retries++;
      }
      log('🍏 APNs Token: $apnsToken');
      if (apnsToken == null) {
        log('⚠️ APNs Token is null. FCM token retrieval might fail (e.g. on Simulators).');
      }
    }

    try {
      final token = await messaging.getToken();
      log('📱 FCM Token: $token');
    } catch (e) {
      log('❌ Failed to get FCM token: $e');
    }

    // 3️⃣ Listen for FCM token safely (iOS-safe)
    messaging.onTokenRefresh.listen((token) {
      log('FCM Token available: $token');
      // send token to your backend here
    });

    // 4️⃣ Foreground listener
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // 5️⃣ Background listener
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 6️⃣ Notification tap handler (background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification clicked (background)');
      log(message.data.toString());
      // Navigate using GetX or Navigator if needed
    });

    log('NotificationService initialized ✅');
  }

  /// 🔹 FOREGROUND MESSAGE HANDLER
  static void _onForegroundMessage(RemoteMessage message) async {
    log('Foreground message received');

    AppLogger.info(message.data.toString());

    if (message.data['type'] == 'incoming_call') {
      String callerName = message.data['callerName'] ?? 'Unknown Caller';
      String? callerImage = message.data['callerImage'];
      String callerId = message.data['callerId'] ?? '';

      if (message.data.containsKey('sender')) {
        try {
          final senderStr = message.data['sender'];
          if (senderStr is String) {
            final senderMap = jsonDecode(senderStr);
            callerName = senderMap['name'] ?? callerName;
            callerImage = senderMap['profile'] ?? callerImage;
            callerId = senderMap['id'] ?? callerId;
          }
        } catch (_) {}
      }

      await CallKitService.showIncomingCall(
        callId: message.data['callId'] ?? message.data['channelName'] ?? '',
        callerId: callerId,
        callerName: callerName,
        callerImage: callerImage,
        channelId: message.data['channelId'] ?? message.data['channelName'] ?? '',
        historyId: message.data['historyId'] ?? message.data['id'] ?? '',
        isVideo: message.data['callType'] == 'video' || message.data['type'] == 'video_call',
      );
    } else if (message.data['type'] == 'end_call') {
      // Remote side ended the call while this app is in foreground
      final callId = message.data['callId'] ?? '';
      if (callId.isNotEmpty) await CallKitService.endCall(callId);
      CallKitListenerService.popCallScreen();
    } else {
      _showLocalNotification(message);
    }
  }

  /// 🔹 SHOW LOCAL NOTIFICATION
  static void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      notificationDetails: details,
      payload: message.data.toString(),
    );
  }
}
