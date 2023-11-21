import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:f_firebase_202210/ui/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../controllers/authentication_controller.dart';
import '../widgets/chat_page.dart';
import '../widgets/user_list_page.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  int _selectIndex = 0;
  AuthenticationController authenticationController = Get.find();
  static final List<Widget> _widgets = <Widget>[
    const UserListPage(),
    const ChatPage(),
    const MapScreen()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  _logout() async {
    try {
      await authenticationController.logout();
    } catch (e) {
      logError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 77, 77, 160),
          title: const Center(
            child: Image(
              image: AssetImage('assets/logoG.png'),
              width: 100,
              height: 100,
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  size: 30,
                ),
                onPressed: () {
                  _logout();
                }),
          ]),
      body: _widgets.elementAt(_selectIndex),
      bottomNavigationBar: CurvedNavigationBar(
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 35,
            color: Colors.white,
          ),
          Icon(
            Icons.chat_rounded,
            size: 35,
            color: Colors.white,
          ),
          Icon(
            Icons.map,
            size: 35,
            color: Colors.white,
          ),
        ],
        height: 60,
        letIndexChange: (index) => true,
        color: const Color.fromARGB(255, 77, 77, 160),
        buttonBackgroundColor: const Color.fromARGB(255, 196,167,125),
        backgroundColor: const Color.fromARGB(0, 201, 16, 16).withOpacity(0),
        index: _selectIndex,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 170),
        onTap: _onItemTapped,
      ),
    );
  }
}
