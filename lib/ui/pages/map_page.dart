import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:f_firebase_202210/ui/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loggy/loggy.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'sk.eyJ1IjoibWFuZ2VsMjEiLCJhIjoiY2xwN2h3czduMTJkYzJtcWx2N3Q5OHM0eSJ9.wbYcARI6G-0s76whD7gkvQ';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? myPosition;
  MapController mapController = MapController();
  AuthenticationController authenticationController = Get.find();
  final fecha = TextEditingController();
  final name = TextEditingController();
  final description = TextEditingController();
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

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
      markerss.add(
        Marker(
          point: myPosition!,
          builder: (context) => const Icon(
            Icons.person_pin,
            color: Colors.blueAccent,
            size: 40,
          ),
        ),
      );
    });
  }

  void moveToCurrentLocation() async {
    Position position = await determinePosition();
    mapController.move(LatLng(position.latitude, position.longitude), 18);
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  List<Marker> markerss = [];
  void _handleDate() {
    showDialog(
        context: context,
        builder: (context) {
          return DatePickerDialog(
            initialDate: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            firstDate: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            lastDate: DateTime(2100),
            key: const Key("fecha"),
          );
        }).then((pickedDate) {
      if (pickedDate != null) {
        fecha.text =
            '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}';
      }
    });
  }

  void _handleMapTap(LatLng tappedPoint) {
    bool saved = false;

    showDialog(
        context: context,
        builder: (context) {
          saved = false;

          return AlertDialog(
            title: const Text('Registrar Evento'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Nombre del evento"),
                    controller: name,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "fecha"),
                    enabled: false,
                    controller: fecha,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Descripción del evento"),
                    controller: description,
                  ),
                  IconButton.filled(
                      onPressed: _handleDate,
                      icon: const Icon(
                        Icons.access_time,
                        size: 50,
                      )),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // Aquí puede guardar el evento
                    if (fecha.text.isNotEmpty &&
                        description.text.isNotEmpty &&
                        name.text.isNotEmpty) {
                      saved = true;
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text("Error al crear evento"),
                              content: Text(
                                  "No se puede crear el evento porque alguno de los campos está vacío"),
                            );
                          });
                    }
                  },
                  child: const Text('Guardar')),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          );
        }).then((_) {
      if (saved) {
        bool tooClose = false;
        for (var m in markerss) {
          double distance = calculateDistance(m.point, tappedPoint);
          if (distance < 30) {
            tooClose = true;
            break;
          }
        }
        if (!tooClose) {
          setState(() {
            markerss.add(Marker(
              point: tappedPoint,
              builder: (context) => const Icon(Icons.place, color: Colors.red),
            ));
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Error al crear evento"),
                  content: Text(
                      "No se puede crear el evento porque ya existe uno cerca"),
                );
              });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                onTap: (tapPosition, point) => _handleMapTap(point),
                center: myPosition,
                minZoom: 5,
                maxZoom: 100,
                zoom: 18,
              ),
              nonRotatedChildren: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken':
                        'sk.eyJ1IjoibWFuZ2VsMjEiLCJhIjoiY2xwN2h3czduMTJkYzJtcWx2N3Q5OHM0eSJ9.wbYcARI6G-0s76whD7gkvQ',
                    'id': 'mapbox/streets-v12',
                  },
                ),
                MarkerLayer(
                  markers: markerss,
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: Icon(Icons.my_location)),
    );
  }

  double calculateDistance(LatLng p1, LatLng p2) {
    return Geolocator.distanceBetween(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude);
  }
}