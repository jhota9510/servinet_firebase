import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateReservationScreen extends StatefulWidget {
  final String serviceId;
  final String providerId;
  final String serviceTitle;

  const CreateReservationScreen({
    super.key,
    required this.serviceId,
    required this.providerId,
    required this.serviceTitle,
  });

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  DateTime? selectedDate;

  final descriptionController = TextEditingController();

Future<void> saveReservation() async {
  try {
    print("SERVICE ID: ${widget.serviceId}");
    print("PROVIDER ID: ${widget.providerId}");
    print("CLIENT ID: ${FirebaseAuth.instance.currentUser?.uid}");

    if (selectedDate == null) {
      print("NO HAY FECHA");
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('service')
        .add({
      'serviceId': widget.serviceId,
      'providerId': widget.providerId,
      'clientId': FirebaseAuth.instance.currentUser!.uid,
      'scheduledDate': Timestamp.fromDate(selectedDate!),
      'problemDescription': descriptionController.text.trim(),
      'status': 'pending',
      'createdAt': Timestamp.now(),
    });

    print("RESERVA CREADA: ${doc.id}");

    if (mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reserva creada correctamente"),
        ),
      );
    }
  } catch (e) {
    print("ERROR AL CREAR RESERVA:");
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.serviceTitle)),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  initialDate: DateTime.now(),
                );

                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },

              child: Text(
                selectedDate == null
                    ? "Seleccionar fecha"
                    : selectedDate.toString(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,

              maxLines: 5,

              decoration: const InputDecoration(
                labelText: "Describe el problema",
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: saveReservation,

              child: const Text("Solicitar servicio"),
            ),
          ],
        ),
      ),
    );
  }
}
