import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _loginUrl = 'https://bzhcanphmh.execute-api.ap-south-1.amazonaws.com/prod/login';

  // Cognito test user credentials
  static const String _username = 'test';
  static const String _password = 'Test123!';

  static Future<String?> loginAndGetToken({
    String username = _username,
    String password = _password,
  }) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Adjust the key below based on the actual API response
      return data['token'] ?? data['access_token'] ?? data['jwt'];
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }

  /// Razorpay Lambda API: Verify Payment
  static Future<Map<String, dynamic>?> verifyPayment({
    required String token,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final response = await http.post(
      Uri.parse('https://bzhcanphmh.execute-api.ap-south-1.amazonaws.com/prod/verify-payment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Payment verification failed: ${response.body}');
      return null;
    }
  }

  /// Razorpay Lambda API: Create Order
  static Future<Map<String, dynamic>?> createOrder({
    required String token,
    required int amount, // in paise (e.g., 10000 for ₹100)
    required String receipt,
    required String userId,
    required String rfidTag,
    Map<String, dynamic>? notes,
  }) async {
    final response = await http.post(
      Uri.parse('https://bzhcanphmh.execute-api.ap-south-1.amazonaws.com/prod/create-order'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'currency': 'INR',
        'receipt': receipt,
        'userId': userId,
        'rfidTag': rfidTag,
        if (notes != null) 'notes': notes,
      }),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Order creation failed: ${response.body}');
      return null;
    }
  }
}
