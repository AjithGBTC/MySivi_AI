import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'OffersPage.dart';
import 'SettingsPage.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int tabIndex = 0;

  final pages =  [
    HomePage(),
    OffersPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: tabIndex,
        onTap: (i) => setState(() => tabIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: "Offers"),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
    );
  }
}