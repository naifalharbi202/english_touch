import 'package:call_me/generated/l10n.dart';
import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:call_me/shared/constants/constants.dart';
import 'package:call_me/shared/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark
                ? const Color.fromARGB(255, 15, 100, 91)
                : Colors.teal[500],
            leading: BackButton(
              onPressed: () {
                searchedCards.clear();
                cubit.changeBottomNaveIndex(0);
                Navigator.pop(context);
              },
              color: isDark
                  ? const Color.fromARGB(255, 147, 143, 143)
                  : const Color.fromARGB(255, 14, 12, 12),
            ),
            title: defaultTextFormField(
                onChange: (searchedWords) {
                  if (searchedWords.isEmpty) {
                    searchedCards.clear();
                    cubit.emptySearchedCards();
                  } else {
                    cubit.searchCards(searchedWords.toLowerCase());
                  }
                },
                isSearchField: true,
                controller: searchTextController,
                type: TextInputType.text,
                label: S.of(context).search,
                validate: (value) {
                  return null;
                }),
          ),
          body: ListView.separated(
              itemBuilder: (context, index) =>
                  defaultItem(searchedCards[index], context),
              separatorBuilder: (context, index) => SizedBox(
                    height: Dimensions.size(5, context),
                  ),
              itemCount: searchedCards.length),
        );
      },
    );
  }
}
