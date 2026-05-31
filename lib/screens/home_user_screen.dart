import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servinet/data_and_utils/category_homeuser_data.dart';
import 'package:servinet/screens/my_reservations_screen.dart';
import 'package:servinet/screens/providers_screen.dart';
import '../providers/auth_user_provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String search = '';

  final Color primaryColor = const Color(0xFF4FC3F7);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthUser>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBFF),

      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,

        title: const Text(
          "SERVINET",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyReservationsScreen()),
              );
            },
            icon: const Icon(Icons.calendar_month, color: Colors.white),
          ),
          // NOTIFICACIONES
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),

          // CERRAR SESIÓN
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

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: primaryColor,

                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Encuentra servicios",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Profesionales cerca de ti",

                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 25),

                  // BUSCADOR
                  TextField(
                    controller: _searchController,

                    decoration: InputDecoration(
                      hintText: "Buscar servicios...",

                      prefixIcon: Icon(Icons.search, color: primaryColor),

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    onChanged: (value) {
                      setState(() {
                        search = value.toLowerCase();
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // TÍTULO CATEGORÍAS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Categorías",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // CATEGORÍAS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),

              child: Column(
                children: categorieshomeuser.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => ProvidersScreen(
                              categoryId: category['id'],
                              categoryName: category['name'],
                            ),
                          ),
                        );
                      },

                      child: Container(
                        padding: const EdgeInsets.all(18),

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

                        child: Row(
                          children: [
                            Container(
                              width: 65,
                              height: 65,

                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.15),

                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: Icon(
                                category['icon'],
                                color: primaryColor,
                                size: 32,
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    category['name'],

                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  const Text(
                                    "Ver proveedores disponibles",

                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // TÍTULO SERVICIOS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Servicios disponibles",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // SERVICIOS
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('services')
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
                    child: Text("No hay servicios"),
                  );
                }

                final services = snapshot.data!.docs.where((doc) {
                  final title = doc['title'].toString().toLowerCase();

                  return title.contains(search);
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  padding: const EdgeInsets.all(15),

                  itemCount: services.length,

                  itemBuilder: (context, index) {
                    final service = services[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(25),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => ProvidersScreen(
                              categoryId: service['categoryId'],
                              categoryName: service['title'],
                            ),
                          ),
                        );
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(25),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),

                              blurRadius: 12,

                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Container(
                              height: 140,
                              width: double.infinity,

                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.15),

                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),

                              child: Center(
                                child: Icon(
                                  Icons.home_repair_service,

                                  size: 70,

                                  color: primaryColor,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(18),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    service['title'],

                                    style: const TextStyle(
                                      fontSize: 22,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    service['description'],

                                    style: TextStyle(
                                      color: Colors.grey.shade700,

                                      fontSize: 15,
                                    ),

                                    maxLines: 2,

                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 18),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 8,
                                        ),

                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),

                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),

                                        child: Text(
                                          "\$ ${service['price']}",

                                          style: const TextStyle(
                                            color: Colors.green,

                                            fontSize: 18,

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,

                                          foregroundColor: Colors.white,

                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 12,
                                          ),

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),

                                        onPressed: () {
                                          Navigator.push(
                                            context,

                                            MaterialPageRoute(
                                              builder: (_) => ProvidersScreen(
                                                categoryId:
                                                    service['categoryId'],

                                                categoryName: service['title'],
                                              ),
                                            ),
                                          );
                                        },

                                        icon: const Icon(Icons.visibility),

                                        label: const Text("Ver proveedores"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
