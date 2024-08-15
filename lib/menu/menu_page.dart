import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/cart/cart_bloc/cart_bloc.dart';
import 'package:flutter_pos/cart/model/cart.dart';
import 'package:flutter_pos/menu/detail_menu_page.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';
import 'package:flutter_pos/menu/model/menu.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatefulWidget {
  static const String route = '/menu';
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  TextEditingController searchController = TextEditingController();
  List<Menu> filteredMenuList = [];

  @override
  void initState() {
    context.read<MenuBloc>().add(const LoadMenuEvent());
    super.initState();
  }

  void _filterMenu(String query) {
    final state = context.read<MenuBloc>().state;
    if (state is MenuLoaded) {
      setState(() {
        filteredMenuList = state.menu
            .where((menuItem) => menuItem.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
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
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuLoaded) {
            final menuList = searchController.text.isEmpty
                ? state.menu.toList()
                : filteredMenuList;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: GoogleFonts.rubik(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    style: GoogleFonts.rubik(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                    onChanged: (query) {
                      _filterMenu(query);
                    },
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailMenuPage(menuId: menuItem.id),
                              ),
                            );
                          },
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
                                          // Original button functionality
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailMenuPage(menuId: menuItem.id),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit, color: Colors.white),
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
                ),
              ],
            );
          } else if (state is MenuError) {
            return Center(child: Text('Failed to load menu: ${state.error}'));
          }
          return Container();
        },
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
