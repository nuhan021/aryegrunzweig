import 'package:aryegrunzweig/features/profile/payment_methods/models/payment_method_model.dart';
import 'package:get/get.dart';

class PaymentMethodsController extends GetxController {
  final paymentMethods = <PaymentMethod>[].obs;
  final selectedMethodId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePaymentMethods();
  }

  void _initializePaymentMethods() {
    paymentMethods.assignAll([
      PaymentMethod(
        id: '1',
        cardNumber: '4242',
        cardHolder: 'JOHN SMITH',
        expiryDate: '12/25',
        type: CardType.visa,
        isDefault: true,
      ),
      PaymentMethod(
        id: '2',
        cardNumber: '8888',
        cardHolder: 'JOHN SMITH',
        expiryDate: '08/26',
        type: CardType.mastercard,
        isDefault: false,
      ),
      PaymentMethod(
        id: '3',
        cardNumber: '1005',
        cardHolder: 'JOHN SMITH',
        expiryDate: '03/27',
        type: CardType.amex,
        isDefault: false,
      ),
    ]);
    selectedMethodId.value = '1';
  }

  void setAsDefault(String id) {
    for (var method in paymentMethods) {
      method.isDefault = method.id == id;
    }
    selectedMethodId.value = id;
    paymentMethods.refresh();
  }

  void deletePaymentMethod(String id) {
    paymentMethods.removeWhere((m) => m.id == id);
    // Set first card as default if deleted card was default
    if (id == selectedMethodId.value && paymentMethods.isNotEmpty) {
      paymentMethods.first.isDefault = true;
      selectedMethodId.value = paymentMethods.first.id;
    }
    paymentMethods.refresh();
  }

  void addPaymentMethod(PaymentMethod method) {
    paymentMethods.add(method);
    paymentMethods.refresh();
  }
}
