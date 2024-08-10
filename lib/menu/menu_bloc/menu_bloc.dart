import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_pos/menu/model/menu.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState()) {
    on<MenuEvent>((event, emit) {
      // Add Menu to firestore
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
      // Read Menu from firestore
      on<LoadMenuEvent>((event, emit) async {
        emit(const MenuLoading());
        try {
          QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('menu').get();
          final menu = snapshot.docs.map((e) {
            return Menu.fromSnapshot(e);
          }).toList();
          emit(MenuLoaded(menu));
        } catch (e) {
          emit(MenuError(e.toString()));
        }
      });
    });
  }
}
