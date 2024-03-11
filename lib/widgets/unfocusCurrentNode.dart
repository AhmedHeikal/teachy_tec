import 'package:flutter/material.dart';

void unfocusCurrentNode() {
  FocusManager.instance.primaryFocus?.unfocus();
  // UnfocusDisposition disposition = UnfocusDisposition.scope;
  // primaryFocus!.unfocus(disposition: disposition);
}
