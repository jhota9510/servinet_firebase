import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_user_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  final _formKey =
  GlobalKey<FormState>();

  bool obscure = true;

  final Color primaryColor =
  const Color(0xFF4FC3F7);

  InputDecoration customInput({
    required String label,
    required IconData icon,
  }) {

    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(
        icon,
        color: primaryColor,
      ),

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),

        borderSide: BorderSide(
          color:
          primaryColor.withOpacity(0.2),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),

        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthUser>(
      context,
    );

    return Scaffold(

      backgroundColor:
      const Color(0xFFF2FBFF),

      body: SafeArea(
        child: Center(

          child: SingleChildScrollView(
            padding:
            const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  const SizedBox(height: 20),

                  // LOGO

                  Container(
                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,

                      boxShadow: [

                        BoxShadow(
                          color: primaryColor
                              .withOpacity(0.4),

                          blurRadius: 15,

                          offset:
                          const Offset(
                            0,
                            8,
                          ),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons
                          .home_repair_service,

                      color: Colors.white,
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // TÍTULO

                  const Text(
                    "Bienvenido",

                    style: TextStyle(
                      fontSize: 32,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Inicia sesión en SERVINET",

                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // EMAIL

                  TextFormField(
                    controller:
                    _emailController,

                    keyboardType:
                    TextInputType
                        .emailAddress,

                    decoration:
                    customInput(
                      label: "Correo",
                      icon: Icons.email,
                    ),

                    validator: (value) {

                      if (value == null ||
                          value.isEmpty) {

                        return
                          "Ingrese el correo";
                      }

                      if (!value
                          .contains('@')) {

                        return
                          "Correo inválido";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD

                  TextFormField(
                    controller:
                    _passwordController,

                    obscureText:
                    obscure,

                    decoration:
                    customInput(
                      label:
                      "Contraseña",
                      icon: Icons.lock,
                    ).copyWith(

                      suffixIcon:
                      IconButton(

                        icon: Icon(
                          obscure

                              ? Icons
                              .visibility

                              : Icons
                              .visibility_off,

                          color:
                          primaryColor,
                        ),

                        onPressed: () {

                          setState(() {
                            obscure =
                            !obscure;
                          });
                        },
                      ),
                    ),

                    validator: (value) {

                      if (value == null ||
                          value.isEmpty) {

                        return
                          "Ingrese la contraseña";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // ERROR

                  if (auth.error != null)

                    Text(
                      auth.error!,

                      style:
                      const TextStyle(
                        color: Colors.red,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                  const SizedBox(height: 30),

                  // BOTÓN LOGIN

                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        primaryColor,

                        foregroundColor:
                        Colors.white,

                        elevation: 8,

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius
                              .circular(
                              18),
                        ),
                      ),

                      onPressed:
                      auth.loading

                          ? null

                          : () async {

                        if (!_formKey
                            .currentState!
                            .validate()) {

                          return;
                        }

                        final success =
                        await auth
                            .signIn(

                          email:
                          _emailController
                              .text,

                          password:
                          _passwordController
                              .text,
                        );

                        if (success &&
                            context
                                .mounted) {

                          ScaffoldMessenger.of(
                              context)
                              .showSnackBar(

                            const SnackBar(
                              backgroundColor:
                              Colors
                                  .green,

                              content: Text(
                                "Inicio de sesión exitoso",
                              ),
                            ),
                          );
                        }
                      },

                      child:
                      auth.loading

                          ? const CircularProgressIndicator(
                        color: Colors
                            .white,
                      )

                          : const Text(
                        "Ingresar",

                        style:
                        TextStyle(
                          fontSize:
                          20,

                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // REGISTER

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: [

                      const Text(
                        "¿No tienes cuenta?",

                        style: TextStyle(
                          color:
                          Colors.grey,
                          fontSize: 15,
                        ),
                      ),

                      TextButton(

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                              const RegisterScreen(),
                            ),
                          );
                        },

                        child: Text(
                          "Registrarse",

                          style: TextStyle(
                            color:
                            primaryColor,

                            fontWeight:
                            FontWeight
                                .bold,

                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}