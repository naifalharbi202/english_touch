import 'package:call_me/modules/register/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';

import 'package:call_me/shared/remote/dio_helper.dart';
import 'package:dio/dio.dart';

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
  }) async {
    emit(RegisterLoadingState());

    Response response = await DioHelper.postData(url: '/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone
    });

    if (response.statusCode == 200) {
      // Created user successfully in users table
      toastMessage(message: 'تم إنشاء المستخدم بنجاح');
      emit(CreateUserSuccessState());
    } else if (response.statusCode == 422) {
      //Validation error
      //  toastMessage(message: response.data['error']);
      var errorMessage = response.data['error'];
      print('errorMessage isssssss ------ $errorMessage');
      if (errorMessage.contains('6')) {
        toastMessage(
            message: langCode == 'ar'
                ? 'كلمة المرور يجب أن تتكون من 6 خانات على الأقل'
                : 'The password field must be at least 6 characters',
            backgroundColor: const Color.fromARGB(255, 42, 38, 27));
      } else if (errorMessage.contains('email has already been taken')) {
        toastMessage(
            message: langCode == 'ar'
                ? 'البريد الإلكتروني مسجل مسبقًا'
                : 'The email has already been taken.',
            backgroundColor: const Color.fromARGB(255, 61, 58, 44));
      } else if (errorMessage.contains('valid email')) {
        toastMessage(
            message: langCode == 'ar'
                ? 'يرجى إدخال بريد إلكتروني صحيح'
                : 'Please, enter a valid email address',
            backgroundColor: const Color.fromARGB(255, 47, 43, 28));
      } else {
        toastMessage(
            message: langCode == 'ar'
                ? 'يرجى التأكد من صحة البيانات المدخلة'
                : 'Please verify the entered data\'s accuracy');
      }

      emit(CreateUserErrorState());
    } else if (response.statusCode == 500) {
      //Unexpected Error - No Server Connection/ No internet ..etc
      toastMessage(
          message: langCode == 'ar'
              ? 'حدث خطأ غير متوقع،يرجى المحاولة لاحقًا'
              : 'Unexpected Error. Please, try again later');

      emit(CreateUserErrorState());
    } else {
      //
      toastMessage(message: 'Error');
    }
    // FirebaseAuth.instance
    //     .createUserWithEmailAndPassword(email: email, password: password)
    //     .then((value) {
    //   createUser(
    //     name: name,
    //     email: email,
    //     password: password,
    //     phone: phone,
    //     uid: value.user!.uid, // uid will be created when register success
    //   );
    // }).catchError((error) {
    //   if (error.code == 'email-already-in-use' ||
    //       error.code == 'invalid-email') {
    //     toastMessage(
    //         message: langCode == 'ar'
    //             ? 'عفوًا البريد المدخل غير صالح أو مستخدم من قبل'
    //             : 'Email already in use or invalid',
    //         backgroundColor: const Color.fromARGB(255, 195, 72, 64));
    //   }
    //   if (error.code == "weak-password") {
    //     toastMessage(
    //         message: langCode == 'ar' ? 'كلمة المرور ضعيفة' : 'Weak Password',
    //         backgroundColor: const Color.fromARGB(255, 195, 72, 64));
    //   }
    //   emit(RegisterErrorState(error));
    // });
  }

//Save user data in firestore
  // void createUser({
  //   required String name,
  //   required String email,
  //   required String password,
  //   required String phone,
  //   required String uid,
  // }) {
  //   UserModel userModel = UserModel(
  //     name,
  //     email,
  //     password,
  //     phone,
  //     uid,
  //   );

  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .set(userModel.toJson())
  //       .then((value) {
  //     emit(CreateUserSuccessState(uid));
  //   }).catchError((error) {
  //     toastMessage(message: error.toString());
  //     emit(CreateUserErrorState(error));
  //   });
  // }

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
