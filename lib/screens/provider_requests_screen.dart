import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'provider_request_detail_screen.dart';

class ProviderRequestsScreen extends StatelessWidget {
  const ProviderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4FC3F7);

    final providerId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Solicitudes", style: TextStyle(color: Colors.white)),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_requests')
            .where('providerId', isEqualTo: providerId)
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(child: Text("No tienes solicitudes"));
          }

          return ListView.builder(
            itemCount: requests.length,

            itemBuilder: (context, index) {
              final request = requests[index];

              return Card(
                margin: const EdgeInsets.all(12),

                child: ListTile(
                  title: Text(request['status']),

                  subtitle: Text(request['problemDescription']),

                  trailing: const Icon(Icons.arrow_forward_ios),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProviderRequestDetailScreen(requestId: request.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
