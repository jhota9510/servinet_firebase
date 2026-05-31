import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servinet/models/service_model..dart';


class ServiceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _services =>
      _db.collection('services');

  // ======================
  // CREATE
  // ======================

  Future<void> createService(ServiceModel service) async {
    await _services.doc(service.id).set(service.toMap());
  }

  // ======================
  // READ
  // ======================

  Future<List<ServiceModel>> getAllServices() async {
    final snapshot = await _services.get();

    return snapshot.docs.map((doc) {
      return ServiceModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  // Obtener un servicio por ID
  Future<ServiceModel?> getServiceById(String id) async {
    final doc = await _services.doc(id).get();

    if (!doc.exists) return null;

    return ServiceModel.fromMap(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  // ======================
  // FILTROS
  // ======================

  Future<List<ServiceModel>> getServicesByCategory(
    String categoryId,
  ) async {
    final snapshot = await _services
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return snapshot.docs.map((doc) {
      return ServiceModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<List<ServiceModel>> getServicesByProvider(
    String providerId,
  ) async {
    final snapshot = await _services
        .where('providerId', isEqualTo: providerId)
        .get();

    return snapshot.docs.map((doc) {
      return ServiceModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<List<ServiceModel>> getServicesByPriceRange(
    double min,
    double max,
  ) async {
    final snapshot = await _services
        .where('price', isGreaterThanOrEqualTo: min)
        .where('price', isLessThanOrEqualTo: max)
        .get();

    return snapshot.docs.map((doc) {
      return ServiceModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  // ======================
  // BUSCADOR
  // ======================

  Future<List<ServiceModel>> searchServices(
    String query,
  ) async {
    final snapshot = await _services.get();

    return snapshot.docs
        .map((doc) => ServiceModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ))
        .where((service) =>
            service.title
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  // ======================
  // UPDATE
  // ======================

  Future<void> updateService(
    ServiceModel service,
  ) async {
    await _services.doc(service.id).update(
          service.toMap(),
        );
  }

  // ======================
  // DELETE
  // ======================

  Future<void> deleteService(
    String id,
  ) async {
    await _services.doc(id).delete();
  }
}