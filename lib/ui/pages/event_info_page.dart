import 'package:f_firebase_202210/ui/widgets/channel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EventInfoPage extends StatelessWidget {
  final String k;
  final String eventTitle;
  final String eventImage;
  final String eventDate;
  final String eventTime;
  final String eventDescription;
  final String eventLocation;

  const EventInfoPage({
    super.key,
    required this.k,
    required this.eventTitle,
    required this.eventImage,
    required this.eventDate,
    required this.eventTime,
    required this.eventDescription,
    required this.eventLocation,
    required int index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 77, 77, 160),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        title: const Center(
            child: Text('Evento',
                style: TextStyle(fontSize: 30, color: Colors.white))),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(eventTitle,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold))),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage(eventImage),
                    width: 250,
                    height: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Fecha",
                            style: TextStyle(
                              color: Color.fromARGB(255, 77, 77, 160),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            eventDate,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Text("Hora",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 77, 77, 160),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Text(eventTime, style: const TextStyle(fontSize: 16)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 77, 77, 160),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChannelPage(
                                    ch: k,
                                  ),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat, size: 18),
                                SizedBox(width: 8),
                                Text('Chat'),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 77, 77, 160),
                            ),
                            onPressed: () {},
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.local_activity, size: 18),
                                SizedBox(width: 8),
                                Text('Ticket'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Descripción
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(eventDescription,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 40, 40, 128),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic))),

            // Mapa
            Container(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(
                    double.parse(eventLocation.split(',')[0]),
                    double.parse(eventLocation.split(',')[1]),
                  ),
                  minZoom: 5,
                  maxZoom: 100,
                  zoom: 14,
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
                  MarkerLayer(markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        double.parse(eventLocation.split(',')[0]),
                        double.parse(eventLocation.split(',')[1]),
                      ),
                      builder: (ctx) => Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                    )
                  ]),
                ],
              ), // aquí iría el mapa
            ),
          ],
        ),
      ),
    );
  }
}
