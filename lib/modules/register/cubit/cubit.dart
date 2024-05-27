import 'package:call_me/models/user_model.dart';
import 'package:call_me/modules/register/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off;

  void showPasswordVisibility() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(RegisterShowPasswordState());
  }

  //Register user
  void registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        uid: value.user!.uid, // uid will be created when register success
      );
    }).catchError((error) {
      if (error.code == 'email-already-in-use' ||
          error.code == 'invalid-email') {
        toastMessage(
            message: langCode == 'ar'
                ? 'عفوًا البريد المدخل غير صالح أو مستخدم من قبل'
                : 'Email already in use or invalid',
            backgroundColor: const Color.fromARGB(255, 195, 72, 64));
      }
      if (error.code == "weak-password") {
        toastMessage(
            message: langCode == 'ar' ? 'كلمة المرور ضعيفة' : 'Weak Password',
            backgroundColor: const Color.fromARGB(255, 195, 72, 64));
      }
      emit(RegisterErrorState(error));
    });
  }

//Save user data in firestore
  void createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String uid,
  }) {
    UserModel userModel = UserModel(
      name,
      email,
      password,
      phone,
      uid,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toJson())
        .then((value) {
      emit(CreateUserSuccessState(uid));
    }).catchError((error) {
      toastMessage(message: error.toString());
      emit(CreateUserErrorState(error));
    });
  }

  // Pass must be six digits
  bool? isPassUnderSix;
  void isPasswordUnderSix(value) {
    if (value.length < 6) {
      isPassUnderSix = true;
    } else {
      isPassUnderSix = false;
    }
    emit(PasswordChangeState());
  }
}
