import 'package:firebase_database/firebase_database.dart';

class Evento {
  String? key;
  String nombre;
  String fecha;
  String descripcion;
  String ubicacion;
  String? user;
  Evento(this.nombre, this.fecha, this.descripcion, this.ubicacion);

  Evento.fromJson(DataSnapshot snapshot, Map<dynamic, dynamic> json)
      : key = snapshot.key ?? "0",
        nombre = json['nombre'] ?? "event",
        fecha = json['fecha'] ?? DateTime.now(),
        descripcion = json['descripcion'] ?? "description",
        ubicacion = json['ubicacion'] ?? "12.312333, 79,213213",
        user = json['uid'] ?? 'uid';
  toJson() {
    return {
      "nombre": nombre,
      "fecha": fecha,
      "descripcion": descripcion,
      "ubicacion": ubicacion
    };
  }
}
