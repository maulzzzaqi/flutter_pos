import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/authentication/auth_bloc/auth_bloc.dart';
import 'package:flutter_pos/authentication/login_page.dart';
import 'package:flutter_pos/cart/cart_page.dart';
import 'package:flutter_pos/menu/add_menu_page.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';

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
        title: const Text('Home Page'),
        backgroundColor: Colors.blue.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddMenuPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogout());
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.userData != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Currently logged in user:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text('Email: ${state.userData?.email}'),
                      Text('UID: ${state.userData?.uid}'),
                      Text('Name: ${state.name}'),
                      Text('Phone Number: ${state.phoneNumber}'),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No user data available.'));
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/menu');
            },
            child: const Text('Go to menu page'),
          )
        ],
      ),
    );
  }
}
