import 'package:call_me/layout/home.dart';
import 'package:call_me/modules/login/login_screen.dart';
import 'package:call_me/modules/register/cubit/cubit.dart';
import 'package:call_me/modules/register/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/local/cachehelper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
        if (state is CreateUserSuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uid).then((value) {
            uId = state.uid!;
          });
          navigateAndFinish(context, const HomeLayout());
        }
      }, builder: (context, state) {
        RegisterCubit cubit = RegisterCubit.get(context);
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
                          backgroundImage: AssetImage('assets/images/user.png'),
                        ),
                        const Positioned(
                          bottom: 10,
                          right: 10,
                          child: Text(
                            'تسجيل جديد',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          //name field
                          defaultTextFormField(
                              controller: nameController,
                              type: TextInputType.text,
                              label: 'أسم المستخدم',
                              suffixIcon: Icons.person,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'حقل مطلوب';
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 15.0,
                          ),

                          const SizedBox(
                            height: 15.0,
                          ),
                          //phone field
                          defaultTextFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              label: 'رقم الهاتف',
                              suffixIcon: Icons.call,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'حقل مطلوب';
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 15.0,
                          ),
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
                            height: 20.0,
                          ),
                          // sign up button //
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => defaultButton(
                              text: '  تسجيل',
                              onPress: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.registerUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passController.text,
                                    phone: phoneController.text,
                                  );
                                }
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
                                    navigatTo(context, LoginScreen());
                                  },
                                  icon: const Icon(
                                    Icons.verified_user_outlined,
                                    color: Colors.orange,
                                  ),
                                  label: const Text(
                                    'لديك عضوية؟',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Colors.black,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
