import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Enum to identify ticket type
enum TicketType { bus, flight, event, service }

class Ticket {
  final String id;
  final String userId;
  final TicketType ticketType;
  final double cost;
  final String time;
  final DateTime date;
  final String locationFrom;
  final String? locationTo;
  final int availableTickets;

  // Optional fields for specific ticket types
  final String? title; // Bus, Event
  final String? duration; // Bus
  final List<String>? facilities; // Bus
  final String? flightNumber; // Flight
  final String? airline; // Flight
  final DateTime? arrivalTime; // Flight
  final List<Map<String, dynamic>>? servicesOffered; // Flight
  final List<String>? images; // Flight
  final bool? isActive; // Flight
  final DateTime? createdAt; // Flight
  final String? artist; // Event
  final String? category; // Event
  final List<String>? highlights; // Event
  final List<String>? services; // Service
  final int? rating; // Service

  Ticket({
    required this.id,
    required this.userId,
    required this.ticketType,
    required this.cost,
    required this.time,
    required this.date,
    required this.locationFrom,
    this.locationTo,
    required this.availableTickets,
    this.title,
    this.duration,
    this.facilities,
    this.flightNumber,
    this.airline,
    this.arrivalTime,
    this.servicesOffered,
    this.images,
    this.isActive,
    this.createdAt,
    this.artist,
    this.category,
    this.highlights,
    this.services,
    this.rating,
  });

  // Create Ticket from Firestore document
  static Future<Ticket> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    try {
      final ticketTypeStr = data['ticketType'] as String;
      final ticketType = TicketType.values.firstWhere(
        (e) => e.toString().split('.').last == ticketTypeStr,
        orElse: () => throw Exception('Invalid ticket type: $ticketTypeStr'),
      );

      final date = (data['date'] as Timestamp).toDate();
      final availableTickets = data['availableTickets'] as int? ?? 0;
      final cost = (data['cost'] as num?)?.toDouble() ?? 0.0;

      final userId = doc.reference.parent.parent!.id;

      List<Map<String, dynamic>>? servicesOffered;
      if (ticketType == TicketType.flight) {
        final servicesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('tickets')
            .doc(doc.id)
            .collection('servicesOffered')
            .get();
        servicesOffered = servicesSnapshot.docs
            .map((serviceDoc) => serviceDoc.data())
            .toList();
      }

      return Ticket(
        id: doc.id,
        userId: userId,
        ticketType: ticketType,
        cost: cost,
        time: data['time'] as String? ?? '',
        date: date,
        locationFrom: data['locationFrom'] as String? ?? '',
        locationTo: data['locationTo'] as String?,
        availableTickets: availableTickets,
        title: data['title'] as String?,
        duration: data['duration'] as String?,
        facilities: (data['facilities'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        flightNumber: data['flightNumber'] as String?,
        airline: data['airline'] as String?,
        arrivalTime: (data['arrivalTime'] as Timestamp?)?.toDate(),
        servicesOffered: servicesOffered,
        images: (data['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        isActive: data['isActive'] as bool?,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        artist: data['artist'] as String?,
        category: data['category'] as String?,
        highlights: (data['highlights'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        services: (data['services'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        rating: data['rating'] as int?,
      );
    } catch (e) {
      throw Exception('Error parsing Ticket data for ID: ${doc.id}, Error: $e');
    }
  }

  // Convert Ticket to JSON
  Map<String, dynamic> toJson() {
    return {
      'ticketType': ticketType.toString().split('.').last,
      'cost': cost,
      'time': time,
      'date': Timestamp.fromDate(date),
      'locationFrom': locationFrom,
      'locationTo': locationTo,
      'availableTickets': availableTickets,
      'title': title,
      'duration': duration,
      'facilities': facilities,
      'flightNumber': flightNumber,
      'airline': airline,
      'arrivalTime':
          arrivalTime != null ? Timestamp.fromDate(arrivalTime!) : null,
      'servicesOffered': null, // Subcollection, not in main doc
      'images': images,
      'isActive': isActive,
      'createdAt':
          createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'artist': artist,
      'category': category,
      'highlights': highlights,
      'services': services,
      'rating': rating,
      'userId': userId,
    };
  }

  // Fetch all tickets with optional filters
  static Future<List<Ticket>> fetchTickets({
    TicketType? ticketType,
    String? locationFrom,
    String? locationTo,
    DateTime? date,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be signed in to fetch tickets');
      }

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tickets');

      if (ticketType != null) {
        query = query.where('ticketType',
            isEqualTo: ticketType.toString().split('.').last);
      }
      if (locationFrom != null && locationFrom.isNotEmpty) {
        query = query.where('locationFrom', isEqualTo: locationFrom.trim());
      }
      if (locationTo != null && locationTo.isNotEmpty) {
        query = query.where('locationTo', isEqualTo: locationTo.trim());
      }
      if (date != null) {
        final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
        final endOfDay = startOfDay.add(const Duration(days: 1)).toUtc();
        query = query
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('date', isLessThan: Timestamp.fromDate(endOfDay));
      }

      final querySnapshot = await query.get();
      final ticketFutures = querySnapshot.docs
          .map((doc) => Ticket.fromFirestore(doc))
          .toList();
      return await Future.wait(ticketFutures);
    } catch (e) {
      print('Error fetching tickets: $e');
      return [];
    }
  }

  // Write a ticket to Firestore
  static Future<void> writeTicket(Ticket ticket) async {
    try {
      if (ticket.userId.isEmpty) {
        throw Exception('User ID must be provided to write a ticket');
      }

      final ticketRef = FirebaseFirestore.instance
          .collection('users')
          .doc(ticket.userId)
          .collection('tickets')
          .doc(ticket.id);

      await ticketRef.set(ticket.toJson());

      // For flights, store servicesOffered in a subcollection
      if (ticket.ticketType == TicketType.flight &&
          ticket.servicesOffered != null) {
        final servicesCollection = ticketRef.collection('servicesOffered');
        final existingServices = await servicesCollection.get();
        for (var doc in existingServices.docs) {
          await doc.reference.delete();
        }
        for (var service in ticket.servicesOffered!) {
          await servicesCollection.add(service);
        }
      }
    } catch (e) {
      print('Error writing ticket: $e');
      throw Exception('Failed to write ticket with ID: ${ticket.id}, Error: $e');
    }
  }

  
}
// 🚨 Delete a ticket (and subcollection if needed)
   Future<void> deleteTicket({
    required String userId,
    required String ticketId,
    required TicketType ticketType,
  }) async {
    try {
      final ticketRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tickets')
          .doc(ticketId);

      if (ticketType == TicketType.flight) {
        final servicesCollection = ticketRef.collection('servicesOffered');
        final servicesSnapshot = await servicesCollection.get();
        for (final doc in servicesSnapshot.docs) {
          await doc.reference.delete();
        }
      }

      await ticketRef.delete();
      print('Ticket deleted successfully');
    } catch (e) {
      print('Error deleting ticket: $e');
      throw Exception('Failed to delete ticket: $ticketId, Error: $e');
    }
  }
