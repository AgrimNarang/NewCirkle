import 'api_login.dart';
import 'razorpay_pos_channel.dart';

Future<void> startFullPosPaymentFlow() async {
  // 1. Login and get token
  final token = await ApiService.loginAndGetToken();
  if (token == null) {
    print('Login failed');
    return;
  }

  // 2. Create order
  final order = await ApiService.createOrder(
    token: token,
    amount: 10000, // ₹100
    receipt: 'receipt_001',
    userId: 'user123',
    rfidTag: 'RFID001',
    notes: {'item': 'Coffee', 'vendor': 'Cafe Corner'},
  );
  if (order == null || order['razorpayOrderId'] == null) {
    print('Order creation failed');
    return;
  }
  final razorpayOrderId = order['razorpayOrderId'];

  // 3. Start POS payment
  final paymentResult = await RazorpayPOSChannel.startPayment(razorpayOrderId);
  print('POS Payment Result: $paymentResult');

  // 4. (Optional) Call verify-payment API if needed
  // final verification = await ApiService.verifyPayment(
  //   token: token,
  //   razorpayOrderId: razorpayOrderId,
  //   razorpayPaymentId: paymentResult['paymentId'],
  //   razorpaySignature: paymentResult['signature'],
  // );
  // print('Payment Verification: $verification');
}
