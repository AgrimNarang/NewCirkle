import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';

class CheckBalanceAmountLeftScreen extends StatelessWidget {
  final int remainingAmount;
  final String cardNumber;
  const CheckBalanceAmountLeftScreen({
    super.key,
    this.remainingAmount = 2000,
    this.cardNumber = '',
  });
  @override
  Widget build(BuildContext context) {
    // Get arguments from route
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final int displayAmount = args?['remainingAmount'] ?? remainingAmount;
    final String displayCardNumber = args?['cardNumber'] ?? cardNumber;
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: SafeArea(
        child: Stack(
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
            Center(
              child: Container(
                width: 330,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 36, horizontal: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Amount Left",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 26),
                    if (displayCardNumber.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Card Number",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "**** **** **** ${displayCardNumber.substring(displayCardNumber.length - 4)}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Remaining Amount",
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "₹$displayAmount",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Back arrow
            Positioned(
              bottom: 32,
              left: 18,
              child: IconButton(
                icon: Icon(Icons.arrow_left, size: 36, color: Colors.black87),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
