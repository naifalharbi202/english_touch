import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      if (state is SendPasswordResetSuccessState)
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              bottom: Dimensions.size(70, context)),
                          child: Text(
                            'ستصلك رسالة  عبر البريد الإلكتروني، في حال كان البريد الخاص بك مسجل في النظام',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            defaultTextFormField(
                                style: Theme.of(context).textTheme.bodyText1,
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                label: 'البريد الإلكتروني',
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'أدخل البريد الإلكتروني';
                                  }

                                  return null;
                                },
                                prefixIcon: Icons.email_outlined),
                            const SizedBox(
                              height: 15.0,
                            ),
                            ConditionalBuilder(
                              condition:
                                  state is! SendPasswordResetLoadingState,
                              builder: (context) => defaultButton(
                                  text: 'استعادة',
                                  onPress: () {
                                    if (formKey.currentState!.validate()) {
                                      AppCubit.get(context).forgetPassword(
                                          email: emailController.text.trim());
                                    }
                                  }),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
