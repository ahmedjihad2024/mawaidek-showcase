// import 'dart:async';
// import 'dart:ui';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:dartz/dartz.dart';
// import 'package:mawadk/app/services/app_preferences.dart';
// import 'package:mawadk/app/services/awesome_notifications.dart';
// import 'package:mawadk/data/network/dio_factory.dart';
// import 'package:mawadk/data/network/error_handler/failure.dart';
// import 'package:mawadk/data/network/internet_checker.dart';
// import 'package:mawadk/data/repository/repository_impl.dart';
// import 'package:mawadk/data/request/request.dart';
// import 'package:mawadk/data/responses/responses.dart';
// import 'package:flutter/foundation.dart';
// import 'package:mawadk/presentation/common/ui_components/platform_safe_area.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../data/network/api.dart';

// class MyBackgroundService {
//   static final MyBackgroundService _instance = MyBackgroundService._();
//   static MyBackgroundService get instance => _instance;
//   MyBackgroundService._();

//   final service = FlutterBackgroundService();

//   Future<void> initialize() async {
//     // First initialize the notification channel with minimum visibility
//     await MyAwesomeNotifications.instance.initialize(isForeground: true);

//     await service.configure(
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//       androidConfiguration: AndroidConfiguration(
//         autoStart: true,
//         onStart: onStart,
//         isForegroundMode: true,
//         autoStartOnBoot: true,
//         notificationChannelId:
//             MyAwesomeNotifications.instance.backgroundChannelKey,
//         // Set to empty strings to minimize visibility
//         initialNotificationTitle:
//             " ", // Space character instead of empty string
//         initialNotificationContent:
//             " ", // Space character instead of empty string
//         foregroundServiceNotificationId: 888,
//         // Use only necessary foreground service types
//         foregroundServiceTypes: [AndroidForegroundType.dataSync],
//       ),
//     );
//   }

//   Future<void> start() async => await service.startService();
//   Future<bool> isRunning() async => await service.isRunning();
//   void stop() => service.invoke("stop");
//   void setAsForeground() => service.invoke("setAsForeground");
// }

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//   }

//   service.on("stop").listen((event) {
//     service.stopSelf();
//   });

//   await MyAwesomeNotifications.instance.initialize(isForeground: true);

//   AppPreferences appPreferences =
//       AppPreferences(await SharedPreferences.getInstance());

//   DioFactory dioFactory = DioFactory(appPreferences, isForNotification: true);
//   Repository repository =
//       Repository(AppServices(dioFactory), NetworkConnectivity());

//   // init get notifications use case
//   // GetNotificationsUseCase getNotificationsUseCase =
//   //     GetNotificationsUseCase(repository);

//   // // mark notification as readed use case
//   // MarkNotificationAsReadUseCase markNotificationAsReadUseCase =
//   //     MarkNotificationAsReadUseCase(repository);

//   await MyAwesomeNotifications.instance.awesomeNotifications.createNotification(
//     content: NotificationContent(
//       id: 888,
//       channelKey: MyAwesomeNotifications.instance.backgroundChannelKey,
//       customSound: '',
//       displayOnForeground: true,
//       displayOnBackground: true,
//       // title: "Retm",
//       body: "Welcome to Retm",
//     ),
//   );

//   // ✅ Start the repeating task
//   await processNotificationsLoop(
//     appPreferences,
//     // getNotificationsUseCase,
//     // markNotificationAsReadUseCase,
//   );
// }

// Future<void> processNotificationsLoop(
//   AppPreferences appPreferences,
//   // GetNotificationsUseCase getNotificationsUseCase,
//   // MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
// ) async {
//   while (true) {
//     try {
//       await appPreferences.reload();
//     } catch (_) {}

//     int page = 1;
//     bool continueFetching = true;

//     // while (continueFetching) {
//     //   Either<Failure, NotificationsResponse> result =
//     //       await getNotificationsUseCase.execute(
//     //     GetNotificationsRequest(page: page, pageSize: 10, isRead: false),
//     //   );

//     //   continueFetching = await result.fold((failure) async {
//     //     if (kDebugMode) print("❌ Error Getting Notifications");
//     //     return false;
//     //   }, (notificationsResponse) async {
//     //     if (notificationsResponse.data.isEmpty) {
//     //       if (kDebugMode) print("ℹ️   Empty Notification List");
//     //       return false;
//     //     }

//     //     for (var notification in notificationsResponse.data) {
//     //       if (!notification.isRead) {
//     //         await MyAwesomeNotifications.instance.showBasicNotification(
//     //           title: notification.title,
//     //           body: notification.message,
//     //           groupKey: notification.type,
//     //         );
//     //         if (kDebugMode) print("✅ Notification Displayed");
//     //       } else {
//     //         if (kDebugMode) print("ℹ️ No More Unread Notifications");
//     //         return false;
//     //       }
//     //     }

//     //     // Mark all as read
//     //     List<String> ids = notificationsResponse.data
//     //         .where((e) => !e.isRead)
//     //         .map((e) => e.id)
//     //         .toList();
//     //     List<Future> markFutures = ids
//     //         .map((id) => markNotificationAsReadUseCase
//     //             .execute(MarkNotificationAsReadRequest(id: id)))
//     //         .toList();

//     //     await Future.wait(markFutures);

//     //     // Decide whether to fetch next page
//     //     if (page < notificationsResponse.totalPages) {
//     //       page++;
//     //       return true;
//     //     } else {
//     //       return false;
//     //     }
//     //   });
//     // }

//     // ✅ Wait before next fetch cycle
//     await Future.delayed(Duration(seconds: 30));
//   }
// }
