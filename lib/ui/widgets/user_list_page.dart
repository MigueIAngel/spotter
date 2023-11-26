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
  bool charge = false;
  final km = TextEditingController();
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

  void _handleTapbutton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            titleTextStyle: const TextStyle(
              color: Colors.blue, // Color del texto del título
              fontSize: 22.0, // Tamaño del texto del título
              fontWeight: FontWeight.bold, // Peso del texto del título
            ),
            contentTextStyle: const TextStyle(
              color: Colors.black, // Color del texto del contenido
              fontSize: 18.0, // Tamaño del texto del contenido
            ),
            title: const Text('Cambio de parametros'),
            content: TextField(
                controller: km,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Distancia en kilometos",
                )),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () async {
                    if (km.text.isNotEmpty && km.text.isNum) {
                      Navigator.pop(context);
                      charge = true;
                      await loadMarkersFromDatabase();
                      charge = false;
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            titleTextStyle: const TextStyle(
                              color: Colors.blue, // Color del texto del título
                              fontSize: 22.0, // Tamaño del texto del título
                              fontWeight:
                                  FontWeight.bold, // Peso del texto del título
                            ),
                            contentTextStyle: const TextStyle(
                              color:
                                  Colors.black, // Color del texto del contenido
                              fontSize: 18.0, // Tamaño del texto del contenido
                            ),
                            title: const Text('Oops!'),
                            content: const Text(
                              "Introduzca una distancia en kilometros",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Color del texto del botón
                                    fontWeight: FontWeight
                                        .bold, // Peso del texto del botón
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Aceptar')),
            ],
          );
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
      if (eventDate.isAfter(currentDate) ||
          eventDate.isAtSameMomentAs(currentDate)) {
        if (km.text.isNotEmpty && km.text.isNum) {
          if (distance < double.parse(km.text) * 1000) {
            filteredEvents.add(evento);
          }
        } else if (distance < 50000) {
          filteredEvents.add(evento);
        }
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
    return (myPosition == null || charge)
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
            floatingActionButton: FloatingActionButton(
                onPressed: () => _handleTapbutton(),
                backgroundColor: const Color.fromARGB(255, 77, 77, 160),
                child: const Icon(Icons.edit_location_rounded)),
          );
  }
}
