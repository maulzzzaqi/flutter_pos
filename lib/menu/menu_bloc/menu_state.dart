part of 'menu_bloc.dart';

class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuLoading extends MenuState {
  const MenuLoading();

  @override
  List<Object> get props => [];
}

class MenuSuccess extends MenuState {
  const MenuSuccess();

  @override
  List<Object> get props => [];
}

class MenuImageUploaded extends MenuState {
  final String imageUrl;

  const MenuImageUploaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class MenuError extends MenuState {
  final String error;

  const MenuError(this.error);

  @override
  List<Object> get props => [error];
}

class MenuLoaded extends MenuState {
  final List<Menu> menu;

  const MenuLoaded(this.menu);

  @override
  List<Object> get props => [menu];
}
