import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/authentication/auth_bloc/auth_bloc.dart';
import 'package:flutter_pos/authentication/login_page.dart';
import 'package:flutter_pos/cart/cart_bloc/cart_bloc.dart';
import 'package:flutter_pos/cart/cart_page.dart';
import 'package:flutter_pos/cart/model/cart.dart';
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
            BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                if (state is MenuLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MenuLoaded) {
                  final menuList = state.menu.toList();
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: menuList.length,
                      itemBuilder: (context, index) {
                        final menuItem = menuList[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  menuItem.imageUrl != null
                                    ? Image.network(
                                        menuItem.imageUrl!,
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: double.infinity,
                                      )
                                    : Container(
                                        height: 120,
                                        color: Colors.grey.shade300,
                                        child: const Center(
                                          child: Text(
                                            'No Image',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menuItem.name,
                                          style: GoogleFonts.rubik(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          menuItem.description,
                                          style: GoogleFonts.rubik(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp. ${menuItem.price}',
                                        style: GoogleFonts.rubik(
                                          color: const Color(0xFF1A72DD),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Container(
                                        width: 32,
                                        height: 32, 
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1A72DD),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(AddToCartEvent(Cart.fromMenu(menuItem)));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('${menuItem.name} added to cart!'))
                                            );
                                          },
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          padding: const EdgeInsets.all(4),
                                          iconSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is MenuError) {
                  return Center(child: Text('Failed to load menu: ${state.error}'));
                }
                return Container();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A72DD),
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: const Icon(Icons.shopping_cart_rounded, color: Colors.white),
      ),
    );
  }
}
