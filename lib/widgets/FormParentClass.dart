import 'package:flutter/material.dart';

mixin FormParentClass {
  final formKey = GlobalKey<FormState>();
  UnfocusDisposition disposition = UnfocusDisposition.scope;

  unFocusAllNodes() {
    primaryFocus!.unfocus(disposition: disposition);
  }

  bool validateForm() {
    final result = formKey.currentState?.validate();
    if (result == false) {
      return false;
    }
    formKey.currentState?.save();
    return true;
  }

  bool isFormValid() {
    final result = formKey.currentState?.validate();
    if (result == false) {
      return false;
    }
    formKey.currentState?.save();
    return true;
  }
}
