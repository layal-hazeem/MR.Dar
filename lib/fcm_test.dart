import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:new_project/service/auth_service.dart';
import 'package:new_project/service/local_notification_service.dart';
import '../controller/notification_controller.dart';

Future<void> initFcm() async {
  final messaging = FirebaseMessaging.instance;

  // 1️⃣ طلب الإذن
  await messaging.requestPermission();

  // 2️⃣ جلب التوكن
  final token = await messaging.getToken();
  print("FCM TOKEN: $token");

  if (token != null) {
    try {
      await Get.find<AuthService>().sendDeviceToken(token);
      print("✅ Device token sent to backend");
    } catch (e) {
      print("❌ Failed to send device token: $e");
    }
  }


  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("NEW TOKEN: $newToken");
    try {
      await Get.find<AuthService>().sendDeviceToken(newToken);
      print("✅ New token updated on backend");
    } catch (e) {
      print("❌ Failed to update new token");
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    // 🔔 هذا اللي بيخلّي الإشعار يطلع على الشاشة
    LocalNotificationService.show(
      title: title,
      body: body,
    );

    // 🔄 تحديث الليست داخل التطبيق
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications();
    }
  });

}
