import 'package:flutter/material.dart';
import 'package:teachy_tec/screens/Grades/GradesFormVM.dart';

class GradesSchemaPreviewComponentVM extends ChangeNotifier {
  GradesSchemaPreviewComponentVM({
    required this.gradesFormVM,
  });
  GradesFormVM gradesFormVM;
}
