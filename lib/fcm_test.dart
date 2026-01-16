import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_project/service/auth_service.dart';
import 'package:new_project/service/local_notification_service.dart';
import '../controller/notification_controller.dart';

Future<void> initFcm() async {
  final messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  final token = await messaging.getToken();
  debugPrint("FCM TOKEN: $token");

  if (token != null) {
    try {
      await Get.find<AuthService>().sendDeviceToken(token);
      debugPrint("Device token sent to backend");
    } catch (e) {
      debugPrint(" Failed to send device token: $e");
    }
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    debugPrint("NEW TOKEN: $newToken");
    try {
      await Get.find<AuthService>().sendDeviceToken(newToken);
      debugPrint(" New token updated on backend");
    } catch (e) {
      debugPrint(" Failed to update new token");
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    LocalNotificationService.show(title: title, body: body);

    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications();
    }
  });
}
