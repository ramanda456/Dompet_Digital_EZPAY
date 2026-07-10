import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'package:aplikasi_ezpay_1/landing/landing_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Wajib top-level + pragma agar tidak di-strip di release.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

const AndroidNotificationChannel _androidFcmChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Notifikasi penting dari EZ Pay',
  importance: Importance.max,
);

Future<void> _initLocalNotifications() async {
  const androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(_androidFcmChannel);
}

Future<void> _initFirebaseMessaging() async {
  final messaging = FirebaseMessaging.instance;

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (kDebugMode) {
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }

  final token = await messaging.getToken();
  if (kDebugMode) {
    debugPrint('FCM token: $token');
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    if (kDebugMode) {
      debugPrint('FCM token refreshed: $newToken');
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (kDebugMode) {
      debugPrint('FCM foreground: ${message.notification?.title}');
    }

    final notification = message.notification;
    final title = notification?.title ?? 'Notifikasi';
    final body = notification?.body ??
        (message.data.isNotEmpty ? message.data.toString() : 'Pesan baru');

    final rawId = message.messageId?.hashCode ??
        message.sentTime?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;
    final notificationId = rawId.abs() % 0x7FFFFFFF;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidFcmChannel.id,
          _androidFcmChannel.name,
          channelDescription: _androidFcmChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  try {
    await _initLocalNotifications();
    await _initFirebaseMessaging();
  } catch (e, stack) {
    await FirebaseCrashlytics.instance.recordError(
      e,
      stack,
      reason: 'Gagal inisialisasi notifikasi / FCM',
      fatal: false,
    );
    if (kDebugMode) {
      debugPrint('Notification/FCM init error: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _listenForNotificationOpens();
  }

  void _onNotificationOpened(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint(
        'Notifikasi dibuka: messageId=${message.messageId}, data=${message.data}',
      );
    }
  }

  Future<void> _listenForNotificationOpens() async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _onNotificationOpened(initial);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpened);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
