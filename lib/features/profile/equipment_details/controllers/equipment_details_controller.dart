import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EquipmentDetailsController extends GetxController {
  // Form field observables
  var manufacturerName = ''.obs;
  var modelNumber = ''.obs;
  var serialNumber = ''.obs;
  var systemType = 'Regular'.obs;
  var basementInlets = 0.obs;
  var firstFloorInlets = 0.obs;
  var secondFloorInlets = 0.obs;
  var thirdFloorInlets = 0.obs;
  var additionalFloorInlets = <int>[].obs;
  var photos = <File>[].obs;
  var videos = <File>[].obs;
  var additionalNotes = ''.obs;
  var isLoading = false.obs;

  // Text controllers
  late TextEditingController manufacturerController;
  late TextEditingController modelController;
  late TextEditingController serialController;
  late TextEditingController basementController;
  late TextEditingController firstFloorController;
  late TextEditingController secondFloorController;
  late TextEditingController thirdFloorController;
  late TextEditingController notesController;

  final List<String> systemTypes = ['Regular', 'Premium', 'Standard'];

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    manufacturerController = TextEditingController(
      text: manufacturerName.value,
    );
    modelController = TextEditingController(text: modelNumber.value);
    serialController = TextEditingController(text: serialNumber.value);
    basementController = TextEditingController(
      text: basementInlets.value.toString(),
    );
    firstFloorController = TextEditingController(
      text: firstFloorInlets.value.toString(),
    );
    secondFloorController = TextEditingController(
      text: secondFloorInlets.value.toString(),
    );
    thirdFloorController = TextEditingController(
      text: thirdFloorInlets.value.toString(),
    );
    notesController = TextEditingController(text: additionalNotes.value);
  }

  void updateManufacturer(String value) => manufacturerName.value = value;
  void updateModel(String value) => modelNumber.value = value;
  void updateSerial(String value) => serialNumber.value = value;
  void updateBasementInlets(String value) {
    basementInlets.value = int.tryParse(value) ?? 0;
  }

  void updateFirstFloorInlets(String value) {
    firstFloorInlets.value = int.tryParse(value) ?? 0;
  }

  void updateSecondFloorInlets(String value) {
    secondFloorInlets.value = int.tryParse(value) ?? 0;
  }

  void updateThirdFloorInlets(String value) {
    thirdFloorInlets.value = int.tryParse(value) ?? 0;
  }

  void updateNotes(String value) => additionalNotes.value = value;
  void updateSystemType(String value) => systemType.value = value;

  Future<void> addPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        photos.add(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> addVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        videos.add(File(video.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick video');
    }
  }

  void removePhoto(int index) => photos.removeAt(index);
  void removeVideo(int index) => videos.removeAt(index);

  void addMoreFloor() {
    additionalFloorInlets.add(0);
  }

  void removeFloor(int index) {
    if (additionalFloorInlets.isNotEmpty) {
      additionalFloorInlets.removeAt(index);
    }
  }

  void updateAdditionalFloorInlets(int index, String value) {
    if (index < additionalFloorInlets.length) {
      additionalFloorInlets[index] = int.tryParse(value) ?? 0;
    }
  }

  Future<void> saveEquipmentDetails() async {
    try {
      isLoading.value = true;

      // Validate required fields
      if (manufacturerName.isEmpty ||
          modelNumber.isEmpty ||
          serialNumber.isEmpty) {
        Get.snackbar('Error', 'Please fill all required fields');
        return;
      }

      // API call would go here
      // var response = await equipmentService.saveEquipmentDetails(
      //   equipmentData
      // );

      Get.snackbar('Success', 'Equipment details saved successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save equipment details');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    manufacturerController.dispose();
    modelController.dispose();
    serialController.dispose();
    basementController.dispose();
    firstFloorController.dispose();
    secondFloorController.dispose();
    thirdFloorController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
