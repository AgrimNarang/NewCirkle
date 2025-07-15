import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/cards/issue_new_card_screen.dart';
import 'screens/cards/tap_new_card_screen.dart';
import 'screens/payments/methods/payment_method_screen.dart';
import 'screens/payments/processing/card_payment_screen.dart';
import 'screens/payments/processing/upi_payment_screen.dart';
import 'screens/payments/results/transaction_failed_screen.dart';
import 'screens/cards/top_up_screen.dart';
import 'screens/cards/tap_card_screen.dart';
import 'screens/payments/topup_payment_method_screen.dart';
import 'screens/payments/topup_card_payment_screen.dart';
import 'screens/cards/check_balance_tap_card.dart';
import 'screens/cards/check_balance_amount_left.dart';
import 'screens/orders/menu/order_screen.dart';
import 'screens/orders/checkout/order_summary_screen.dart';
import 'screens/payments/results/payment_success_screen.dart';
import 'screens/orders/bills/bill_kot_screen.dart';
import 'screens/refund/refund_screen.dart';
import 'screens/summary/summary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cirkle POS',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/dashboard': (context) => DashboardScreen(),
        '/issue_new_card': (context) => IssueNewCardScreen(),
        '/tap_card': (context) => TapCardScreen(),
        '/tap_new_card': (context) {
          final args =
          ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?;
          return TapNewCardScreen(
            cardData: args?['cardData'] ?? {},
            paymentMethod: args?['paymentMethod'] ?? 'Unknown',
          );
        },
        '/check_balance_amount_left': (context) =>
            CheckBalanceAmountLeftScreen(),
        '/top_up': (context) => TopUpScreen(),
        '/topup': (context) => TopUpScreen(),
        '/topup_tap_card': (context) => TapCardScreen(),
        '/check_balance_tap_card': (context) => CheckBalanceTapCardScreen(),
        '/order': (context) => OrderScreen(),
        '/order_summary': (context) => OrderSummaryScreen(),
        '/payment_bill': (context) => TransactionFailedScreen(),
        '/bill_kot': (context) => BillKotScreen(),
        '/card_payment': (context) => CardPaymentScreen(),
        '/topup_card_payment': (context) => TopupCardPaymentScreen(),
        '/payment_method': (context) => PaymentMethodScreen(),
        '/topup_payment_method': (context) => TopupPaymentMethodScreen(),
        '/payment_success': (context) => PaymentSuccessScreen(),
        '/upi_payment': (context) => UpiPaymentScreen(),
        '/transaction_failed': (context) => TransactionFailedScreen(),
        '/refund': (context) => RefundScreen(),
        '/summary': (context) => SummaryScreen(),
      },
    );
  }
}