import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/category_register_data.dart';
import '../providers/auth_user_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _direccionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _biographyController = TextEditingController();

  bool obscure = true;

  String role = 'client';

  String? selectedCategory;

  final Color primaryColor = const Color(0xFF4FC3F7);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _direccionController.dispose();
    _experienceController.dispose();
    _biographyController.dispose();

    super.dispose();
  }

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
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: primaryColor.withOpacity(0.2),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthUser>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBFF),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                const SizedBox(height: 20),

                // LOGO
                Container(
                  width: 110,
                  height: 110,

                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.home_repair_service,
                    color: Colors.white,
                    size: 55,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Crear cuenta",

                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Regístrate en SERVINET",

                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35),

                // NOMBRE
                TextFormField(
                  controller: _nameController,

                  decoration: customInput(
                    label: "Nombre completo",
                    icon: Icons.person,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese el nombre";
                    }

                    if (value.trim().length < 3) {
                      return "El nombre es muy corto";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // EMAIL
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: customInput(
                    label: "Correo",
                    icon: Icons.email,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese el correo";
                    }

                    final emailRegex =
                        RegExp(r'^[^@]+@[^@]+\.[^@]+');

                    if (!emailRegex.hasMatch(value.trim())) {
                      return "Correo inválido";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // TELÉFONO
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,

                  decoration: customInput(
                    label: "Teléfono",
                    icon: Icons.phone,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese el teléfono";
                    }

                    if (value.trim().length < 7) {
                      return "Número inválido";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // DIRECCIÓN
                TextFormField(
                  controller: _direccionController,

                  decoration: customInput(
                    label: "Dirección",
                    icon: Icons.location_on,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese la dirección";
                    }

                    if (value.trim().length < 5) {
                      return "Dirección muy corta";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: obscure,

                  decoration: customInput(
                    label: "Contraseña",
                    icon: Icons.lock,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: primaryColor,
                      ),

                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ingrese la contraseña";
                    }

                    if (value.length < 6) {
                      return "Mínimo 6 caracteres";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ROL
                DropdownButtonFormField<String>(
                  value: role,

                  decoration: customInput(
                    label: "Rol",
                    icon: Icons.badge,
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 'client',
                      child: Text("Cliente"),
                    ),

                    DropdownMenuItem(
                      value: 'provider',
                      child: Text("Proveedor"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      role = value!;
                      selectedCategory = null;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // CATEGORÍA
                if (role == 'provider')
                  DropdownButtonFormField<String>(
                    value: selectedCategory,

                    decoration: customInput(
                      label: "Categoría",
                      icon: Icons.category,
                    ),

                    items: categoryRegisterData.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'],

                        child: Text(
                          category['name'] ?? '',
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },

                    validator: (value) {
                      if (role == 'provider' &&
                          value == null) {
                        return "Seleccione una categoría";
                      }

                      return null;
                    },
                  ),

                if (role == 'provider')
                  const SizedBox(height: 20),

                // EXPERIENCIA
                if (role == 'provider')
                  TextFormField(
                    controller: _experienceController,

                    decoration: customInput(
                      label: "Experiencia",
                      icon: Icons.work,
                    ),

                    validator: (value) {
                      if (role == 'provider' &&
                          (value == null ||
                              value.trim().isEmpty)) {
                        return "Ingrese experiencia";
                      }

                      if (role == 'provider' &&
                          value!.trim().length < 3) {
                        return "Experiencia muy corta";
                      }

                      return null;
                    },
                  ),

                if (role == 'provider')
                  const SizedBox(height: 20),

                // BIOGRAFÍA
                if (role == 'provider')
                  TextFormField(
                    controller: _biographyController,
                    maxLines: 4,

                    decoration: customInput(
                      label: "Biografía",
                      icon: Icons.description,
                    ),

                    validator: (value) {
                      if (role == 'provider' &&
                          (value == null ||
                              value.trim().isEmpty)) {
                        return "Ingrese una biografía";
                      }

                      if (role == 'provider' &&
                          value!.trim().length < 10) {
                        return "La biografía es muy corta";
                      }

                      return null;
                    },
                  ),

                const SizedBox(height: 20),

                // ERROR
                if (auth.error != null)
                  Text(
                    auth.error!,

                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 25),

                // BOTÓN REGISTRARSE
                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      elevation: 8,
                    ),

                    onPressed: auth.loading
                        ? null
                        : () async {
                            if (!_formKey.currentState!
                                .validate()) {
                              return;
                            }

                            final success =
                                await auth.signUp(
                              fullName:
                                  _nameController.text.trim(),

                              email:
                                  _emailController.text.trim(),

                              password:
                                  _passwordController.text.trim(),

                              phone:
                                  _phoneController.text.trim(),

                              direccion:
                                  _direccionController.text
                                      .trim(),

                              role: role,

                              categoryId:
                                  selectedCategory,

                              experience:
                                  _experienceController.text
                                      .trim(),

                              biography:
                                  _biographyController.text
                                      .trim(),
                            );

                            if (success &&
                                context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  backgroundColor:
                                      Colors.green,

                                  content: Text(
                                    "Registro exitoso",
                                  ),
                                ),
                              );

                              Navigator.pop(context);
                            }
                          },

                    child: auth.loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Registrarse",

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 15),

                // BOTÓN CANCELAR
                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pushReplacement(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen(),
                        ),
                      );
                    },

                    child: Text(
                      "Cancelar",

                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}