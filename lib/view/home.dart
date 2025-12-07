import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/view/login.dart';
import 'package:new_project/view/signup.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('MR.Dar'))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF274668)),
              child: Center(
                  child: Text('Drawer Header',
                  style: TextStyle(color: Colors.white),),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_sharp),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: SearchBar(
          leading: SizedBox(
            width: 40,
            child: Icon(Icons.search, color: Colors.grey[400]),
          ),

          backgroundColor: MaterialStatePropertyAll(Colors.white),
          hintText: "Search",
          hintStyle: MaterialStatePropertyAll(
            TextStyle(color: Colors.grey),
          ),
          textStyle: MaterialStatePropertyAll(
            TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
