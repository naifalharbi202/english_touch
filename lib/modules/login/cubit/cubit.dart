import 'package:call_me/models/user_model.dart';
import 'package:call_me/modules/login/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/remote/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off;

  void showPasswordVisibility() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(LoginShowPasswordState());
  }
  // login user [ FIREBASE ]

  // void loginUser({required String email, required String password}) {
  //   emit(LoginLoadingState());
  //   FirebaseAuth.instance
  //       .signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   )
  //       .then((value) {
  //     emit(LoginSuccessState(value.user!.uid));
  //   }).catchError((error) {
  //     if (error.runtimeType == FirebaseAuthException ||
  //         error.runtimeType == FirebaseException ||
  //         error.runtimeType == AssertionError) {
  //       toastMessage(
  //           message: langCode == "ar"
  //               ? 'يرجى التأكد من صحة البريد الإلكتروني أو كلمة المرور'
  //               : 'Invalid email or password',
  //           backgroundColor: const Color.fromARGB(255, 195, 72, 64));
  //     }
  //     emit(LoginErrorState(error));
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

  /////// LARAVEL SPOT //////

  //LARAVEL LOGIN //

  void login({required Map<String, dynamic> creds}) async {
    emit(LoginLoadingState());

    // Post data and get token'

    Response response = await DioHelper.postData(
      url: '/sanctum/token',
      data: creds,
    );
    if (response.statusCode == 200) {
      // if provided credintials are right
      token = response.data.toString(); // This will get a token
      tryToken(token: token);
    } else {
      toastMessage(
          message: langCode == 'ar'
              ? 'البيانات المدخلة غير صحيحة'
              : 'Provided credentials are invalid',
          backgroundColor: Colors.red);
      emit(SaveTokenErrorState());
    }
  }

  UserModel? userModel;
  void tryToken({required String token}) async {
    if (token.isEmpty) {
      return;
    } else {
      emit(LoginLoadingState());

      DioHelper.setAuthToken(token);
      Response response = await DioHelper.getData(
        url: '/user',
      );

      if (response.statusCode == 200) {
        emit(LoginSuccessState(token));
      } else {
        toastMessage(
            message: langCode == 'ar'
                ? 'حدث خطأ غير متوقع، يرجى المحاولة لاحقًا'
                : 'Unexpected error. Please, try again later',
            backgroundColor: Colors.red);
        emit(LoginErrorState());
      }
    }
  }
}
