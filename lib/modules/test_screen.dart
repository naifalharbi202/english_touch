import 'package:call_me/layout/cubit/cubit.dart';
import 'package:call_me/layout/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return StreamBuilder<DocumentSnapshot>(
            stream: AppCubit.get(context).cardsDataStream,
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              // Ensure initial snapshot handling
              if (!snapshot.hasData) {
                return const Text('No data');
              }

              if (snapshot.data!.exists &&
                  (AppCubit.get(context).cachedData == null ||
                      snapshot.data!.data() !=
                          AppCubit.get(context).cachedData!.data())) {
                AppCubit.get(context).cachedData == snapshot.data;
              }

              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('data'),
                        Text('data'),
                        Text('data'),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}






// class _YourWidgetState extends State<YourWidget> {
//   late Stream<DocumentSnapshot> _userDataStream;
//   late DocumentSnapshot _cachedData;

//   @override
//   void initState() {
//     super.initState();

//     // Listen to changes in Firestore document
//     _userDataStream = FirebaseFirestore.instance.collection('users').doc(uId).snapshots;

//     // Cache the initial data
//     FirebaseFirestore.instance.collection('users').doc(uId).get().then((snapshot) {
//       setState(() {
//         _cachedData = snapshot;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: _userDataStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show loading indicator while fetching data
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // Handle error
//           return Text('Error: ${snapshot.error}');
//         } else {
//           // Check if data is updated in Firestore
//           if (snapshot.data!.exists && snapshot.data!.data() != _cachedData.data()) {
//             // Data has been updated, save new data and update cache
//             setState(() {
//               _cachedData = snapshot.data!;
//             });
//           }

//           // Render UI with cached data
//           return YourWidgetUI(data: _cachedData);
//         }
//       },
//     );
//   }
// }

// class YourWidgetUI extends StatelessWidget {
//   final DocumentSnapshot data;

//   YourWidgetUI({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     // Use cached data to render UI
//     // Example: access data using data['field']
//     return Container();
//   }
// }
