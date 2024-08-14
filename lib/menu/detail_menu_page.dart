import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class DetailMenuPage extends StatefulWidget {
  static const String route = '/detail_menu';
  final String menuId;

  const DetailMenuPage({super.key, required this.menuId});

  @override
  _DetailMenuPageState createState() => _DetailMenuPageState();
}

class _DetailMenuPageState extends State<DetailMenuPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;
  File? menuImage;
  String? imageUrl;

  final List<String> categories = ['Appetizer', 'Main Course', 'Dessert', 'Drink'];

  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        menuImage = File(pickedImage.path);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final menuId = widget.menuId;
    context.read<MenuBloc>().add(LoadMenuDetailEvent(menuId));
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Menu Item'),
      ),
      body: BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuDetailLoaded) {
            nameController.text = state.menu.name;
            priceController.text = state.menu.price.toString();
            descriptionController.text = state.menu.description;
            selectedCategory = state.menu.category;
            imageUrl = state.menu.imageUrl;
          } else if (state is MenuSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menu item updated successfully!')),
            );
            Navigator.pop(context);
          } else if (state is MenuError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update menu item: ${state.error}')),
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
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                        image: menuImage != null
                            ? DecorationImage(
                                image: FileImage(menuImage!),
                                fit: BoxFit.cover,
                              )
                            : imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                      ),
                      child: menuImage == null && imageUrl == null
                          ? Center(
                              child: Text(
                                'Pick Image',
                                style: GoogleFonts.rubik(color: Colors.black54),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16.0),
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
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A72DD),
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                              context.read<MenuBloc>().add(EditMenuEvent(
                                widget.menuId,
                                name,
                                price,
                                description,
                                category,
                                menuImage,
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select a category')),
                              );
                            }
                          },
                          child: Text(
                            'Save Changes',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          onPressed: () {
                            context.read<MenuBloc>().add(DeleteMenuEvent(widget.menuId));
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Delete',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
