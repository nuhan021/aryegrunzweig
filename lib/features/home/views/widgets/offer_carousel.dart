import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';

class OfferCarousel extends StatelessWidget {
  OfferCarousel({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<Map<String, String>> offerList = [
    {
      "off": "20% OFF",
      "title": "First Service",
      "image": "https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=1000"
    },
    {
      "off": "15% OFF",
      "title": "Office Cleaning",
      "image": "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000"
    },
    {
      "off": "25% OFF",
      "title": "Deep Cleaning",
      "image": "https://images.unsplash.com/photo-1628177142898-93e36e4e3a50?q=80&w=1000"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider(
              carouselController: controller.carouselController,
              options: CarouselOptions(
                height: 180.h,
                viewportFraction: 1.0,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  controller.updateIndex(index);
                },
              ),
              items: offerList.map((offer) {
                return Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: offer['image']!,
                          width: double.maxFinite,
                          height: 180.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C4F50).withOpacity(0.85),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    offer['off']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    offer['title']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Positioned(
              left: 20.w,
              child: _arrowButton(Icons.arrow_back_ios_new, () => controller.carouselController.previousPage()),
            ),
            Positioned(
              right: 20.w,
              child: _arrowButton(Icons.arrow_forward_ios, () => controller.carouselController.nextPage()),
            ),
          ],
        ),
        12.verticalSpace,
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: offerList.asMap().entries.map((entry) {
            return Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.currentIndex.value == entry.key
                    ? const Color(0xFF1C4F50)
                    : Colors.grey.withOpacity(0.4),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Color(0xFF1C4F50),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 14.sp),
      ),
    );
  }
}