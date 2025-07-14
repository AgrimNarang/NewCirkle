import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UpiPaymentScreen extends StatefulWidget {
  const UpiPaymentScreen({super.key});

  @override
  State<UpiPaymentScreen> createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  String _generateUpiString(double amount, {bool isTopUp = false}) {
    // Generate dynamic UPI payment string
    final String upiId = "merchant@paytm"; // Replace with actual merchant UPI ID
    final String merchantName = "Cirkle Merchant";
    final String transactionRef = "TXN${DateTime.now().millisecondsSinceEpoch}";
    final String note = isTopUp ? "Card Top-up Payment" : "Card Issue Payment";

    return "upi://pay?pa=$upiId&pn=$merchantName&tr=$transactionRef&am=${amount.toStringAsFixed(2)}&cu=INR&tn=$note";
  }

  void _showPaymentConfirmation(BuildContext context, double amount, bool isTopUp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Payment Received',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'UPI payment of ₹${amount.toStringAsFixed(2)} has been received successfully.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamed(
                  context,
                  '/payment_success',
                  arguments: {
                    'message': isTopUp ? 'Top-up payment successful!' : 'Card issue payment successful!',
                    'amount': amount,
                    'paymentMethod': 'UPI',
                  },
                );
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final amount = args?['amount'] ?? 0.0;
    final isTopUp = args?['isTopUp'] ?? false;
    final cardData = args?['cardData'] ?? {};

    // Use amount from cardData if available (for card issue flow)
    // Ensure amount is properly converted to double
    double paymentAmount = 0.0;
    if (amount != 0.0) {
      paymentAmount = amount is String ? double.tryParse(amount) ?? 0.0 : (amount as double);
    } else {
      final cardAmount = cardData['amount'];
      paymentAmount = cardAmount is String ? double.tryParse(cardAmount) ?? 0.0 : (cardAmount as double? ?? 0.0);
    }

    final String upiString = _generateUpiString(paymentAmount, isTopUp: isTopUp);

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'UPI Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'UPI Payment',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Scan QR code to pay ₹${paymentAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // QR Code Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Scan QR Code',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            SizedBox(height: 16),

                            // QR Code
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFF4CAF50).withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: Container(
                                width: 180,
                                height: 180,
                                child: QrImageView(
                                  data: upiString,
                                  version: QrVersions.auto,
                                  size: 180.0,
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                                  embeddedImage: null,
                                  embeddedImageStyle: null,
                                ),
                              ),
                            ),

                            SizedBox(height: 16),
                            Text(
                              'Open any UPI app and scan this QR code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Payment Details
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4CAF50).withOpacity(0.1), Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFF4CAF50).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.payment,
                                color: Color(0xFF4CAF50),
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Payment Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 16,
                            color: Color(0xFF4CAF50).withOpacity(0.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isTopUp ? 'Top-up Amount' : 'Total Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '₹${paymentAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Instructions
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF4CAF50).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Instructions:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1. Open any UPI app (GPay, PhonePe, Paytm, etc.)\n'
                                '2. Scan the QR code above\n'
                                '3. Verify the amount and complete payment\n'
                                '4. Click "I have paid" button below after payment',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Payment Confirmation Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            // Simulate random payment success/failure
                            bool paymentSuccess = DateTime.now().millisecondsSinceEpoch % 3 != 0; // 66% success rate

                            if (paymentSuccess) {
                              Navigator.pushNamed(
                                context,
                                '/payment_success',
                                arguments: {
                                  'message': 'UPI payment completed successfully!',
                                  'amount': paymentAmount,
                                  'paymentMethod': 'UPI',
                                  'orderDetails': cardData['orderDetails'],
                                },
                              );
                            } else {
                              Navigator.pushNamed(
                                context,
                                '/transaction_failed',
                                arguments: {
                                  'amount': paymentAmount,
                                  'paymentMethod': 'UPI',
                                  'orderDetails': cardData['orderDetails'],
                                },
                              );
                            }
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'I have paid ₹${paymentAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}