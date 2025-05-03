import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Flight {
  final String id;
  final String flightNumber;
  final String airline;
  final String departureCity;
  final String destinationCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int availableSeats;
  final List<FlightService> servicesOffered;
  final DateTime createdAt;
  final bool isActive;
  final String image;
  final String image2;
  final String image3;
  Flight({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.image,
    required this.image2,
    required this.image3,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.availableSeats,
    required this.servicesOffered,
    required this.createdAt,
    required this.isActive,
  });

  static Future<Flight> fromFirestore(DocumentSnapshot doc) async{
    final data = doc.data() as Map;
    try {
      final servicesSnapshot = await FirebaseFirestore.instance
          .collection('flights')
          .doc(doc.id)
          .collection('servicesOffered')
          .get();

      final services = servicesSnapshot.docs
          .map((serviceDoc) => FlightService.fromFirestore(serviceDoc))
          .toList();

      return Flight(
      id: doc.id,
      flightNumber: data["flightNumber"] ?? "",
      image: data["image"] ?? "https://plus.unsplash.com/premium_photo-1742945845688-7c11c2f6d33d?q=80&w=1518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        image2: data["image2"] ?? "https://plus.unsplash.com/premium_photo-1742945845688-7c11c2f6d33d?q=80&w=1518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        image3: data["image3"] ?? "https://plus.unsplash.com/premium_photo-1742945845688-7c11c2f6d33d?q=80&w=1518&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        airline: data["airline"] ?? "",
      departureCity: data["departureCity"] ?? "",
      destinationCity: data['destinationCity'] ?? '',
      departureTime: (data['departureTime'] as Timestamp).toDate(),
      arrivalTime: (data['arrivalTime'] as Timestamp).toDate(),
      price: (data['price'] as num).toDouble(),
      availableSeats: data["availableSeats"] ?? 0,
      servicesOffered: services,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isActive: data["isActive"] ?? false,
    );
    }catch (e) {
      throw Exception('Error parsing Flight data for ID: ${doc.id}, Error: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flightNumber': flightNumber,
      'airline': airline,
      'departureCity': departureCity,
      'destinationCity': destinationCity,
      'departureTime': Timestamp.fromDate(departureTime),
      'arrivalTime': Timestamp.fromDate(arrivalTime),
      'price': price,
      'image':image,
      'availableSeats': availableSeats,
      'servicesOffered': servicesOffered.map((service) => service.toJson())
          .toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }
}
class FlightService {
  final String name;
  final String description;

  final String iconName;

  FlightService({
    required this.name,
    required this.description,

    required this.iconName,
  });

  factory FlightService.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FlightService(

      name: data['name'] ?? '',
      description: data['description'] ?? '',
      iconName: data['iconName'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'iconName': iconName,
    };
  }
}
class Fectchdata{
  static Future<List<Flight>> fetchFlightData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('flights')
          .where('isActive', isEqualTo: true)
          .get();

      // Map each document to a Future<Flight> and wait for all to complete
      final flightFutures = querySnapshot.docs.map((doc) => Flight.fromFirestore(doc)).toList();
      final flights = await Future.wait(flightFutures);

      return flights;
    } catch (e) {
      debugPrint('Error fetching flights: $e');
      return []; // Return empty list on error
    }
  }
}
