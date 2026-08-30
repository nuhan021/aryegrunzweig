import 'package:get/get.dart';

import '../../../core/utils/helpers/app_helper.dart';
import '../../services/data/service_request_models.dart';
import '../data/technician_models.dart';
import '../data/technician_repository.dart';
import 'technician_jobs_controller.dart';

class TechnicianEquipmentController extends GetxController {
  static const inletTypes = ['HDH', 'Chameleon', 'Chml-Elite', 'Standard'];

  final TechnicianRepository _repository = Get.find<TechnicianRepository>();
  final TechnicianJobsController _jobs = Get.find<TechnicianJobsController>();
  final equipment = Rxn<ServiceEquipment>();
  final isLoading = false.obs;
  final isSaving = false.obs;
  final unitNumber = ''.obs;
  final manufacturer = ''.obs;
  final model = ''.obs;
  final serialNumber = ''.obs;
  final location = ''.obs;
  final previousCondition = ''.obs;
  final additionalFeatures = <String>[].obs;
  final inletQuantities = <String, Map<String, int>>{}.obs;

  String? get _requestId => _jobs.selectedJob.value?.api.id;

  Future<void> loadEquipment() async {
    final requestId = _requestId;
    if (requestId == null || isLoading.value) return;
    isLoading.value = true;
    final result = await _repository.equipment(requestId);
    isLoading.value = false;
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return;
    }
    if (result.data!.isEmpty) {
      _clear();
      return;
    }
    _apply(result.data!.first);
  }

  Future<bool> updateEquipment({
    required String unit,
    required String brand,
    required String modelName,
    required String serial,
    required String unitLocation,
    required String condition,
  }) async {
    unitNumber.value = unit.trim();
    manufacturer.value = brand.trim();
    model.value = modelName.trim();
    serialNumber.value = serial.trim();
    location.value = unitLocation.trim();
    previousCondition.value = condition.trim();
    return _save();
  }

  Future<bool> replaceInletQuantities(
    Map<String, Map<String, int>> quantities,
  ) async {
    inletQuantities.assignAll(
      quantities.map(
        (floor, values) => MapEntry(floor, Map<String, int>.from(values)),
      ),
    );
    return _save();
  }

  void addFloor(String floor) {
    final name = floor.trim();
    if (name.isEmpty || inletQuantities.containsKey(name)) return;
    inletQuantities[name] = {for (final type in inletTypes) type: 0};
  }

  Future<bool> _save() async {
    final requestId = _requestId;
    if (requestId == null || unitNumber.value.isEmpty || isSaving.value) {
      return false;
    }
    isSaving.value = true;
    final payload = TechnicianEquipmentPayload(
      unitNumber: unitNumber.value,
      manufacturer: manufacturer.value,
      model: model.value,
      serialNumber: serialNumber.value,
      location: location.value,
      condition: previousCondition.value,
      additionalFeatures: additionalFeatures.toList(growable: false),
      inlets: [
        for (final floor in inletQuantities.entries)
          for (final inlet in floor.value.entries)
            TechnicianInletPayload(
              floor: floor.key,
              type: inlet.key,
              quantity: inlet.value,
            ),
      ],
    );
    final current = equipment.value;
    final result = current == null
        ? await _repository.createEquipment(requestId, payload)
        : await _repository.updateEquipment(
            id: requestId,
            equipmentId: current.id,
            payload: payload,
          );
    isSaving.value = false;
    if (!result.isSuccess || result.data == null) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    _apply(result.data!);
    return true;
  }

  void _apply(ServiceEquipment value) {
    equipment.value = value;
    unitNumber.value = value.unitNumber;
    manufacturer.value = value.manufacturer ?? '';
    model.value = value.model ?? '';
    serialNumber.value = value.serialNumber ?? '';
    location.value = value.location ?? '';
    previousCondition.value = value.condition ?? '';
    additionalFeatures.assignAll(value.additionalFeatures);
    final quantities = <String, Map<String, int>>{};
    for (final inlet in value.inlets) {
      quantities.putIfAbsent(
        inlet.floor,
        () => {for (final type in inletTypes) type: 0},
      )[inlet.type] = inlet.quantity
          .toInt();
    }
    inletQuantities.assignAll(quantities);
  }

  void _clear() {
    equipment.value = null;
    unitNumber.value = '';
    manufacturer.value = '';
    model.value = '';
    serialNumber.value = '';
    location.value = '';
    previousCondition.value = '';
    additionalFeatures.clear();
    inletQuantities.clear();
  }
}
