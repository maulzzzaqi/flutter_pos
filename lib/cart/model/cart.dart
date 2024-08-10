import 'package:flutter_pos/menu/model/menu.dart';

class Cart {
  final String id;
  final String name;
  final double price;
  final int quantity;

  Cart({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory Cart.fromMenu(Menu menu) {
    return Cart(id: menu.id, name: menu.name, price: menu.price, quantity: 1);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
