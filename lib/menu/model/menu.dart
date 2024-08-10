import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  final String name;
  final double price;
  final String description;
  final String category;

  const Menu({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
  });

  factory Menu.fromSnapshot(DocumentSnapshot doc) {
    return Menu(
      name: doc['name'],
      price: doc['price'],
      description: doc['description'],
      category: doc['category']
    );
  }
}
