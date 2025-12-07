import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // مسح التوكن
    Get.offAll(() => Login()); // الانتقال لشاشة Login ومسح تاريخ الصفحات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('MR.Dar')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // زر تسجيل الخروج
          ),
        ],
      ),
      drawer: Drawer(
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
              leading: const Icon(Icons.person_sharp),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout, // نفس الزر بالـ Drawer
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SearchBar(
          leading: SizedBox(
            width: 40,
            child: Icon(Icons.search, color: Colors.grey[400]),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          hintText: "Search",
          hintStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.grey),
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
