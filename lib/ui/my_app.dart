import 'package:f_firebase_202210/ui/controllers/channel_controller.dart';
import 'package:f_firebase_202210/ui/controllers/firestore_controller.dart';
import 'package:f_firebase_202210/ui/firebase_cental.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/authentication_controller.dart';
import 'controllers/chat_controller.dart';

import 'controllers/user_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AuthenticationController());
    Get.put(ChatController());
    Get.put(UserController());
    Get.put(FirestoreController());
    Get.put(ChannelController());
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const FirebaseCentral());
  }
}
