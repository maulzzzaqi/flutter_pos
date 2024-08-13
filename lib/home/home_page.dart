import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/authentication/auth_bloc/auth_bloc.dart';
import 'package:flutter_pos/authentication/login_page.dart';
import 'package:flutter_pos/cart/cart_page.dart';
import 'package:flutter_pos/drawer/app_drawer.dart';
import 'package:flutter_pos/menu/add_menu_page.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  static const String route = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<MenuBloc>().add(const LoadMenuEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POSapp',
          style: GoogleFonts.rubik(
            color: const Color(0xFF1A72DD),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Page!'),
          ],
        ),
      ),
    );
  }
}
