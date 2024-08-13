import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/authentication/auth_bloc/auth_bloc.dart';
import 'package:flutter_pos/authentication/login_page.dart';
import 'package:flutter_pos/authentication/register_page.dart';
import 'package:flutter_pos/cart/cart_bloc/cart_bloc.dart';
import 'package:flutter_pos/cart/cart_page.dart';
import 'package:flutter_pos/firebase_options.dart';
import 'package:flutter_pos/home_page.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';
import 'package:flutter_pos/menu_page.dart';
import 'package:flutter_pos/splash/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme
        )
      ),
      home: MultiBlocProvider(
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
        ],
        child: MaterialApp(
          initialRoute: SplashPage.route,
          routes: {
            SplashPage.route: (context) => SplashPage(),
            LoginPage.route: (context) => LoginPage(),
            RegisterPage.route: (context) => RegisterPage(),
            HomePage.route: (context) => HomePage(),
            MenuPage.route: (context) => MenuPage(),
            CartPage.route: (context) => CartPage(),
          },
        ),
      ),
    );
  }
}
