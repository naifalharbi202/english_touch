﻿import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:call_me/modules/sentence/add_sentence_screen.dart';
import 'package:call_me/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              // App Bar
              appBar: defaultAppBar(title: 'المكتبة', context: context),

              // Floating Action Button
              floatingActionButton: FloatingActionButton.small(
                onPressed: () {
                  navigatTo(context, AddSentenceScreen());
                },
                backgroundColor: const Color.fromARGB(255, 14, 76, 87),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),

              // Bottom Nav Bar
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: BottomNavigationBar(
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeBottomNaveIndex(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.grey[195],
                  selectedItemColor: Colors.teal,
                  unselectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chrome_reader_mode_rounded),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: '',
                    ),
                  ],
                ),
              ),
              body: cubit.screens[cubit.currentIndex],
            ));
      },
    );
  }
}
