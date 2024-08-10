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

class EditMenuEvent extends MenuEvent {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;

  const EditMenuEvent(this.id, this.name, this.price, this.description, this.category);

  @override
  List<Object> get props => [id, name, price, description, category];
}

class DeleteMenuEvent extends MenuEvent {
  final String id;

  const DeleteMenuEvent(this.id);

  @override
  List<Object> get props => [id];
}

class LoadMenuEvent extends MenuEvent {
  const LoadMenuEvent();

  @override
  List<Object> get props => [];
}
