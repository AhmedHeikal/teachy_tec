import 'package:flutter/cupertino.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';

class NoteFormForCellInDayTableVM extends ChangeNotifier with FormParentClass {
  String? note;
  Task? oldModel;
  bool? isEditting;
  NoteFormForCellInDayTableVM.edit({
    this.oldModel,
  }) {
    note = oldModel?.comment;
    isEditting = false;
  }

  NoteFormForCellInDayTableVM() {
    isEditting = true;
  }

  void editNote() {
    isEditting = true;
    notifyListeners();
  }

  Future<void> addNote() async {
    if (!validateForm()) return;
    UIRouter.popScreen(argumentReturned: note);
  }
}
