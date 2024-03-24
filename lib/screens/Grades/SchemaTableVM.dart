import 'package:flutter/material.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Schema.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

class SchemaTableVM extends ChangeNotifier {
  final Schema schema;
  final Class selectedClass;

  ScrollController rowsScrollController = ScrollController();
  ScrollController columnsScrollController = ScrollController();
  ScrollController mainAxisController = ScrollController();

  SchemaTableVM({required this.schema, required this.selectedClass}) {
    getStudentsInClass();
  }
  List<Student> students = [];

  Future getStudentsInClass() async {
    students = await serviceLocator<AppNetworkProvider>()
        .getStudentsInClass(classId: selectedClass.id!);

    notifyListeners();
  }
}

// TODO create a class for the cell types .. so taht we will obtain useful info from the schema and use it in the cells 

// class