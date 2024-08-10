part of 'menu_bloc.dart';

class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class AddMenuEvent extends MenuEvent {
  final String name;
  final double price;
  final String description;
  final String category;

  const AddMenuEvent(this.name, this.price, this.description, this.category);

  @override
  List<Object> get props => [name, price, description, category];
}

class LoadMenuEvent extends MenuEvent {
  const LoadMenuEvent();

  @override
  List<Object> get props => [];
}
