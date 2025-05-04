import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class localServicemodel {
  final String id;
  final List<dynamic> time;
  final int cost;
  final int rating;
  final List<dynamic> services;
  final String loc;

  localServicemodel( {
    required this.id,
    required this.time,
    required this.cost,
    required this.rating,
    required this.services, required this.loc
  });

  factory localServicemodel.fromMap(Map<String, dynamic> data, String documentId) {
    return localServicemodel(
      id: documentId,
      services: data['services'] ?? [],
      time: data['time'] ?? [],
      cost: data['rate'] ?? 0,
      rating: data['rating'] ?? 0,
      loc:data['location'] ?? 0,
    );
  }
}



class Localserv {
  final CollectionReference _busCollection =
      FirebaseFirestore.instance.collection('localservices');

  Future<List<localServicemodel>> fetchlocal() async {
    final snapshot = await _busCollection.get();

    return snapshot.docs.map((doc) {
      return localServicemodel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}


