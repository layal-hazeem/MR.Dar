import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_project/service/local_notification_service.dart';
import 'package:new_project/view/base_url_page.dart';
import 'package:new_project/view/onboarding/onboarding_screen.dart';
import 'fcm_test.dart';
import 'controller/locale/locale.dart';
import 'view/apartment_details_page.dart';
import 'core/bindings/app_bindings.dart';
import 'view/Splash.dart';
import 'view/WelcomePage.dart';
import 'view/home.dart';
import 'view/login.dart';
import 'view/signup.dart';
import 'package:get_storage/get_storage.dart';
import 'core/theme/theme_service.dart';
import 'core/api/api_config.dart';
import 'core/storage/app_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  final storage = GetStorage();

  final themeService = ThemeService(storage);
  Get.put<ThemeService>(themeService, permanent: true);
  Get.changeThemeMode(themeService.themeMode);

  await Firebase.initializeApp();
  await initFcm();
  await LocalNotificationService.init();

  final savedBaseUrl = await AppStorage.getBaseUrl();
  if (savedBaseUrl != null) {
    ApiConfig.baseUrl = savedBaseUrl;
    AppBindings().dependencies();
  }
  runApp(MyApp(hasBaseUrl: savedBaseUrl != null));
}

class MyApp extends StatelessWidget {
  final bool hasBaseUrl;

  const MyApp({super.key, required this.hasBaseUrl});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),

          locale: Get.deviceLocale,
          translations: MyLocale(),

          initialBinding: null,
          debugShowCheckedModeBanner: false,
          theme: themeService.lightTheme,
          darkTheme: themeService.darkTheme,
          themeMode: themeService.themeMode,
          home: hasBaseUrl ? Splash() : BaseUrlPage(),
          getPages: [
            GetPage(name: "/home", page: () => Home()),
            GetPage(name: "/signup", page: () => Signup()),
            GetPage(name: "/login", page: () => Login()),
            GetPage(name: "/welcome", page: () => WelcomePage()),
            // ✅ أضف هذه الصفحة
            GetPage(
              name: "/apartmentDetails",
              page: () {
                final apartment = Get.arguments;
                return ApartmentDetailsPage(apartment: apartment);
              },
            ),
            GetPage(name: "/onboarding", page: () => OnboardingScreen()),
          ],
        );
      },
    );
  }
}
