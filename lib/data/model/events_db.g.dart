// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventoAdapter extends TypeAdapter<Evento> {
  @override
  final int typeId = 0;

  @override
  Evento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Evento(
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    )
      ..key = fields[0] as String?
      ..user = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, Evento obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.fecha)
      ..writeByte(3)
      ..write(obj.descripcion)
      ..writeByte(4)
      ..write(obj.ubicacion)
      ..writeByte(5)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
