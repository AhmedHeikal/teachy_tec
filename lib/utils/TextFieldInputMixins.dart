// To validate Inputs Do it here ==>
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';

mixin InputValidationMixin {
  bool isFieldEmpty(String input) => input.checkEmpty;
  bool isPasswordCorrect(String input) => RegExp(r"^.{8,}$").hasMatch(input);

  bool isEmail(String input) => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(input);

  // bool isUSState(String input) =>
  //     USStates.getAllAbbreviations().firstWhereOrNull(
  //         (element) => element.toLowerCase() == input.toLowerCase()) ==
  //     null;

  bool isLargerThan(String input, int value) =>
      (int.tryParse(input) ?? 0) < value;
  bool isBetween(String input, int min, int max) =>
      input.isNotEmpty &&
      ((int.tryParse(input) ?? 0) < min || (int.tryParse(input) ?? min) > max);
}

// The Text formatting is done here =>
class NumericalRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;
  final String? suffixText;
  NumericalRangeFormatter({this.min = 0, required this.max, this.suffixText});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    newValue = const TextEditingValue().copyWith(
        text: newValue.text.replaceAll(',', '.'),
        selection: TextSelection.collapsed(offset: newValue.text.length));
    oldValue = const TextEditingValue().copyWith(
        text: oldValue.text.replaceAll(',', '.'),
        selection: TextSelection.collapsed(offset: oldValue.text.length));

    if (suffixText != null) {
      newValue = const TextEditingValue().copyWith(
          text: newValue.text.split(suffixText!)[0],
          selection: TextSelection.collapsed(offset: newValue.text.length));
      oldValue = const TextEditingValue().copyWith(
          text: oldValue.text.split(suffixText!)[0],
          selection: TextSelection.collapsed(offset: oldValue.text.length));
    }
    if (newValue.text == '') {
      return newValue;
    } else if (double.tryParse(newValue.text)! < min) {
      return suffixText == null
          ? const TextEditingValue().copyWith(
              text: min.toString(),
              selection: TextSelection.collapsed(offset: min.toString().length))
          : const TextEditingValue().copyWith(
              text: min.toString() + suffixText!,
              selection:
                  TextSelection.collapsed(offset: min.toString().length));
    } else {
      if (suffixText == null) {
        return (double.tryParse(newValue.text)! > max) ? oldValue : newValue;
      }
      if (int.parse(newValue.text) > max) {
        return const TextEditingValue().copyWith(
            text: oldValue.text + suffixText!,
            selection: TextSelection.collapsed(offset: oldValue.text.length));
      } else {
        return const TextEditingValue().copyWith(
            text: newValue.text + suffixText!,
            selection: TextSelection.collapsed(offset: newValue.text.length));
      }
    }
  }
}

class InsertEmptyCharacted extends TextInputFormatter {
  final VoidCallback requestLastFocus;
  InsertEmptyCharacted({required this.requestLastFocus});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text.length == 1 && newValue.text.isEmpty) {
      newValue = const TextEditingValue().copyWith(
          text: "\u200b", selection: const TextSelection.collapsed(offset: 1));

      requestLastFocus();
    }

    if (!newValue.text.contains("\u200b")) {
      newValue = const TextEditingValue().copyWith(
          text: "${newValue.text}\u200b",
          selection: TextSelection.collapsed(offset: newValue.text.length + 2));
    }
    return newValue;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;
      int dotValue = '.'.allMatches(value).length;
      int commaValue = ','.allMatches(value).length;
      if ((dotValue == 1 && commaValue == 1) ||
          (dotValue > 1) ||
          (commaValue > 1)) {
        truncated = oldValue.text;
        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      } else if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value.contains(",") &&
          value.substring(value.indexOf(",") + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";
        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      } else if (value == ",") {
        truncated = "0,";

        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
