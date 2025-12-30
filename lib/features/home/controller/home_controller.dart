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