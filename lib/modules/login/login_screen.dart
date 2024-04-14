import 'package:call_me/layout/home.dart';
import 'package:call_me/modules/login/cubit/cubit.dart';
import 'package:call_me/modules/login/cubit/states.dart';
import 'package:call_me/modules/register/register_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = state.uId!;
            }).then((value) {
              navigateAndFinish(context, const HomeLayout());
            });
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            body: Form(
              key: formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // App Bar
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadiusDirectional.only(
                                  bottomEnd: Radius.circular(60.0)),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.orange,
                                    Colors.orangeAccent.withOpacity(0.7),
                                  ],
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter),
                            ),
                            width: double.infinity,
                            height: 300,
                          ),
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/images/user.png'),
                          ),
                          const Positioned(
                            bottom: 10,
                            right: 10,
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          children: [
                            //email field
                            defaultTextFormField(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                label: 'البريد الإلكتروني',
                                suffixIcon: Icons.email,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'حقل مطلوب';
                                  }
                                  return null;
                                }),
                            const SizedBox(
                              height: 15.0,
                            ),
                            //pass field
                            defaultTextFormField(
                                controller: passController,
                                isPassword: true,
                                type: TextInputType.text,
                                label: 'كلمة المرور',
                                suffixIcon: Icons.lock,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'حقل مطلوب';
                                  }
                                  return null;
                                }),
                            const SizedBox(
                              height: 20,
                            ),

                            ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (context) => // sign up button //
                                  defaultButton(
                                text: 'تسجيل دخول',
                                onPress: () {
                                  cubit.loginUser(
                                    email: emailController.text,
                                    password: passController.text,
                                  );
                                },
                              ),
                              fallback: (context) => JumpingDots(
                                color: Colors.orange,
                              ),
                            ),
                            // text button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                    onPressed: () {
                                      navigatTo(context, RegisterScreen());
                                    },
                                    icon: const Icon(
                                      Icons.verified_user_outlined,
                                      color: Colors.orange,
                                    ),
                                    label: const Text(
                                      'عضو جديد؟',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: Colors.black,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
