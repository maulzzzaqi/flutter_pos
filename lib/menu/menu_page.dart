import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/cart/cart_bloc/cart_bloc.dart';
import 'package:flutter_pos/cart/model/cart.dart';
import 'package:flutter_pos/menu/detail_menu_page.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatefulWidget {
  static const String route = '/menu';
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
          'Menu List',
          style: GoogleFonts.rubik(
            color: const Color(0xFF1A72DD),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMenuPage(menuId: menuItem.id)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                menuItem.imageUrl != null
                                  ? Image.network(
                                      menuItem.imageUrl!,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: double.infinity,
                                    )
                                  : Container(
                                      height: 100,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Text(
                                          'No Image',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                const SizedBox(height: 8.0),
                                Text(
                                  menuItem.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Rp. ${menuItem.price}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  menuItem.description,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  menuItem.category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A72DD),
        onPressed: () {
          Navigator.pushNamed(context, '/add_menu');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
