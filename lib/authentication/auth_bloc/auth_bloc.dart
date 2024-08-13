import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthRegister>((event, emit) async {
      emit(const AuthState(isLoading: true));
      try {
        // Initialize Register
        final auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        // Add more user information
        await FirebaseFirestore.instance.collection('users').doc(auth.user!.uid).set({
          'name': event.name,
          'phoneNumber': event.phoneNumber,
          'email': event.email,
        });
        // Fetch additional user information
        final userData = await FirebaseFirestore.instance.collection('users').doc(auth.user?.uid).get();
        emit(AuthState(userData: auth.user, name: userData['name'], phoneNumber: userData['phoneNumber']));
      } catch (e) {
        emit(AuthState(errorMessage: e.toString()));
      }
    });
    on<AuthLogin>((event, emit) async {
      emit(const AuthState(isLoading: true));
      try {
        // Initialize Login
        final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password
        );
        // Fetch additional user information
        final userData = await FirebaseFirestore.instance.collection('users').doc(auth.user?.uid).get();
        emit(AuthState(userData: auth.user, name: userData['name'], phoneNumber: userData['phoneNumber'])); 
      } catch (e) {
        emit(AuthState(errorMessage: e.toString()));
      }
    });
    on<AuthLogout>((event, emit) async {
      // Initialize Logout
      await FirebaseAuth.instance.signOut();
      emit(const AuthState());
    });
    // Auto Login
    on<AuthCheck>((event, emit) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(AuthState(userData: user));
      } else {
        emit(const AuthState());
      }
    });
    add(const AuthCheck());
    
  }
}
