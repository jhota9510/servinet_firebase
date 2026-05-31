import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servinet/data_and_utils/category_register_data.dart';

Future<void> createServiceCollection() async {
  final firestore = FirebaseFirestore.instance;

  for (final category in categoryRegisterData) {
    await firestore
        .collection('service')
        .doc(category['id'])
        .set({
      'id': category['id'],
      'name': category['name'],
      'createdAt': Timestamp.now(),
    });
  }
}