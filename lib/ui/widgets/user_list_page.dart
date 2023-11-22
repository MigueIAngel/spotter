import 'package:f_firebase_202210/ui/controllers/firestore_controller.dart';
import 'package:f_firebase_202210/ui/widgets/event_item.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../data/model/events.dart';
import '../pages/event_info_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  FirestoreController firestoreController = Get.find();
  LatLng? myPosition;
  List<Evento> events = [];
  @override
  void initState() {
    firestoreController.start();
    getCurrentLocation();
    listenToEvents();
    super.initState();
  }

  @override
  void dispose() {
    firestoreController.stop();
    super.dispose();
  }

  void listenToEvents() async {
    firestoreController.databaseRef
        .child('events')
        .onChildAdded
        .listen((event) {
      loadMarkersFromDatabase();
    });
    firestoreController.databaseRef
        .child('events')
        .onChildRemoved
        .listen((event) {
      loadMarkersFromDatabase();
    });
  }

  Future<void> loadMarkersFromDatabase() async {
    DateTime currentDate = DateTime.now();

    List<Evento> e = await firestoreController.getAll();
    List<Evento> filteredEvents = [];
    await getCurrentLocation();
    for (Evento evento in e) {
      double distance = calculateDistance(
          LatLng(double.parse(evento.ubicacion.split(',')[0]),
              double.parse(evento.ubicacion.split(',')[1])),
          myPosition == null ? LatLng(0, 0) : myPosition!);
      DateTime eventDate = DateTime.parse("${evento.fecha} 23:59:00.000000");
      if ((eventDate.isAfter(currentDate) ||
              eventDate.isAtSameMomentAs(currentDate)) &&
          distance < 50000) {
        filteredEvents.add(evento);
      }
    }
    if (mounted) {
      setState(() {
        // Update the events list only if the widget is still mounted
        events = filteredEvents;
      });
    }
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    Position position = await determinePosition();
    if (mounted) {
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  double calculateDistance(LatLng p1, LatLng p2) {
    return Geolocator.distanceBetween(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return myPosition == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                Evento event = events[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventInfoPage(
                                k: event.key!,
                                eventTitle: event.nombre,
                                eventDate: event.fecha,
                                eventDescription: event.descripcion,
                                eventImage: 'assets/rock.jpeg',
                                eventLocation: event.ubicacion,
                                eventTime: "05:00PM",
                                index: index,
                              )),
                    );
                  },
                  child: EventItem(
                    name: event.nombre,
                    distance: myPosition == null
                        ? ""
                        : "${(calculateDistance(myPosition!, LatLng(
                              double.parse(event.ubicacion.split(',')[0]),
                              double.parse(event.ubicacion.split(',')[1]),
                            )) / 1000).toStringAsFixed(2)}km",
                    image: 'assets/rock.jpeg',
                    index: index,
                  ),
                );
              },
            ),
          );
  }
}
