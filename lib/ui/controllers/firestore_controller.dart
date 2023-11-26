import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/events.dart';

class FirestoreController extends GetxController {
  var markers = <Evento>[].obs;
  final databaseRef = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> newEntryStreamSubscription;
  late StreamSubscription<DatabaseEvent> updateEntryStreamSubscription;
  void start() {
    markers.clear();
    newEntryStreamSubscription =
        databaseRef.child("events").onChildAdded.listen(_onEntryAdded);

    updateEntryStreamSubscription =
        databaseRef.child("events").onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(DatabaseEvent event) {
    final json = event.snapshot.value as Map<dynamic, dynamic>;
    markers.add(Evento.fromJson(event.snapshot, json));
  }

  _onEntryChanged(DatabaseEvent event) {
    var oldEntry = markers.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    final json = event.snapshot.value as Map<dynamic, dynamic>;
    markers[markers.indexOf(oldEntry)] = Evento.fromJson(event.snapshot, json);
  }

  void stop() {
    newEntryStreamSubscription.cancel();
    updateEntryStreamSubscription.cancel();
  }

  Future<void> updateEvent(Evento element) async {
    try {
      databaseRef.child('events').child(element.key!).set({
        'nombre': element.nombre,
        'fecha': element.fecha,
        'descripcion': element.descripcion,
        'ubicacion': element.ubicacion,
      });
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }

  Future<void> saveEvent(Evento event) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      databaseRef.child('events').push().set({
        'nombre': event.nombre,
        'fecha': event.fecha,
        'ubicacion': event.ubicacion,
        'descripcion': event.descripcion,
        'uid': uid
      });
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }

  Future<void> deleteEvent(Evento element, int posicion) async {
    try {
      databaseRef.child('events').child(element.key!).remove().then(
            (value) => markers.removeAt(posicion),
          );
      print("remove event");
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }

  Future<List<Evento>> getAll() async {
    List<Evento> allEvents = [];

    DataSnapshot snapshot = await databaseRef.child('events').get();

    if (snapshot.exists) {
      for (var child in snapshot.children) {
        final json = child.value as Map<dynamic, dynamic>;
        allEvents.add(Evento.fromJson(child, json));
      }
    }

    return allEvents;
  }
}
