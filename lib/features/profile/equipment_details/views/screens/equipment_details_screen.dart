import 'package:flutter/material.dart';

class EquipmentDetailsScreen extends StatelessWidget {
  const EquipmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment Details')),
      body: const Center(child: Text('This is the Equipment Details Screen')),
    );
  }
}
