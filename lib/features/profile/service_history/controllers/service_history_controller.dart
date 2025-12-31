import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/service_history_model.dart';

class ServiceHistoryController extends GetxController {
  var services = <ServiceHistory>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadServiceHistory();
  }

  void _loadServiceHistory() {
    // Mock data - replace with API call
    services.addAll([
      ServiceHistory(
        id: '1',
        title: 'AC Repair',
        category: 'HVAC',
        status: ServiceStatus.completed,
        price: 149.00,
        date: DateTime(2025, 11, 20),
        categoryIcon: Icons.ac_unit,
      ),
      ServiceHistory(
        id: '2',
        title: 'Plumbing Fix',
        category: 'Plumbing',
        status: ServiceStatus.completed,
        price: 89.00,
        date: DateTime(2025, 11, 15),
        categoryIcon: Icons.plumbing,
      ),
      ServiceHistory(
        id: '3',
        title: 'Electrical Inspection',
        category: 'Electrical',
        status: ServiceStatus.completed,
        price: 120.00,
        date: DateTime(2025, 11, 10),
        categoryIcon: Icons.electrical_services,
      ),
      ServiceHistory(
        id: '4',
        title: 'Deep Cleaning',
        category: 'Cleaning',
        status: ServiceStatus.cancelled,
        price: 79.00,
        date: DateTime(2025, 11, 5),
        categoryIcon: Icons.cleaning_services,
      ),
    ]);
  }
}
