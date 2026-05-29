import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:servinet/providers/auth_user_provider.dart';
import 'package:servinet/screens/home_proveedor_screen.dart';
import 'package:servinet/screens/home_user_screen.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthUser(),
      child: MaterialApp(
        title: 'TODO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance
              .authStateChanges(),

      builder: (context, snapshot) {

        // LOADING

        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        // SI NO HAY SESIÓN

        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // UID DEL USUARIO

        final uid = snapshot.data!.uid;

        // CONSULTAR FIRESTORE

        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get(),

          builder: (context, userSnapshot) {

            // LOADING

            if (userSnapshot.connectionState ==
                ConnectionState.waiting) {

              return const Scaffold(
                body: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              );
            }

            // SI NO EXISTE EL DOCUMENTO

            if (!userSnapshot.hasData ||
                !userSnapshot.data!.exists) {

              return const Scaffold(
                body: Center(
                  child: Text(
                    "Usuario no encontrado",
                  ),
                ),
              );
            }

            // DATOS DEL USUARIO

            final data =
                userSnapshot.data!.data()
                    as Map<String, dynamic>;

            // ROLE

            final role = data['role'];

            // DEBUG

            print(data);
            print(role);

            // CLIENTE

            if (role == 'client') {

              return const UserHomeScreen();
            }

            // PROVEEDOR

            if (role == 'provider') {

              return const ContractorHomeScreen();
            }

            // DEFAULT

            return const LoginScreen();
          },
        );
      },
    );
  }
}