import 'package:f_firebase_202210/ui/controllers/firestore_controller.dart';
import 'package:f_firebase_202210/ui/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/events.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  FirestoreController firestoreController = Get.find();

  @override
  void initState() {
    firestoreController.start();
    super.initState();
  }

  @override
  void dispose() {
    firestoreController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView.builder(
          itemCount: firestoreController.markers.length,
          itemBuilder: (context, index) {
            Evento event = firestoreController.markers[index];
            return GestureDetector(
              onTap: () {
                // Handle tap event, e.g., navigate to event details page
              },
              child: EventItem(
                name: event.nombre,
                distance: '3 km', // You might want to get the actual distance
                image: 'assets/rock.jpeg',
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }
}
