import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authcontroller.dart';
import '../controller/homecontroller.dart';
import '../core/theme/theme_service.dart';
import 'homeContent.dart';
import 'favourite.dart';
import 'myAccount.dart';
import 'myRent.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final HomeController controller = Get.put(HomeController());
  final ThemeService themeService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = controller.currentIndex.value;

      return Scaffold(
        appBar: _buildAppBar(currentIndex),
        drawer: currentIndex == 0 ? _buildDrawer() : null,
        body: _buildIndexedStack(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    });
  }

  // ========================= AppBar =========================
  AppBar _buildAppBar(int index) {
    String title;

    switch (index) {
      case 0:
        title = 'MR.Dar';
        break;
      case 1:
        title = 'My Rents';
        break;
      case 2:
        title = 'Favourite';
        break;
      case 3:
        title = 'My Account';
        break;
      default:
        title = 'MR.Dar';
    }

    return AppBar(
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 27),
      ),
      backgroundColor: const Color(0xFF274668),
      foregroundColor: Colors.white,

      // يظهر زر تسجيل الخروج فقط بصفحة الـ Home
      actions: index == 0
          ? [
              Obx(() {
                final isDark = themeService.rxIsDark.value;
                return IconButton(
                  tooltip: isDark ? 'Switch to light' : 'Switch to dark',
                  onPressed: () => themeService.toggleTheme(),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) =>
                        RotationTransition(turns: anim, child: child),
                    child: isDark
                        ? const Icon(
                            Icons.dark_mode, // قمر أو أيقونة داكنة
                            key: ValueKey('dark'),
                            size: 22,
                          )
                        : const Icon(
                            Icons.light_mode, // شمس
                            key: ValueKey('light'),
                            size: 22,
                          ),
                  ),
                );
              }),
            ]
          : [],

      // Drawer فقط بصفحة Home
      leading: index == 0
          ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,
    );
  }

  // ========================= Drawer =========================
  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF274668)),
            child: Center(
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: const Text('Profile Settings'),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.switch_account),
            title: const Text('Switch account'),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language '),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support '),
            onTap: () {
              Get.back();
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Get.defaultDialog(
                title: "Logout From App",
                titleStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                middleText: "Are you sure you need to logout ?",
                middleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
                backgroundColor: Colors.grey,
                radius: 10,
                textCancel: "No",
                cancelTextColor: Colors.white,
                textConfirm: "Yes",
                confirmTextColor: Colors.white,
                onCancel: () {
                  Get.back();
                },
                onConfirm: () {
                  final auth = Get.find<AuthController>();
                  auth.logout();
                },
                buttonColor: Color(0xFF274668),
              );
            },
          ),
        ],
      ),
    );
  }

  // ========================= Body (IndexedStack) =========================
  Widget _buildIndexedStack() {
    return Obx(() {
      return IndexedStack(
        index: controller.currentIndex.value,
        children: [HomeContent(), MyRent(), Favourite(), MyAccount()],
      );
    });
  }

  // ========================= BottomNavigationBar =========================
  Widget _buildBottomNavigationBar() {
    return Obx(() {
      return BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: (index) => controller.changeTab(index),
        iconSize: 26,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF274668),
        unselectedItemColor: Colors.black45,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_added_outlined),
            activeIcon: Icon(Icons.bookmark_added),
            label: "My Rents",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            activeIcon: Icon(Icons.person_2),
            label: "My account",
          ),
        ],
      );
    });
  }
}
