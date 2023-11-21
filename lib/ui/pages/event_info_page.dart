import 'package:flutter/material.dart';

class EventInfoPage extends StatelessWidget {
  final String eventTitle;
  final String eventImage;
  final String eventDate;
  final String eventTime;
  final String eventDescription;
  final String eventLocation;

  const EventInfoPage({
    super.key,
    required this.eventTitle,
    required this.eventImage,
    required this.eventDate,
    required this.eventTime,
    required this.eventDescription,
    required this.eventLocation,
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
                            onPressed: () {},
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
                              backgroundColor: const Color.fromARGB(255, 77, 77, 160),
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
              child: const Placeholder(), // aquí iría el mapa
            ),
          ],
        ),
      ),
    );
  }
}
