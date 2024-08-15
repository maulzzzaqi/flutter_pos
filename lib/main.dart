import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/account/account_page.dart';
import 'package:flutter_pos/account/account_settings_page.dart';
import 'package:flutter_pos/authentication/auth_bloc/auth_bloc.dart';
import 'package:flutter_pos/authentication/login_page.dart';
import 'package:flutter_pos/authentication/register_page.dart';
import 'package:flutter_pos/cart/cart_bloc/cart_bloc.dart';
import 'package:flutter_pos/cart/cart_page.dart';
import 'package:flutter_pos/firebase_options.dart';
import 'package:flutter_pos/home/home_page.dart';
import 'package:flutter_pos/menu/add_menu_page.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';
import 'package:flutter_pos/menu/menu_page.dart';
import 'package:flutter_pos/payment/payment_page.dart';
import 'package:flutter_pos/payment/payment_success_page.dart';
import 'package:flutter_pos/splash/splash_page.dart';
import 'package:flutter_pos/transaction/transaction_history_page.dart';
import 'package:flutter_pos/welcome/welcome_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => MenuBloc(),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => TransactionBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'POS App',
        theme: ThemeData(
          textTheme: GoogleFonts.rubikTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: SplashPage.route,
        routes: {
          SplashPage.route: (context) => SplashPage(),
          WelcomePage.route: (context) => WelcomePage(),
          LoginPage.route: (context) => LoginPage(),
          RegisterPage.route: (context) => RegisterPage(),
          HomePage.route: (context) => HomePage(),
          AccountPage.route: (context) => AccountPage(),
          AccountSettingsPage.route: (context) => AccountSettingsPage(),
          MenuPage.route: (context) => MenuPage(),
          AddMenuPage.route: (context) => AddMenuPage(),
          CartPage.route: (context) => CartPage(),
          PaymentPage.route: (context) => PaymentPage(),
          PaymentSuccessPage.route: (context) => PaymentSuccessPage(),
          TransactionHistoryPage.route: (context) => TransactionHistoryPage()
        },
      ),
    );
  }
}
