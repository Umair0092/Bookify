
import 'package:bookify/Screens/localservice/servicebooking.dart';
import 'package:bookify/services/localservice.dart';
import 'package:flutter/material.dart';

class localcar extends StatelessWidget {
  final String id;
  final List<dynamic> services;
  final List<dynamic> time;
  final int cost;
  final int rating;

  const localcar({
    super.key,
    required this.id,
    required this.services,
    required this.time,
    required this.cost,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=>Servicebooking(
              companyName: id, // Using the id as company name
              availableTimes: time.map((t) => t.toString()).toList(),
              rate: cost,
            ),

        )
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2.0,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://plus.unsplash.com/premium_photo-1683120929511-af05758ec1e5?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("images/img1.jpg", fit: BoxFit.cover);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.5),
                      const Color.fromRGBO(255, 234, 0, 1),
                    ],
                    end: Alignment.topLeft,
                    begin: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      services.isNotEmpty ? services.last : 'Service',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cost: \$${cost.toString()}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          time.isNotEmpty ? time.first : "Time",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class localhoizontal extends StatelessWidget {
  final Localserv localser = Localserv();

  localhoizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<localServicemodel>>(
      future: localser.fetchlocal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading services'));
        }

        final servi = snapshot.data ?? [];

        if (servi.isEmpty) {
          return Center(child: Text('No service found'));
        }

        return Container(
          height: 130,
          child: ListView.builder(
            itemCount: servi.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final serv = servi[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: localcar(
                  id: serv.id,
                  services: serv.services,
                  time: serv.time,
                  cost: serv.cost,
                  rating: serv.rating,
                  
                ),
              );
            },
  ),
);

      },
    );
  }
}