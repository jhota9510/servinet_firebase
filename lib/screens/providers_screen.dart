import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'provider_profile_screen.dart';

class ProvidersScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ProvidersScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF4FC3F7);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBFF),

      appBar: AppBar(
        backgroundColor: primaryColor,

        title: Text(categoryName, style: const TextStyle(color: Colors.white)),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'provider')
            .where('categoryId', isEqualTo: categoryId)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay proveedores"));
          }

          final providers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: providers.length,

            itemBuilder: (context, index) {
              final provider = providers[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 15),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),

                      blurRadius: 10,

                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),

                  leading: CircleAvatar(
                    radius: 30,

                    backgroundColor: primaryColor,

                    child: const Icon(Icons.person, color: Colors.white),
                  ),

                  title: Text(
                    provider['fullName'],

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height: 8),

                      Text(provider['experience'] ?? ''),

                      const SizedBox(height: 5),

                      Text(provider['biography'] ?? ''),
                    ],
                  ),

                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProviderProfileScreen(providerId: provider.id),
                        ),
                      );
                    },

                    child: const Text("Ver Perfil"),
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
