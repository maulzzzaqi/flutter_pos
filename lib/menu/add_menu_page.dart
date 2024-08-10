import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/menu/menu_bloc/menu_bloc.dart';

class AddMenuPage extends StatelessWidget {
  AddMenuPage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

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
              _nameController.clear();
              _priceController.clear();
              _descriptionController.clear();
              _categoryController.clear();
            } else if (state is MenuError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add menu item: ${state.error}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Menu Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                BlocBuilder<MenuBloc, MenuState>(
                  builder: (context, state) {
                    if (state is MenuLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        final name = _nameController.text;
                        final price = double.tryParse(_priceController.text) ?? 0.0;
                        final description = _descriptionController.text;
                        final category = _categoryController.text;
                        context.read<MenuBloc>().add(
                          AddMenuEvent(name, price, description, category)
                        );
                      },
                      child: const Text('Add Menu Item'),
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
