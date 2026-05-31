import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'create_reservation_screen.dart';

class ProviderProfileScreen extends StatelessWidget {
  final String providerId;

  const ProviderProfileScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4FC3F7);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBFF),

      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Perfil del proveedor",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(providerId)
            .get(),

        builder: (context, providerSnapshot) {
          if (!providerSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final provider =
              providerSnapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),

                CircleAvatar(
                  radius: 55,
                  backgroundColor: primaryColor,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  provider['fullName'] ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(provider['experience'] ?? ''),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    provider['biography'] ?? '',
                    textAlign: TextAlign.center,
                  ),
                ),

                const Divider(),

                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Servicios",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('services')
                      .where('providerId', isEqualTo: providerId)
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final services = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: services.length,

                      itemBuilder: (context, index) {
                        final service = services[index];

                        return Card(
                          margin: const EdgeInsets.all(12),

                          child: ListTile(
                            title: Text(service['title']),

                            subtitle: Text(service['description']),

                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateReservationScreen(
                                      serviceId: service.id,
                                      providerId: providerId,
                                      serviceTitle: service['title'],
                                    ),
                                  ),
                                );
                              },

                              child: const Text("Reservar"),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
