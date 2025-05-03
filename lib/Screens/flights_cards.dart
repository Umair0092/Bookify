import 'package:flutter/material.dart';

import '../services/flights.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  final VoidCallback onBookNow;


  const FlightCard({
    super.key,
    required this.flight,
    required this.onBookNow,

  });

  // Map iconName to Flutter Icons
  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'fastfood':
        return Icons.fastfood;
      case 'flight_takeoff':
        return Icons.flight_takeoff;
      case 'chair':
        return Icons.chair;
      case 'wifi':
        return Icons.wifi;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onBookNow,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
                Positioned.fill(
                  child: Image.network(flight.image),
                ),
              // Overlay for text readability
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.4),
                    ]
                        : [
                      Colors.white.withOpacity(0.7),
                      Colors.blue[50]!.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Airline and Flight Number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          flight.airline,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          flight.flightNumber,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Route: Departure and Destination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          flight.departureCity,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.arrow_forward, size: 20),
                        Text(
                          flight.destinationCity,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Times: Departure and Arrival
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dep: ${flight.departureTime.toString().substring(0, 16)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Arr: ${flight.arrivalTime.toString().substring(0, 16)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Price
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '\$${flight.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),

                    // Services
                    // Book Now Button

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}