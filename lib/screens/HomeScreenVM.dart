import 'package:flutter/material.dart';

class HomeScreenVM extends ChangeNotifier {
  Future<void> getDataFromFireStore() async {
    // QuerySnapshot dailyMarkSnapshot =
    //     await databaseReference.collection('daily_mark').get();

    // var students = await databaseReference
    //     .collection('daily_mark')
    //     .doc('vDoHXWp7mqwn6qCAjOb0')
    //     .collection('v0zFPzN07pqMvA4DmJsx')
    //     .doc('7-1-2024')
    //     .get();
    // // var students = await databaseReference
    // //     .collection(FirestoreConstants.dailyMark)

    // //     .get();

    // //         // Get data from docs and convert map to List
    // // final allData = students.docs.map((doc) => doc.data()).toList();

    // // print(allData);

    // debugPrint('Heikal - students collections');
  }

  HomeScreenVM() {
    // getDataFromFireStore();
  }
}
