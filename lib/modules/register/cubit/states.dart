import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  FirebaseAuthException? error;
  RegisterErrorState(this.error);
}

class CreateUserLoadingState extends RegisterStates {}

class CreateUserSuccessState extends RegisterStates {
  CreateUserSuccessState();
}

class CreateUserErrorState extends RegisterStates {
  CreateUserErrorState();
}

class RegisterShowPasswordState extends RegisterStates {}

class PasswordChangeState extends RegisterStates {}
