import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:mawadk/app/app.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/views/home/view/screens/home_view.dart';

import '../../presentation/views/home/bloc/home_bloc.dart';
import 'awesome_notifications.dart';

// Top-level background message handler. Must be a global or static function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("💬 Background message received: ${message.data}");
  // Initialize channels minimally in background to ensure we can display
  await MyAwesomeNotifications.instance.initialize(isBackground: true);

  await MyAwesomeNotifications.instance.showBasicNotification(
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    groupKey: message.data['type'],
    bigPicture: message.data['image'],
    payload: {
      'remote_message': jsonEncode(message.toMap()),
    },
  );
}

class FirebaseMessegingServices {
  FirebaseMessegingServices._();
  static final FirebaseMessegingServices instance =
      FirebaseMessegingServices._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static bool _backgroundHandlerRegistered = false;

  /// Cached FCM token to avoid repeated async calls
  String? _cachedToken;

  /// Get FCM token with iOS APNs wait logic and retry.
  /// On iOS, APNs token must be available before FCM token can be generated.
  Future<String?> get fcmToken async {
    // Return cached token if available
    if (_cachedToken != null) {
      return _cachedToken;
    }

    String? token;
    try {
      // On iOS, ensure APNs token is ready before requesting FCM token
      if (Platform.isIOS) {
        await _ensureApnsToken();
      }

      token = await _messaging.getToken();

      // If still null on iOS, retry after a short delay
      if (token == null && Platform.isIOS) {
        debugPrint("⚠️ FCM token null on iOS, retrying after 2s...");
        await Future.delayed(const Duration(seconds: 2));
        token = await _messaging.getToken();
      }

      // Third attempt with longer delay
      if (token == null && Platform.isIOS) {
        debugPrint("⚠️ FCM token still null on iOS, final retry after 3s...");
        await Future.delayed(const Duration(seconds: 3));
        token = await _messaging.getToken();
      }

      if (token != null) {
        _cachedToken = token;
        debugPrint("✅ FCM Token obtained: ${token.substring(0, 20)}...");
      } else {
        debugPrint("❌ FCM Token is null after all retries");
      }
    } catch (e) {
      debugPrint("❌ Error getting FCM token: $e");
    }
    return token;
  }

    Future<void> deleteFCMToken() async {
    try {
      await _messaging.deleteToken();
      _cachedToken = null;
    } catch (e) {}
  }

  /// Ensure APNs token is available on iOS (required for FCM to work)
  Future<void> _ensureApnsToken() async {
    String? apnsToken = await _messaging.getAPNSToken();
    if (apnsToken != null) return;

    // Retry up to 3 times with increasing delays
    for (int i = 1; i <= 3; i++) {
      debugPrint("⏳ Waiting for APNs token (attempt $i/3)...");
      await Future.delayed(Duration(seconds: i * 2));
      apnsToken = await _messaging.getAPNSToken();
      if (apnsToken != null) {
        debugPrint("✅ APNs token received on attempt $i");
        return;
      }
    }
    debugPrint("⚠️ APNs token not available after 3 attempts");
  }

  Future<RemoteMessage?> get initialMessage => _messaging.getInitialMessage();

  Future<void> initialize() async {
    await _messaging.setAutoInitEnabled(true);
    await requestNotificationPermission();

    // iOS: Ensure APNs token is available before FCM token registration
    if (Platform.isIOS) {
      await _ensureApnsToken();
    }

    // iOS: Show notifications as banners/sounds even when app is in foreground
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await MyAwesomeNotifications.instance.initialize();

    // // Register background handler early and only once
    // if (!_backgroundHandlerRegistered) {
    //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    //   _backgroundHandlerRegistered = true;
    // }

    // Listen for token refresh - update cached token
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint("🔄 FCM Token refreshed: ${newToken.substring(0, 20)}...");
      _cachedToken = newToken;
      if(kDebugMode){
        print("FCM Token refreshed: $newToken");
      }
      // Note: Token will be sent to backend on next login/verify
    });

    // Pre-fetch and cache the token
    try {
      if (Platform.isIOS) {
        await _ensureApnsToken();
      }
      final token = await _messaging.getToken();
      if (token != null) {
        _cachedToken = token;
        if(kDebugMode){
          print("FCM Token pre-cached during init: $token");
        }
        debugPrint("✅ FCM Token pre-cached during init");
      }
    } catch (e) {
      debugPrint("⚠️ Could not pre-cache FCM token: $e");
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("💬 Foreground message received");
      final notification = message.notification;
      final title = notification?.title ?? '';
      final body = notification?.body ?? '';

      // On iOS, the system already shows the notification via
      // setForegroundNotificationPresentationOptions above.
      // Only use AwesomeNotifications on Android to avoid duplicates.
      if (!Platform.isIOS) {
        await MyAwesomeNotifications.instance.showBasicNotification(
          title: title,
          body: body,
          groupKey: message.data['type'],
          bigPicture: message.data['image'],
          payload: {
            'remote_message': jsonEncode(message.toMap()),
          },
        );
      }
    });
  }

  Future<void> requestNotificationPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  Future<void> handleInitialMessage() async {
    final _initialMessage = await this.initialMessage;
    if (_initialMessage != null) {
      handleNotificationTap(_initialMessage);
    }

    // App in background and user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationTap);
  }

  void handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification tap data: ' + message.data.toString());
    }

    if (message.data['type'] == "Booking" &&
        message.data['type_id'] != null &&
        HomeView.homeBloc != null) {
      final bookingId = int.parse(message.data['type_id']);
      NAVIGATOR_KEY.currentState!
          .pushNamed(RoutesManager.bookingDetails.route, arguments: {
        'booking-id': bookingId,
        'on-review-submitted': () {
          HomeView.homeBloc!.add(
            UpdateBookingRatedEvent(
              bookingId: bookingId,
            ),
          );
        },
        'on-booking-cancelled': () {
          HomeView.homeBloc!.add(
            CancelBookingUpdateEvent(
              bookingId: bookingId,
            ),
          );
        },
      });
    } else
      NAVIGATOR_KEY.currentState!.pushNamed(
        RoutesManager.notifications.route,
        arguments: {
          'on-review-submitted': (int bookingId) {
            HomeView.homeBloc!.add(
              UpdateBookingRatedEvent(
                bookingId: bookingId,
              ),
            );
          },
          'on-booking-cancelled': (int bookingId) {
            HomeView.homeBloc!.add(
              CancelBookingUpdateEvent(
                bookingId: bookingId,
              ),
            );
          },
        },
      );
  }

  Future<void> handleInitialMessageAndMessageTapped() async {
    Future.microtask(() async {
      try {
        await FirebaseMessegingServices.instance.handleInitialMessage();
        await MyAwesomeNotifications.instance.listenToMessageTapped();
      } catch (_) {}
    });
  }
}
