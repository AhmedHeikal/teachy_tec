import 'package:flutter/material.dart';
import 'package:teachy_tec/styles/TextStyles.dart';

Widget InputTitle(
        {required String title,
        TextStyle style = TextStyles.InterGrey600S12W600}) =>
    Text(
      title.toUpperCase(),
      style: style,
    );
