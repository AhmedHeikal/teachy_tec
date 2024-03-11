import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:teachy_tec/models/ProductToBoycott.dart';

class MainScaffoldVM extends ChangeNotifier {
  BuildContext? currentContext;

  void setCurrentContext(BuildContext currentContext) {
    this.currentContext = currentContext;
  }

  late DatabaseReference _dbref;
  static const String spreadSheetId =
      '1lhOnFbzAlGYkZt39C2vhCmOnoJ6248Q72LdHIb6b4r0';

  _readDbOnce() {
    try {
      _dbref.child(spreadSheetId).child('Products').once().then((data) {
        // print("Heikal - readonce - $data");
        List<ProductToBoycott> productToBoycottData = [];
        try {
          productToBoycottData = (data.snapshot.value as List)
              .map((e) => ProductToBoycott.fromMap(e))
              .toList();
        } catch (e) {
          log(e.toString());
        }
        return productToBoycottData;
      });
    } catch (e) {
      debugPrint('Heikal - error thrown $e');
    }
  }

  MainScreenVM() {
    _dbref = FirebaseDatabase.instance.ref();
    _readDbOnce();
  }
}
