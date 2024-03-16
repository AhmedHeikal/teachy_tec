import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

extension GetElementOrNull<T> on List<T> {
  T? elementAtOrNull(int index) {
    try {
      return elementAt(index);
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null,
          fatal: false,
          reason:
              "Heikal - elementAtOrNull in AppExtensions \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
      return null;
    }
  }
}

extension FileExtensionChecker on String {
  bool get isVideo => kVideoExtensions
      .any((extension) => this.toLowerCase().endsWith(extension));
}

extension MapWithIndex<T> on List<T> {
  List<R> mapWithIndex<R>(R Function(T, int i) callback) {
    List<R> result = [];
    for (int i = 0; i < this.length; i++) {
      R item = callback(this[i], i);
      result.add(item);
    }
    return result;
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object getCompareValue(T e)) {
    var result = <T>[];
    for (var element in this) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) {
        result.add(element);
      }
    }

    return result;
  }
}

extension ColorFromHex on Color {
  static Color fromHex(String hexCode) {
    if (hexCode.contains('#')) hexCode = hexCode.substring(1, hexCode.length);
    return Color(int.parse("0xFF$hexCode"));
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject() as RenderBox?;
    final matrix = renderObject?.getTransformTo(null);
    if (matrix != null && renderObject?.paintBounds != null) {
      final rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    } else {
      return null;
    }
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String capitalizeAllWord() {
    if (isEmpty) return "";
    var result = this[0].toUpperCase();
    for (int i = 1; i < length; i++) {
      if (this[i - 1] == " ") {
        result = result + this[i].toUpperCase();
      } else {
        result = result + this[i];
      }
    }
    return result;
  }
}

extension CheckEmpty on String {
  bool get checkEmpty => trim().isEmpty;
}
