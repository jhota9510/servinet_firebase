import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_request_model.dart';

class ServiceRequestService {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  CollectionReference get _requests =>
      _db.collection('service_requests');

  // ==========================
  // CREATE
  // ==========================

  Future<void> createRequest(
    ServiceRequestModel request,
  ) async {
    await _requests.doc(request.id).set(
          request.toMap(),
        );
  }

  // ==========================
  // READ
  // ==========================

  Future<ServiceRequestModel?> getRequestById(
    String requestId,
  ) async {
    final doc =
        await _requests.doc(requestId).get();

    if (!doc.exists) return null;

    return ServiceRequestModel.fromMap(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  Future<List<ServiceRequestModel>>
      getRequestsByClient(
    String clientId,
  ) async {
    final snapshot = await _requests
        .where(
          'clientId',
          isEqualTo: clientId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();

    return snapshot.docs.map((doc) {
      return ServiceRequestModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<List<ServiceRequestModel>>
      getRequestsByProvider(
    String providerId,
  ) async {
    final snapshot = await _requests
        .where(
          'providerId',
          isEqualTo: providerId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();

    return snapshot.docs.map((doc) {
      return ServiceRequestModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  // ==========================
  // REALTIME STREAMS
  // ==========================

  Stream<QuerySnapshot> getProviderRequests(
    String providerId,
  ) {
    return _requests
        .where(
          'providerId',
          isEqualTo: providerId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  Stream<QuerySnapshot> getClientRequests(
    String clientId,
  ) {
    return _requests
        .where(
          'clientId',
          isEqualTo: clientId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ==========================
  // UPDATE
  // ==========================

  Future<void> updateStatus(
    String requestId,
    String status,
  ) async {
    await _requests.doc(requestId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> rescheduleRequest(
    String requestId,
    DateTime newDate,
  ) async {
    await _requests.doc(requestId).update({
      'scheduledDate':
          Timestamp.fromDate(newDate),

      'status': 'rescheduled',

      'updatedAt': Timestamp.now(),
    });
  }

  // ==========================
  // BUSINESS ACTIONS
  // ==========================

  Future<void> acceptRequest(
    String requestId,
  ) async {
    await updateStatus(
      requestId,
      'accepted',
    );
  }

  Future<void> rejectRequest(
    String requestId,
  ) async {
    await updateStatus(
      requestId,
      'rejected',
    );
  }

  Future<void> startService(
    String requestId,
  ) async {
    await updateStatus(
      requestId,
      'in_progress',
    );
  }

  Future<void> completeService(
    String requestId,
  ) async {
    await updateStatus(
      requestId,
      'completed',
    );
  }

  Future<void> cancelRequest(
    String requestId,
  ) async {
    await updateStatus(
      requestId,
      'cancelled',
    );
  }

  // ==========================
  // DELETE
  // ==========================

  Future<void> deleteRequest(
    String requestId,
  ) async {
    await _requests
        .doc(requestId)
        .delete();
  }
}