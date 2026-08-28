import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final CarouselSliderController carouselController = CarouselSliderController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  var currentIndex = 0.obs;
  var selectedServiceIndex = 0.obs;
  var selectedProblem = "Low suction".obs;
  var selectedAddress = "Home".obs;
  var isAddressFormVisible = false.obs;

  var selectedImages = <File>[].obs;
  var selectedVideos = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  // --- Service request flow (Select Issue -> Details -> Media -> Review) ---
  static const Map<String, List<String>> serviceIssueOptions = {
    'Maintenance': [
      'Unit will not turn on',
      'Unit will not shut off',
      'Clogged system',
      'Low suction',
      'Retractable hose will not pull out or retract',
      'Broken inlet valve / vacuum port',
      'General service or parts request',
    ],
    'Installation': [
      'New System',
      'Custom Fit',
      'System Upgrade',
      'Architectural',
    ],
  };

  var srIssueCategory = 'Maintenance'.obs;
  var srSelectedIssue = 'Unit will not turn on'.obs;

  final TextEditingController srAddressController = TextEditingController(
    text: '1842 Maplewood Drive, Westmount',
  );
  final TextEditingController srDescriptionController =
      TextEditingController();
  var srPreferredDate = Rxn<DateTime>();
  var srPreferredTime = ''.obs;

  var srImages = <File>[].obs;
  var srVideos = <File>[].obs;

  void srSelectCategory(String category) {
    srIssueCategory.value = category;
    srSelectedIssue.value = serviceIssueOptions[category]!.first;
  }

  void srSelectIssue(String issue) {
    srSelectedIssue.value = issue;
  }

  void srSetPreferredDate(DateTime date) {
    srPreferredDate.value = date;
  }

  void srSetPreferredTime(String time) {
    srPreferredTime.value = time;
  }

  Future<void> srPickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      srImages.add(File(image.path));
    }
  }

  Future<void> srPickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      srVideos.add(File(video.path));
    }
  }

  void srRemoveImage(int index) => srImages.removeAt(index);
  void srRemoveVideo(int index) => srVideos.removeAt(index);

  var focusedDay = DateTime.now().obs;
  var selectedDate = DateTime.now().obs;
  var selectedTimeSlot = "8:30 AM - 10:00 AM".obs;

  void updateIndex(int index) {
    currentIndex.value = index;
  }
  void selectService(int index) {
    selectedServiceIndex.value = index;
  }

  void updateProblem(String problem) {
    selectedProblem.value = problem;
  }

  void updateAddress(String address) {
    selectedAddress.value = address;
  }

  void toggleAddressForm() {
    isAddressFormVisible.value = !isAddressFormVisible.value;
  }

  void updateSelectedDate(DateTime date, DateTime focused) {
    selectedDate.value = date;
    focusedDay.value = focused;
  }

  void updateTimeSlot(String slot) {
    selectedTimeSlot.value = slot;
  }

  String get availabilityNote {
    int weekday = selectedDate.value.weekday;

    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      return "Selected day is a Weekend. We are Closed.";
    } else if (weekday == DateTime.friday) {
      return "Friday Hours: 8:30 AM - 4:00 PM";
    } else {
      return "Standard Hours: 8:30 AM - 5:30 PM (Mon-Thu)";
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImages.add(File(image.path));
    }
  }

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      selectedVideos.add(File(video.path));
    }
  }

  void removeImage(int index) => selectedImages.removeAt(index);
  void removeVideo(int index) => selectedVideos.removeAt(index);


}