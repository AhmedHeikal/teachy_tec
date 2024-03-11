import 'package:flutter/material.dart';

class StudentPreviewInDashboardVM extends ChangeNotifier {
  StudentPreviewInDashboardVM({this.isDetailsShown = false});
  bool isDetailsShown;
  void togglePreviewDetails() {
    isDetailsShown = !isDetailsShown;
    notifyListeners();
  }
}
