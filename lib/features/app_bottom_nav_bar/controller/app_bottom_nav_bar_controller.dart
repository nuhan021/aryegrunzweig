import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AppBottomNavBarController extends GetxController {
  RxInt currentIndex = 0.obs;

  final PersistentTabController controller = PersistentTabController(
    initialIndex: 0,
  );

  // chane current index
  void changeCurrentIndex(int index) {
    currentIndex.value = index;
  }

  //change screen
  void jumpToScreen(int index) {
    currentIndex.value = index;
    controller.jumpToTab(index);
  }

  void resetToFirstTab() {
    currentIndex.value = 0;
    controller.jumpToTab(0);
  }
}
