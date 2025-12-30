import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final CarouselSliderController carouselController = CarouselSliderController();
  var currentIndex = 0.obs;
  var selectedServiceIndex = 0.obs;
  var selectedProblem = "Low suction".obs;


  void updateIndex(int index) {
    currentIndex.value = index;
  }
  void selectService(int index) {
    selectedServiceIndex.value = index;
  }

  void updateProblem(String problem) {
    selectedProblem.value = problem;
  }
}