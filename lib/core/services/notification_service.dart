// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'notification_service.g.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService.handleBackgroundMessage(message);
// }

// @riverpod
// NotificationService notificationService(Ref ref) {
//   return NotificationService();
// }

// class NotificationService {
//   static final FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//   );

//   Future<void> initialize() async {
//     // Request permissions
//     await _requestPermissions();

//     // Initialize local notifications
//     await _initializeLocalNotifications();

//     // Create Android notification channel
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(_channel);

//     // Background handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Foreground messages
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     // Message opened app from background
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

//     // Message opened app from terminated state
//     final initialMessage = await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleInitialMessage(initialMessage);
//     }
//   }

//   Future<void> _requestPermissions() async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//   }

//   Future<void> _initializeLocalNotifications() async {
//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     await _localNotifications.initialize(
//       settings: const InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       ),
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//     );
//   }

//   Future<String?> getFcmToken() async {
//     return await _firebaseMessaging.getToken();
//   }

//   Future<void> deleteToken() async {
//     await _firebaseMessaging.deleteToken();
//   }

//   Future<void> subscribeToTopic(String topic) async {
//     await _firebaseMessaging.subscribeToTopic(topic);
//   }

//   Future<void> unsubscribeFromTopic(String topic) async {
//     await _firebaseMessaging.unsubscribeFromTopic(topic);
//   }

//   static Future<void> handleBackgroundMessage(RemoteMessage message) async {
//     // Handle background message
//   }

//   void _handleForegroundMessage(RemoteMessage message) {
//     final notification = message.notification;
//     final android = message.notification?.android;

//     if (notification != null && android != null) {
//       _localNotifications.show(
//         id: notification.hashCode,
//         title: notification.title,
//         body: notification.body,
//         notificationDetails: NotificationDetails(
//           android: AndroidNotificationDetails(
//             _channel.id,
//             _channel.name,
//             channelDescription: _channel.description,
//             importance: Importance.high,
//             priority: Priority.high,
//             icon: android.smallIcon,
//           ),
//         ),
//         payload: jsonEncode(message.data),
//       );
//     }
//   }

//   void _handleMessageOpenedApp(RemoteMessage message) {
//     _navigateFromMessage(message.data);
//   }

//   void _handleInitialMessage(RemoteMessage message) {
//     _navigateFromMessage(message.data);
//   }

//   void _onNotificationTapped(NotificationResponse response) {
//     if (response.payload != null) {
//       final data = jsonDecode(response.payload!) as Map<String, dynamic>;
//       _navigateFromMessage(data);
//     }
//   }

//   void _navigateFromMessage(Map<String, dynamic> data) {
//     // Implement your navigation logic based on notification data
//     // e.g., navigate to booking, chat, etc.
//     final type = data['type'] as String?;
//     // final id = data['id'] as String?;
//     switch (type) {
//       case 'booking':
//         // Navigate to booking
//         break;
//       case 'chat':
//         // Navigate to chat
//         break;
//       default:
//         // Navigate to notifications screen
//         break;
//     }
//   }
// }
