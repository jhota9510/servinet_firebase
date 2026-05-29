
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtener categorías
  Future<List<QueryDocumentSnapshot>> getCategories() async {
    final result = await _db.collection('categories').get();
    return result.docs;
  }

  /// Obtener categoría por ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getCategoryById(
    String id,
  ) async {
    try {
      return await _db
          .collection('categories')
          .doc(id)
          .get();
    } catch (e) {
      rethrow;
    }
  }

  /// Crear categoría
  Future<void> createCategory({
    required String name,
    required String icon,
  }) async {
    try {
      final doc = _db.collection('categories').doc();

      await doc.set({
        'id': doc.id,
        'name': name,
        'icon': icon,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar categoría
  Future<void> updateCategory({
    required String id,
    required String name,
    required String icon,
  }) async {
    try {
      await _db.collection('categories').doc(id).update({
        'name': name,
        'icon': icon,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar categoría
  Future<void> deleteCategory(String id) async {
    try {
      await _db.collection('categories').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}


