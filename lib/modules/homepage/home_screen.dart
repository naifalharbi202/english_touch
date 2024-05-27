import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';

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
        // if (cards.isEmpty && state is! GetCardsLoadingState) {
        //   return Center(
        //       child: Text(
        //     'لا يوجد أي بطاقة تعليمية',
        //     style: Theme.of(context).textTheme.bodyLarge,
        //   ));
        // }
        return ListView.separated(
            itemBuilder: (context, index) => defaultItem(cards[index], context),
            separatorBuilder: (context, index) => SizedBox(
                  height: Dimensions.size(5, context),
                ),
            itemCount: cards.length);
      },
    );
  }
}
