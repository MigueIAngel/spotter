import 'package:hive/hive.dart';
import 'package:firebase_database/firebase_database.dart';
part 'events_db.g.dart';

@HiveType(typeId: 0)
class Evento {
  @HiveField(0)
  String? key;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  String fecha;

  @HiveField(3)
  String descripcion;

  @HiveField(4)
  String ubicacion;

  @HiveField(5)
  String? user;

  Evento(this.nombre, this.fecha, this.descripcion, this.ubicacion);

  Evento.fromJson(DataSnapshot snapshot, Map<dynamic, dynamic> json)
      : key = snapshot.key ?? "0",
        nombre = json['nombre'] ?? "event",
        fecha = json['fecha'] ?? DateTime.now().toString(),
        descripcion = json['descripcion'] ?? "description",
        ubicacion = json['ubicacion'] ?? "12.312333, 79,213213",
        user = json['uid'] ?? 'uid';

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "fecha": fecha,
      "descripcion": descripcion,
      "ubicacion": ubicacion,
    };
  }
}
