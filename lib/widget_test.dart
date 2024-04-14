import 'package:call_me/shared/dimentions.dart';
import 'package:flutter/material.dart';

class MyWidgetTest extends StatelessWidget {
  const MyWidgetTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: Card(
            color: const Color.fromARGB(255, 87, 173, 165),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //Source Icon
                  Icon(
                    Icons.school_outlined,
                    size: Dimensions.size(40, context),
                    color: const Color.fromARGB(255, 66, 71, 77),
                  ),
                  SizedBox(
                    width: Dimensions.size(10, context),
                  ),
                  //Sentence and keywords
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sentence
                        Text(
                          'This is a sentence that will be retrieved from firestore This is a sentence that will be retrieved from firestoreThis is a sentence that will be retrieved from firestoreThis is a sentence that will be retrieved from firestoreThis is a sentence that will be retrieved from firestore',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: Dimensions.size(17, context),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Dimensions.size(10, context),
                        ),
                        // Keywords
                        Container(
                          height: Dimensions.size(30, context),
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  const Text('Keyword'),
                              separatorBuilder: (context, index) =>
                                  const Text(','),
                              itemCount: 5),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Icon(
                      Icons.play_circle_filled_sharp,
                      size: Dimensions.size(30, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
