import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servinet/data_and_utils/category_register_data.dart';

class AuthUser extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  User? get user => _auth.currentUser;

  // ESCUCHAR SESIÓN
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // LOGIN
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _error = _handleAuthError(e);
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // REGISTRO
  
  Future<bool> signUp({
  required String fullName,
  required String email,
  required String password,
  required String phone,
  required String direccion,
  required String role,

  String? categoryId,
  String? experience,
  String? biography,
}) async {
  _setLoading(true);
  _error = null;

  try {
    // VALIDACIONES

    if (fullName.trim().isEmpty) {
      _error = "Ingrese el nombre";
      return false;
    }

    if (!email.contains('@')) {
      _error = "Correo inválido";
      return false;
    }

    if (password.length < 6) {
      _error = "La contraseña debe tener mínimo 6 caracteres";
      return false;
    }

    if (phone.trim().isEmpty) {
      _error = "Ingrese el teléfono";
      return false;
    }

    if (role.isEmpty) {
      _error = "Seleccione un rol";
      return false;
    }

    // VALIDACIONES PROVEEDOR

    if (role == 'provider') {
      if (categoryId == null || categoryId.isEmpty) {
        _error = "Seleccione una categoría";
        return false;
      }

      if (experience == null || experience.isEmpty) {
        _error = "Ingrese la experiencia";
        return false;
      }

      if (biography == null || biography.isEmpty) {
        _error = "Ingrese una biografía";
        return false;
      }
    }

    // CREAR USUARIO EN AUTH

    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final uid = credential.user!.uid;

    // GUARDAR USUARIO

    await _db.collection('users').doc(uid).set({
      'id': uid,

      'fullName': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'direccion': direccion.trim(),

      'role': role,

      'categoryId': categoryId,
      'experience': experience,
      'biography': biography ?? '',

      'profileImage': '',
      'verified': false,

      'createdAt': Timestamp.now(),
    });

    // CREAR SERVICIO AUTOMÁTICAMENTE

    if (role == 'provider') {
      final category = categoryRegisterData.firstWhere(
        (e) => e['id'] == categoryId,
      );

      await _db.collection('services').add({
        'providerId': uid,

        'categoryId': categoryId,

        'title': category['name'],
        'description': biography ?? '',

        'price': 0,

        'isActive': true,

        'rating': 0.0,
        'totalReviews': 0,
        'totalBookings': 0,

        'images': [],

        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    }

    return true;
  } on FirebaseAuthException catch (e) {
    _error = _handleAuthError(e);
    return false;
  } catch (e) {
    _error = e.toString();
    return false;
  } finally {
    _setLoading(false);
  }
}

  // CERRAR SESIÓN
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // ELIMINAR CUENTA
  Future<bool> deleteAccount() async {
    _setLoading(true);

    try {
      final uid = _auth.currentUser!.uid;

      // BORRAR FIRESTORE
      await _db.collection('users').doc(uid).delete();

      // BORRAR AUTH
      await _auth.currentUser!.delete();

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // RECUPERAR CONTRASEÑA
  Future<bool> resetPassword(String email) async {
    _setLoading(true);

    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _error = _handleAuthError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // MANEJO DE ERRORES
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {

      case 'user-not-found':
        return 'Usuario no encontrado';

      case 'wrong-password':
        return 'Contraseña incorrecta';

      case 'email-already-in-use':
        return 'El correo ya está registrado';

      case 'invalid-email':
        return 'Correo inválido';

      case 'weak-password':
        return 'Contraseña muy débil';

      case 'network-request-failed':
        return 'Sin conexión a internet';

      default:
        return e.message ?? 'Error desconocido';
    }
  }
}