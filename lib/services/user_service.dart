import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servinet/models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crear usuario
  Future<void> createUser(UserModel user) async {
    try {
      await _db
          .collection('users')
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener usuario
  Future<UserModel> getUser(String id) async {
    try {
      final doc = await _db
          .collection('users')
          .doc(id)
          .get();

      if (!doc.exists) {
        throw Exception('Usuario no encontrado');
      }

      return UserModel.fromMap(
        doc.data()!,
        doc.id,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Stream del usuario
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser(
    String id,
  ) {
    return _db
        .collection('users')
        .doc(id)
        .snapshots();
  }

  /// Actualizar usuario
  Future<void> updateUser(UserModel user) async {
    try {
      await _db
          .collection('users')
          .doc(user.id)
          .update({
        ...user.toMap(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar usuario
  Future<void> deleteUser(String id) async {
    try {
      await _db
          .collection('users')
          .doc(id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Agregar proveedor a favoritos
  Future<void> addFavorite({
    required String userId,
    required String providerId,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'favorites': FieldValue.arrayUnion([
          providerId,
        ]),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar proveedor de favoritos
  Future<void> removeFavorite({
    required String userId,
    required String providerId,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'favorites': FieldValue.arrayRemove([
          providerId,
        ]),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener favoritos
  Future<List<DocumentSnapshot<Map<String, dynamic>>>>
      getFavorites(
    List<String> ids,
  ) async {
    try {
      final futures = ids.map(
        (id) => _db
            .collection('users')
            .doc(id)
            .get(),
      );

      return await Future.wait(futures);
    } catch (e) {
      rethrow;
    }
  }

  /// Reportar usuario
  Future<void> reportUser({
    required String reportedBy,
    required String reportedUser,
    required String reason,
  }) async {
    try {
      await _db.collection('reports').add({
        'reportedBy': reportedBy,
        'reportedUser': reportedUser,
        'reason': reason,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Suspender usuario
  Future<void> suspendUser(String userId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'isSuspended': true,
        'suspendedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Reactivar usuario
  Future<void> reactivateUser(String userId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'isSuspended': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Verificar proveedor
  Future<void> verifyProvider(String userId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'isVerified': true,
        'verifiedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar foto de perfil
  Future<void> updateProfileImage({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'profileImage': imageUrl,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar biografía
  Future<void> updateBio({
    required String userId,
    required String bio,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'bio': bio,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Agregar imágenes al portafolio
  Future<void> addPortfolioImages({
    required String userId,
    required List<String> images,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'portfolio': FieldValue.arrayUnion(
          images,
        ),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar imagen del portafolio
  Future<void> removePortfolioImage({
    required String userId,
    required String image,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({
        'portfolio': FieldValue.arrayRemove(
          [image],
        ),
      });
    } catch (e) {
      rethrow;
    }
  }
}