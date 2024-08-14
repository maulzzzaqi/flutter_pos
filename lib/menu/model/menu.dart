import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String? imageUrl;

  const Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    this.imageUrl,
  });

  factory Menu.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Menu(
      id: doc.id,
      name: data['name'],
      price: data['price'],
      description: data['description'],
      category: data['category'],
      imageUrl: data['imageUrl'],
    );
  }
}
