import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/address_model.dart';

class SavedAddressesController extends GetxController {
  var addresses = <Address>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAddresses();
  }

  void _loadAddresses() {
    // Mock data - replace with API call
    addresses.addAll([
      Address(
        id: '1',
        label: 'Home',
        street: '123 Main St, Apt 4B',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        type: AddressType.home,
        iconBackgroundColor: const Color(0x191A73E8),
      ),
      Address(
        id: '2',
        label: 'Work',
        street: '456 Business Ave, Floor 12',
        city: 'New York',
        state: 'NY',
        zipCode: '10002',
        type: AddressType.work,
        iconBackgroundColor: const Color(0x1928C76F),
      ),
      Address(
        id: '3',
        label: "Mom's House",
        street: '789 Family Lane',
        city: 'Brooklyn',
        state: 'NY',
        zipCode: '11201',
        type: AddressType.other,
        iconBackgroundColor: const Color(0x19FF9F43),
      ),
    ]);
  }

  void addAddress(Address address) {
    addresses.add(address);
  }

  void removeAddress(String id) {
    addresses.removeWhere((address) => address.id == id);
  }

  void updateAddress(String id, Address updatedAddress) {
    final index = addresses.indexWhere((address) => address.id == id);
    if (index != -1) {
      addresses[index] = updatedAddress;
    }
  }

  void deleteAddress(String id) {
    removeAddress(id);
    // Show snackbar
    Get.snackbar('Success', 'Address deleted successfully');
  }

  void openAddressOptions(String id) {
    // Show bottom sheet or menu with edit/delete options
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Address'),
              onTap: () {
                Get.back();
                // Navigate to edit screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Address',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                deleteAddress(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
