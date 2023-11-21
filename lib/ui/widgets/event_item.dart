import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  final String name;
  final String distance;
  final String image;
  final int index;

  const EventItem({
    super.key,
    required this.name,
    required this.distance,
    required this.image,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? Colors.white
            : const Color.fromARGB(255, 77, 77, 160),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Imagen
            Image.asset(image, width: 100),

            const SizedBox(width: 16),

            // Nombre y distancia
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: index % 2 == 0
                            ? const Color.fromARGB(255, 40, 40, 128)
                            : Colors.white)),
                Text(distance,
                    style: TextStyle(
                        color: index % 2 == 0
                            ? const Color.fromARGB(255, 77, 77, 160)
                            : Colors.white))
              ],
            )
          ],
        ),
      ),
    );
  }
}
