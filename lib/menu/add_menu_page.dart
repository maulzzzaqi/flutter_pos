import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMenuPage extends StatefulWidget {
  static const String route = '/add_menu';
  const AddMenuPage({super.key});

  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;
  File? menuImage;

  final List<String> categories = ['Appetizer', 'Main Course', 'Dessert', 'Drink'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu Item'),
      ),
      body: BlocProvider(
        create: (_) => MenuBloc(),
        child: BlocListener<MenuBloc, MenuState>(
          listener: (context, state) {
            if (state is MenuSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu item added successfully!')),
              );
              nameController.clear();
              priceController.clear();
              descriptionController.clear();
              setState(() {
                selectedCategory = null;
              });
            } else if (state is MenuError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add menu item: ${state.error}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Menu Item Name',
                        hintStyle: GoogleFonts.rubik(
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Price',
                        hintStyle: GoogleFonts.rubik(
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: GoogleFonts.rubik(
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      hint: Text(
                        'Select Category',
                        style: GoogleFonts.rubik(
                          color: Colors.black54,
                        ),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                BlocBuilder<MenuBloc, MenuState>(
                  builder: (context, state) {
                    if (state is MenuLoading) {
                      return const CircularProgressIndicator();
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A72DD),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          final name = nameController.text;
                          final price = double.tryParse(priceController.text) ?? 0.0;
                          final description = descriptionController.text;
                          final category = selectedCategory;
                      
                          if (category != null) {
                            context.read<MenuBloc>().add(AddMenuEvent(name, price, description, category));
                            context.read<MenuBloc>().add(const LoadMenuEvent());
                            Future.delayed(const Duration(milliseconds: 300), () {
                              Navigator.pushReplacementNamed(context, '/menu');
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a category')),
                            );
                          }
                        },
                        child: Text(
                          'Add Menu Item',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
