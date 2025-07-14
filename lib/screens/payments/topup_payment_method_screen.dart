
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopupPaymentMethodScreen extends StatefulWidget {
  const TopupPaymentMethodScreen({super.key});

  @override
  State<TopupPaymentMethodScreen> createState() => _TopupPaymentMethodScreenState();
}

class _TopupPaymentMethodScreenState extends State<TopupPaymentMethodScreen>
    with SingleTickerProviderStateMixin {
  bool _showCardForm = false;
  bool _isProcessing = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _holderController = TextEditingController();
  final _cardController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _holderController.dispose();
    _cardController.dispose();
    _cvvController.dispose();
    _expController.dispose();
    super.dispose();
  }

  void _showCardPayment() {
    setState(() {
      _showCardForm = true;
    });
    _animationController.forward();
  }

  void _hideCardForm() {
    _animationController.reverse().then((_) {
      setState(() {
        _showCardForm = false;
      });
    });
  }

  String? _validateCardHolder(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card holder name is required';
    }
    if (value.trim().length < 2) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    String cleaned = value.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'Please enter a valid card number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Card number should contain only digits';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    if (value.length < 3 || value.length > 4) {
      return 'Invalid CVV';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'CVV should contain only digits';
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return 'Please use MM/YY format';
    }

    List<String> parts = value.split('/');
    int month = int.parse(parts[0]);
    int year = int.parse(parts[1]) + 2000;
    DateTime expiry = DateTime(year, month);
    DateTime now = DateTime.now();

    if (expiry.isBefore(DateTime(now.year, now.month))) {
      return 'Card has expired';
    }

    return null;
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final amount = args?['amount'] ?? 0.0;

      Navigator.pushNamed(
        context,
        '/payment_success',
        arguments: {
          'message': 'Top-up payment successful!',
          'amount': amount,
          'paymentMethod': 'Credit/Debit Card',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final amount = args?['amount'] ?? 0.0;
    final isTopUp = args?['isTopUp'] ?? true;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Top UP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_showCardForm) {
              _hideCardForm();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight -
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
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
                          Text(
                            "Topup Payment",
                            style: TextStyle(
                              fontSize: 28,
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

                  // Main content
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_showCardForm) ...[
                            Text(
                              "Top UP",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.82),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Payment Method Selection
                            Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Credit/Debit Card
                            _buildPaymentOption(
                              context,
                              icon: Icons.credit_card,
                              title: 'Credit / Debit Cards',
                              subtitle: 'Secure payment with your card',
                              color: Color(0xFF1976D2),
                              onTap: _showCardPayment,
                            ),

                            SizedBox(height: 12),

                            // UPI Payment
                            _buildPaymentOption(
                              context,
                              icon: Icons.qr_code,
                              title: 'UPI',
                              subtitle: 'Pay instantly with UPI QR code',
                              color: Color(0xFF4CAF50),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/upi_payment',
                                  arguments: {
                                    'amount': amount,
                                    'isTopUp': true,
                                    'cardData': {
                                      'amount': amount,
                                      'isTopUp': true,
                                    },
                                  },
                                );
                              },
                            ),

                            SizedBox(height: 12),

                            // Cash Payment
                            _buildPaymentOption(
                              context,
                              icon: Icons.money,
                              title: 'Cash',
                              subtitle: 'Pay with physical cash',
                              color: Color(0xFF795548),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/payment_success',
                                  arguments: {
                                    'message': 'Cash payment received for top-up!',
                                    'amount': amount,
                                    'paymentMethod': 'Cash',
                                  },
                                );
                              },
                            ),

                            SizedBox(height: 20),

                            // Amount summary
                            _buildAmountSummary(amount),
                          ] else ...[
                            // Card Payment Form
                            SlideTransition(
                              position: _slideAnimation.drive(
                                Tween<Offset>(
                                  begin: Offset(0.0, 0.3),
                                  end: Offset.zero,
                                ),
                              ),
                              child: FadeTransition(
                                opacity: _slideAnimation,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildCardForm(),
                                      SizedBox(height: 24),
                                      _buildPayButton(amount),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: color,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSummary(double amount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1976D2).withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFF1976D2).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Color(0xFF1976D2),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Payment Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          Divider(
            height: 24,
            color: Color(0xFF1976D2).withOpacity(0.2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Up Amount',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color(0xFF1976D2).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: Color(0xFF1976D2),
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Credit / Debit Cards",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Enter your card details below",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Card Holder Name
            _buildFieldLabel("Card Holder Name"),
            SizedBox(height: 8),
            _buildTextField(
              controller: _holderController,
              validator: _validateCardHolder,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
            ),
            SizedBox(height: 20),

            // Card Number
            _buildFieldLabel("Card Number"),
            SizedBox(height: 8),
            _buildTextField(
              controller: _cardController,
              validator: _validateCardNumber,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                _CardNumberInputFormatter(),
              ],
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel("CVV"),
                      SizedBox(height: 8),
                      _buildTextField(
                        controller: _cvvController,
                        validator: _validateCVV,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel("Exp Date"),
                      SizedBox(height: 8),
                      _buildTextField(
                        controller: _expController,
                        validator: _validateExpiry,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          _ExpiryDateInputFormatter(),
                        ],
                        hint: "MM/YY",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? hint,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: TextStyle(
            color: Colors.red[600],
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPayButton(double amount) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Color(0xFF2594fd), Color(0xFF1de5e4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2594fd).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isProcessing ? null : _processPayment,
          child: Center(
            child: _isProcessing
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Processing...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payment,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "Pay ₹${amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom input formatter for card numbers
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(RegExp(r'\s+'), '');
    final newText = text.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ');

    return newValue.copyWith(
      text: newText.trim(),
      selection: TextSelection.collapsed(offset: newText.trim().length),
    );
  }
}

// Custom input formatter for expiry dates
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    String newText = text;

    if (text.length >= 2) {
      newText = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
