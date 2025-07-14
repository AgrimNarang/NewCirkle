import 'package:cirmle_rfid_pos/screens/auth/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/cards/issue_new_card_screen.dart';
import 'screens/cards/tap_new_card_screen.dart';
import 'screens/payments/payment_method_screen.dart';
import 'screens/payments/card_payment_screen.dart';
import 'screens/payments/upi_payment_screen.dart';
import 'screens/payments/transaction_failed_screen.dart';
import 'screens/cards/top_up_screen.dart';
import 'screens/cards/tap_card_screen.dart';
import 'screens/payments/topup_payment_method_screen.dart';
import 'screens/payments/topup_card_payment_screen.dart';
import 'screens/cards/check_balance_tap_card.dart';
import 'screens/cards/check_balance_amount_left.dart';
import 'screens/orders/order_screen.dart';
import 'screens/orders/order_summary_screen.dart';
import 'screens/payments/payment_success_screen.dart';
import 'screens/orders/bill_kot_screen.dart';
import 'screens/admin/admin_user_management_screen.dart';
import 'widgets/route_guard.dart';

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
      title: 'Cirkle POS',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/dashboard': (context) => RouteGuard(
          route: '/dashboard',
          child: DashboardScreen(),
        ),
        '/issue_new_card': (context) => RouteGuard(
          route: '/issue_new_card',
          child: IssueNewCardScreen(),
        ),
        '/tap_card': (context) => RouteGuard(
          route: '/tap_card',
          child: TapCardScreen(),
        ),
        '/tap_new_card': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return RouteGuard(
            route: '/tap_new_card',
            child: TapNewCardScreen(
              cardData: args?['cardData'] ?? {},
              paymentMethod: args?['paymentMethod'] ?? 'Unknown',
            ),
          );
        },
        '/top_up': (context) => RouteGuard(
          route: '/topup',
          child: TopUpScreen(),
        ),
        '/topup': (context) => RouteGuard(
          route: '/topup',
          child: TopUpScreen(),
        ),
        '/topup_tap_card': (context) => RouteGuard(
          route: '/topup_tap_card',
          child: TapCardScreen(),
        ),
        '/check_balance_tap_card': (context) => RouteGuard(
          route: '/check_balance_tap_card',
          child: CheckBalanceTapCardScreen(),
        ),
        '/check_balance_amount_left': (context) => RouteGuard(
          route: '/check_balance_amount_left',
          child: CheckBalanceAmountLeftScreen(),
        ),
        '/order': (context) => RouteGuard(
          route: '/order',
          child: OrderScreen(),
        ),
        '/order_summary': (context) => RouteGuard(
          route: '/order_summary',
          child: OrderSummaryScreen(),
        ),
        '/payment_bill': (context) => RouteGuard(
          route: '/payment_bill',
          child: TransactionFailedScreen(),
        ),
        '/bill_kot': (context) => RouteGuard(
          route: '/bill_kot',
          child: BillKotScreen(),
        ),
        '/card_payment': (context) => RouteGuard(
          route: '/card_payment',
          child: CardPaymentScreen(),
        ),
        '/topup_card_payment': (context) => RouteGuard(
          route: '/topup_card_payment',
          child: TopupCardPaymentScreen(),
        ),
        '/payment_method': (context) => RouteGuard(
          route: '/payment_method',
          child: PaymentMethodScreen(),
        ),
        '/topup_payment_method': (context) => RouteGuard(
          route: '/topup_payment_method',
          child: TopupPaymentMethodScreen(),
        ),
        '/payment_success': (context) => RouteGuard(
          route: '/payment_success',
          child: PaymentSuccessScreen(),
        ),
        '/upi_payment': (context) => RouteGuard(
          route: '/upi_payment',
          child: UpiPaymentScreen(),
        ),
        '/transaction_failed': (context) => RouteGuard(
          route: '/transaction_failed',
          child: TransactionFailedScreen(),
        ),
        '/admin': (context) => AdminUserManagementScreen(),
      },
    );
  }
}