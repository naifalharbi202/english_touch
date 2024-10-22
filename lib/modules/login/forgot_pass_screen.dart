import 'package:call_me/generated/l10n.dart';
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
                            S.of(context).you_will_be_notified,
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
                                style: Theme.of(context).textTheme.bodyLarge,
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                label: S.of(context).email,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return S.of(context).required_field;
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
                                  text: S.of(context).reset,
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
