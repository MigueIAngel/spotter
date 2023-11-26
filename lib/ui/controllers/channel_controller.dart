import 'dart:async';

import 'package:f_firebase_202210/ui/controllers/authentication_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/message.dart';

class ChannelController extends GetxController {
  var messages = <Message>[].obs;

  final databaseRef = FirebaseDatabase.instance.ref();

  late StreamSubscription<DatabaseEvent> newEntryStreamSubscription;

  final AuthenticationController authenticationController = Get.find();

  void start(String ch) {
    messages.clear();

    newEntryStreamSubscription = databaseRef
        .child("chanel")
        .child(ch)
        .onChildAdded
        .listen(_onEntryAdded);
  }

  void stop() {
    newEntryStreamSubscription.cancel();
  }

  _onEntryAdded(DatabaseEvent event) {
    final json = event.snapshot.value as Map<dynamic, dynamic>;
    messages.add(Message.fromJson(event.snapshot, json));
  }

  Future<void> sendMsg(String text, String ch) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      databaseRef.child('chanel').child(ch).push().set({
        'text': '${authenticationController.userEmail().split('@')[0]}\n $text',
        'uid': uid
      });
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }
}
