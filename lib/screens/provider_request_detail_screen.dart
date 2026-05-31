import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProviderRequestDetailScreen extends StatelessWidget {
  final String requestId;

  const ProviderRequestDetailScreen({super.key, required this.requestId});

  Future<void> updateStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('service_requests')
        .doc(requestId)
        .update({'status': status, 'updatedAt': Timestamp.now()});
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4FC3F7);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Detalle Solicitud",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('service_requests')
            .doc(requestId)
            .get(),

        builder: (context, requestSnapshot) {
          if (!requestSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final request = requestSnapshot.data!.data() as Map<String, dynamic>;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(request['clientId'])
                .get(),

            builder: (context, clientSnapshot) {
              if (!clientSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final client =
                  clientSnapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: primaryColor,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      client['fullName'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text("Teléfono: ${client['phone']}"),

                    const SizedBox(height: 10),

                    Text("Dirección: ${client['direccion']}"),

                    const Divider(height: 40),

                    const Text(
                      "Descripción",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Text(request['problemDescription']),

                    const SizedBox(height: 20),

                    Text(
                      "Estado: ${request['status']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 30),

                    if (request['status'] == 'pending')
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await updateStatus('accepted');

                                Navigator.pop(context);
                              },
                              child: const Text("Aceptar"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await updateStatus('rejected');

                                Navigator.pop(context);
                              },
                              child: const Text("Rechazar"),
                            ),
                          ),
                        ],
                      ),

                    if (request['status'] == 'accepted')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await updateStatus('in_progress');

                            Navigator.pop(context);
                          },
                          child: const Text("Iniciar Servicio"),
                        ),
                      ),

                    if (request['status'] == 'in_progress')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await updateStatus('completed');

                            Navigator.pop(context);
                          },
                          child: const Text("Completar"),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
