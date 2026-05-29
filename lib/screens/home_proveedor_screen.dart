import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_user_provider.dart';

class ContractorHomeScreen extends StatefulWidget {
  const ContractorHomeScreen({super.key});

  @override
  State<ContractorHomeScreen> createState() => _ContractorHomeScreenState();
}

class _ContractorHomeScreenState extends State<ContractorHomeScreen> {
  int currentIndex = 0;

  final Color primaryColor = const Color(0xFF4FC3F7);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthUser>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBFF),

      appBar: AppBar(
        backgroundColor: primaryColor,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "Panel Proveedor",

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.notifications, color: Colors.white),
          ),

          IconButton(
            onPressed: () async {
              final confirm = await showDialog(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    title: const Text("Cerrar sesión"),

                    content: const Text("¿Deseas cerrar sesión?"),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },

                        child: const Text("Cancelar"),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),

                        onPressed: () {
                          Navigator.pop(context, true);
                        },

                        child: const Text("Salir"),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await auth.signOut();

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',

                    (route) => false,
                  );
                }
              }
            },

            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: primaryColor,

                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),

                  bottomRight: Radius.circular(35),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Bienvenido 👋",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    auth.user?.email ?? "",

                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Row(
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 35),

                        SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "Proveedor destacado",

                                style: TextStyle(
                                  color: Colors.white,

                                  fontSize: 18,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                "Sigue creciendo en SERVINET",

                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // RESUMEN
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Resumen",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),

              child: GridView.count(
                crossAxisCount: 2,

                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                crossAxisSpacing: 15,

                mainAxisSpacing: 15,

                childAspectRatio: 0.95,

                children: [
                  _buildCard(
                    title: "Servicios",
                    value: "12",
                    icon: Icons.home_repair_service,
                    color: Colors.orange,
                  ),

                  _buildCard(
                    title: "Ganancias",
                    value: "\$350",
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),

                  _buildCard(
                    title: "Pendientes",
                    value: "5",
                    icon: Icons.pending_actions,
                    color: Colors.red,
                  ),

                  _buildCard(
                    title: "Calificación",
                    value: "4.8",
                    icon: Icons.star,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ACCIONES
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Acciones rápidas",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),

              child: GridView.count(
                crossAxisCount: 2,

                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                crossAxisSpacing: 15,

                mainAxisSpacing: 15,

                childAspectRatio: 0.95,

                children: [
                  _quickButton(
                    title: "Publicar servicio",
                    icon: Icons.add_business,
                    color: primaryColor,
                    onTap: () {},
                  ),

                  _quickButton(
                    title: "Mis servicios",
                    icon: Icons.build,
                    color: Colors.orange,
                    onTap: () {},
                  ),

                  _quickButton(
                    title: "Solicitudes",
                    icon: Icons.assignment,
                    color: Colors.green,
                    onTap: () {},
                  ),

                  _quickButton(
                    title: "Agenda",
                    icon: Icons.calendar_month,
                    color: Colors.purple,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SOLICITUDES
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Solicitudes recientes",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(30),

                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(30),

                    child: Text("No hay solicitudes"),
                  );
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: requests.length,

                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  padding: const EdgeInsets.symmetric(horizontal: 15),

                  itemBuilder: (context, index) {
                    final request = requests[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(22),

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
                          radius: 28,

                          backgroundColor: primaryColor,

                          child: const Icon(Icons.person, color: Colors.white),
                        ),

                        title: Text(
                          request['serviceName'] ?? "Servicio",

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,

                            fontSize: 17,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),

                          child: Text(
                            request['description'] ?? "",

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,

                            foregroundColor: Colors.white,
                          ),

                          onPressed: () {},

                          child: const Text("Ver"),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        selectedItemColor: primaryColor,

        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),

          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),

          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Billetera"),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,

        onPressed: () {},

        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),

            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, color: color, size: 32),
          ),

          const SizedBox(height: 15),

          Text(
            value,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            title,

            textAlign: TextAlign.center,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _quickButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(25),

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(25),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),

              blurRadius: 10,

              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: color.withOpacity(0.15),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Icon(icon, color: color, size: 35),
            ),

            const SizedBox(height: 15),

            Text(
              title,

              textAlign: TextAlign.center,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
