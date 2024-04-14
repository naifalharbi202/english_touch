import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).initVoices();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // AppCubit cubit = AppCubit.get(context);
        return ListView.separated(
            itemBuilder: (context, index) => defaultItem(cards[index], context),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
            itemCount: cards.length);
      },
    );
  }
}
