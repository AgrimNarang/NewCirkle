import 'package:flutter/material.dart';

class PaymentBillScreen extends StatelessWidget {
  const PaymentBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: Stack(
        children: [
          // --- Header ---
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
          // --- Main Content ---
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 32, right: 32, bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Text(
                  "Payment Bill",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.82),
                  ),
                ),
                SizedBox(height: 22),
                // Bill Card
                Center(
                  child: Container(
                    width: 600, // Adjust as needed
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
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "-----------------------------------RECIEPT------------------------------------",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name: Sayantan Roy\nKOT : 112",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                "Date: 08 Jun 2025",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(thickness: 2),
                          // Table Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text("Item", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                              ),
                              Expanded(
                                child: Text("Price", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text("Quantity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                          Divider(),
                          // Item Rows
                          _itemRow("Cheeze\nBurger", "₹259", "2", "₹518"),
                          _itemRow("Puff", "₹99", "8", "₹792"),
                          Divider(thickness: 2),
                          // Subtotal, GST, Total
                          Padding(
                            padding: const EdgeInsets.only(top: 14, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Sub-Total:     ₹1310",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("GST:    ", style: TextStyle(fontSize: 18)),
                                    Text("5%", style: TextStyle(fontSize: 17)),
                                    SizedBox(width: 14),
                                    Text("₹65.5", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Divider(thickness: 1.4, endIndent: 2, indent: 120),
                                Text(
                                  "Total:      ₹1375.5",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(thickness: 2),
                          SizedBox(height: 12),
                          Text(
                            "THANK YOU FOR ORDERING !",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(thickness: 1),
                          SizedBox(height: 7),
                          Text(
                            "** SAVE PAPER SAVE NATURE !!",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey[500],
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // --- Back arrow (bottom left) ---
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
          // --- Print Button (bottom right) ---
          Positioned(
            bottom: 28,
            right: 36,
            child: Container(
              width: 120,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                  // TODO: Print logic here
                },
                child: Text(
                  "Print",
                  style: TextStyle(
                    fontSize: 22,
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
    );
  }

  // Helper for item row
  Widget _itemRow(String item, String price, String qty, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(item, style: TextStyle(fontSize: 17)),
          ),
          Expanded(
            child: Text(price, style: TextStyle(fontSize: 17), textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text(qty, style: TextStyle(fontSize: 17), textAlign: TextAlign.center),
          ),
          Expanded(
            child: Text(total, style: TextStyle(fontSize: 17), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
