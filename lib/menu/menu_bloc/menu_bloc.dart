import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pos/menu/model/menu.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState()) {
    // Add Menu to firestore
    on<AddMenuEvent>((event, emit) async {
      emit(const MenuLoading());
      try {
        final menuRef = await FirebaseFirestore.instance.collection('menu').add({
          'name': event.name,
          'price': event.price,
          'description': event.description,
          'category': event.category,
        });
        String? imageUrl;
        if (event.imageFile != null) {
          final storageRef = FirebaseStorage.instance.ref().child('menu_images/${menuRef.id}');
          await storageRef.putFile(event.imageFile!);
          imageUrl = await storageRef.getDownloadURL();
        }
        await menuRef.update({
          'imageUrl': imageUrl,
        });
        emit(const MenuSuccess());
        add(const LoadMenuEvent());
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });
    // Edit Menu
    on<EditMenuEvent>((event, emit) async {
      emit(const MenuLoading());
      try {
        String? imageUrl;
        if (event.imageFile != null) {
          final storageRef = FirebaseStorage.instance.ref().child('menu_images/${event.id}');
          await storageRef.putFile(event.imageFile!);
          imageUrl = await storageRef.getDownloadURL();
        }
        final updateData = {
          'name': event.name,
          'price': event.price,
          'description': event.description,
          'category': event.category,
        };
        if (imageUrl != null) {
          updateData['imageUrl'] = imageUrl;
        }
        await FirebaseFirestore.instance.collection('menu').doc(event.id).update(updateData);
        emit(const MenuSuccess());
        add(const LoadMenuEvent());
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });
    // Delete menu from firestore
    on<DeleteMenuEvent>((event, emit) async {
      emit(const MenuLoading());
      try {
        await FirebaseFirestore.instance.collection('menu').doc(event.id).delete();
        emit(const MenuSuccess());
        add(const LoadMenuEvent());
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
    on<UploadMenuImageEvent>((event, emit) async {
      emit(const MenuLoading());
      try {
        final fileName = event.menuUid;
        final storageRef = FirebaseStorage.instance.ref().child('menu_images/$fileName');
        await storageRef.putFile(event.image);
        final imageUrl = await storageRef.getDownloadURL();
        emit(MenuImageUploaded(imageUrl));
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });
    on<LoadMenuDetailEvent>((event, emit) async {
      emit(const MenuLoading());
      try {
        final doc = await FirebaseFirestore.instance.collection('menu').doc(event.id).get();

        if (doc.exists) {
          final menu = Menu.fromSnapshot(doc);
          emit(MenuDetailLoaded(menu));
        } else {
          emit(const MenuError('Menu Not Found!'));
        }
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });
    add(const LoadMenuEvent());
  }
}
