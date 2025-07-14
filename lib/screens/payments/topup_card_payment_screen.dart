import 'package:flutter/material.dart';
import 'payment_success_screen.dart';

class TopupCardPaymentScreen extends StatelessWidget {
  final _holderController = TextEditingController();
  final _cardController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expController = TextEditingController();

  TopupCardPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: Stack(
        children: [
          // Header
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2594fd), Color(0xFF1de5e4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(48),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 28, top: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cirkle",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "An ecosystem for events",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.90),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          Padding(
            padding: const EdgeInsets.only(top: 90.0, left: 32, right: 32, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  "Top UP",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 28),
                // Card + Form
                Center(
                  child: Container(
                    width: 540, // Desktop/web ke liye, mobile par hata sakti ho
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 14,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            "Payment Method",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 18),
                          // Blue Inner Card
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF26A4EC),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Credit / Debit Cards",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Name of card Holder",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  _textField(_holderController),
                                  SizedBox(height: 14),
                                  Text(
                                    "Card Number",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  _textField(_cardController, keyboardType: TextInputType.number),
                                  SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "CVV",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            _textField(_cvvController, keyboardType: TextInputType.number),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Exp Date",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            _textField(_expController, hint: "MM/YY"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 38),
                // Pay Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 140,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [Color(0xFF2594fd), Color(0xFF1de5e4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.13),
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        // Payment logic
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentSuccessScreen()),
                        );
                      },
                      child: Text(
                        "Pay",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Back arrow (bottom left)
          Positioned(
            bottom: 30,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_left, size: 36, color: Colors.black87),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper for blue card fields
  Widget _textField(TextEditingController controller, {TextInputType keyboardType = TextInputType.text, String? hint}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint ?? "",
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
