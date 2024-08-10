import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState()) {
    on<MenuEvent>((event, emit) {
      on<AddMenuEvent>((event, emit) async {
        emit(const MenuLoading());
        try {
          await FirebaseFirestore.instance.collection('menu').add({
            'name': event.name,
            'price': event.price,
            'description': event.description,
            'category': event.category,
          });
          emit(const MenuSuccess());
        } catch (e) {
          emit(MenuError(e.toString()));
        }
      });
    });
  }
}
