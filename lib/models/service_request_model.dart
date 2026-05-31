import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequestModel {
  final String id;

  // RELACIONES
  final String serviceId;
  final String clientId;
  final String providerId;

  // DATOS DE LA RESERVA
  final DateTime scheduledDate;
  final String problemDescription;

  // ESTADO
  final String status;

  // FECHAS
  final DateTime createdAt;
  final DateTime? updatedAt;

  ServiceRequestModel({
    required this.id,
    required this.serviceId,
    required this.clientId,
    required this.providerId,
    required this.scheduledDate,
    required this.problemDescription,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory ServiceRequestModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ServiceRequestModel(
      id: id,
      serviceId: map['serviceId'] ?? '',
      clientId: map['clientId'] ?? '',
      providerId: map['providerId'] ?? '',

      scheduledDate:
          (map['scheduledDate'] as Timestamp).toDate(),

      problemDescription:
          map['problemDescription'] ?? '',

      status: map['status'] ?? 'pending',

      createdAt:
          (map['createdAt'] as Timestamp).toDate(),

      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'clientId': clientId,
      'providerId': providerId,

      'scheduledDate':
          Timestamp.fromDate(scheduledDate),

      'problemDescription':
          problemDescription,

      'status': status,

      'createdAt':
          Timestamp.fromDate(createdAt),

      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : null,
    };
  }
}