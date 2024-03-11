import 'package:flutter/cupertino.dart';
import 'package:teachy_tec/widgets/FormParentClass.dart';

class AddSingleTaskFormVM extends ChangeNotifier with FormParentClass {
  String? title;
  String? onSubmitForm() {
    if (!validateForm()) {
      return null;
    } else {
      return title;
    }
  }
}
