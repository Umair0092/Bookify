import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Busmodel {
  final String id;
  final String title;
  final String time;
  final String from;
  final String to;
  final String duration;
  final String date;
  final List<dynamic> facilities;
  final int ticketcost;
  final int tickets;

  Busmodel({
    required this.id,
    required this.title,
    required this.time,
    required this.from,
    required this.to,
    required this.duration,
    required this.date,
    required this.facilities,
    required this.ticketcost,
    required this.tickets,
  });

  factory Busmodel.fromMap(Map<String, dynamic> data, String documentId) {
    return Busmodel(
      id: documentId,
      title: data['title'] ?? '',
      time: data['time'] ?? '',
      from: data['FROM'] ?? '',
      to: data['TO'] ?? '',
      duration: data['duration'] ?? '',
      date: data['date'] ?? '',
      facilities: data['facilities'] ?? [],
      ticketcost: data['ticketcost'] ?? 0,
      tickets: data['tickets'] ?? 0,
    );
  }
}



class BusService {
  final CollectionReference _busCollection =
      FirebaseFirestore.instance.collection('bus');

  Future<List<Busmodel>> fetchBuses() async {
    final snapshot = await _busCollection.get();

    return snapshot.docs.map((doc) {
      return Busmodel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}


