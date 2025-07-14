import 'package:flutter/material.dart';

// --- Helper for Gradient Border ---
class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(18));
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF2594fd), Color(0xFF1de5e4)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(rrect, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// --- Main Widget ---
class TapCardScreen extends StatelessWidget {
  const TapCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: SafeArea(
        child: Stack(
          children: [
            // Header
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2594fd), Color(0xFF1de5e4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(48)),
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
            // Content
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 28, top: 10),
                    child: Text(
                      "Top UP",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.82),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Payment method pe le jao
                        Navigator.pushNamed(context, '/topup_payment_method');
                      },
                      child: CustomPaint(
                        painter: _GradientBorderPainter(),
                        child: Container(
                          width: width > 400 ? 360 : width * 0.8,
                          height: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(3, 7),
                              ),
                            ],
                          ),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [Color(0xFF2594fd), Color(0xFF1de5e4)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              "Tap the card",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Back Arrow
            Positioned(
              bottom: 38,
              left: 24,
              child: IconButton(
                icon: Icon(Icons.arrow_left, size: 36, color: Colors.black87),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
