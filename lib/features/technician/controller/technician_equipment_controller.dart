import 'package:get/get.dart';

class TechnicianEquipmentController extends GetxController {
  static const inletTypes = ['HDH', 'Chameleon', 'Chml-Elite', 'Standard'];

  final unitNumber = 'Unit #1'.obs;
  final manufacturer = 'Beam'.obs;
  final model = 'SC375'.obs;
  final serialNumber = 'BMC-482091'.obs;
  final location = 'Basement utility room'.obs;
  final previousCondition = 'Working with reduced suction'.obs;

  final inletQuantities = <String, Map<String, int>>{
    'Basement': {'HDH': 1, 'Chameleon': 0, 'Chml-Elite': 0, 'Standard': 2},
    'First Floor': {'HDH': 0, 'Chameleon': 3, 'Chml-Elite': 0, 'Standard': 4},
    'Second Floor': {'HDH': 3, 'Chameleon': 0, 'Chml-Elite': 2, 'Standard': 3},
  }.obs;

  void updateEquipment({
    required String unit,
    required String brand,
    required String modelName,
    required String serial,
    required String unitLocation,
    required String condition,
  }) {
    unitNumber.value = unit.trim();
    manufacturer.value = brand.trim();
    model.value = modelName.trim();
    serialNumber.value = serial.trim();
    location.value = unitLocation.trim();
    previousCondition.value = condition.trim();
  }

  void replaceInletQuantities(Map<String, Map<String, int>> quantities) {
    inletQuantities.assignAll(
      quantities.map(
        (floor, values) => MapEntry(floor, Map<String, int>.from(values)),
      ),
    );
  }

  void addFloor(String floor) {
    final name = floor.trim();
    if (name.isEmpty || inletQuantities.containsKey(name)) return;
    inletQuantities[name] = {for (final type in inletTypes) type: 0};
  }
}
