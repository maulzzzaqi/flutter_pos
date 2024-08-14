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
  final File? imageFile;

  const AddMenuEvent(
      this.name, this.price, this.description, this.category, this.imageFile);

  @override
  List<Object> get props =>
      [name, price, description, category, imageFile ?? ''];
}

class EditMenuEvent extends MenuEvent {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final File? imageFile;

  const EditMenuEvent(this.id, this.name, this.price, this.description,
      this.category, this.imageFile);

  @override
  List<Object> get props =>
      [id, name, price, description, category, imageFile ?? ''];
}

class DeleteMenuEvent extends MenuEvent {
  final String id;

  const DeleteMenuEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UploadMenuImageEvent extends MenuEvent {
  final File image;
  final String menuUid;

  const UploadMenuImageEvent(this.image, this.menuUid);

  @override
  List<Object> get props => [image, menuUid];
}

class LoadMenuEvent extends MenuEvent {
  const LoadMenuEvent();

  @override
  List<Object> get props => [];
}

class LoadMenuDetailEvent extends MenuEvent {
  final String id;

  const LoadMenuDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

