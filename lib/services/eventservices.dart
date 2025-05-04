import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Eventmodel {
  final String id;
  final String artist;
  final String time;
  final String category;
  final String place;
  final String eventname;
  final String date;
  final List<dynamic> highlights;
  final int cost;
  final int ticket;

  Eventmodel({
    required this.id,
    required this.artist,
    required this.time,
    required this.category,
    required this.place,
    required this.eventname,
    required this.date,
    required this.highlights,
    required this.cost,
    required this.ticket,
  });

  factory Eventmodel.fromMap(Map<String, dynamic> data, String documentId) {
    return Eventmodel(
      id: documentId,
      artist: data['artist'] ?? '',
      time: data['time'] ?? '',
      category: data['category'] ?? '',
      place: data['place'] ?? '',
      eventname: data['title'] ?? '',
      date: data['date'] ?? '',
      highlights: data['highlights'] ?? [],
      cost: data['cost'] ?? 0,
      ticket: data['ticket'] ?? 0,
    );
  }
}



class EventService {
  final CollectionReference _busCollection =
      FirebaseFirestore.instance.collection('events');

  Future<List<Eventmodel>> fetchevents() async {
    final snapshot = await _busCollection.get();

    return snapshot.docs.map((doc) {
      return Eventmodel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}


