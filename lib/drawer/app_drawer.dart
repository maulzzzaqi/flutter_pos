import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/authentication/auth_bloc/auth_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A72DD),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  size: 50,
                  color: Colors.white,
                ),
                Text(
                  'POSapp',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            title: Text(
              'Account',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/account');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
            ),
            title: Text(
              'Menu',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/menu');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            title: Text(
              'Transaction History',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/history');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              context.read<AuthBloc>().add(const AuthLogout());
              Navigator.of(context).pushReplacementNamed('/welcome');
            },
          ),
        ],
      ),
    );
  }
}