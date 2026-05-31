import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;

      case 'accepted':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'in_progress':
        return Colors.blue;

      case 'completed':
        return Colors.purple;

      case 'cancelled':
        return Colors.grey;

      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Reservas")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_requests')
            .where('clientId', isEqualTo: clientId)
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(child: Text("No tienes reservas"));
          }

          return ListView.builder(
            itemCount: requests.length,

            itemBuilder: (context, index) {
              final request = requests[index];

              final status = request['status'];

              return Card(
                margin: const EdgeInsets.all(12),

                child: ListTile(
                  title: Text(request['problemDescription'], maxLines: 1),

                  subtitle: Text(request['scheduledDate'].toDate().toString()),

                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
