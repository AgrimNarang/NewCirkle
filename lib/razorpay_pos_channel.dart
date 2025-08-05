import 'package:flutter/services.dart';

class RazorpayPOSChannel {
  static const MethodChannel _channel = MethodChannel('razorpay_pos');

  static Future<dynamic> startPayment(String orderId) async {
    return await _channel.invokeMethod('startPayment', {'orderId': orderId});
  }
}
