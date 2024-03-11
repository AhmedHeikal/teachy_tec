import 'package:flutter/material.dart';
import 'package:teachy_tec/styles/TextStyles.dart';

Widget InputTitle({required String title}) => Text(
      title.toUpperCase(),
      style: TextStyles.InterGrey600S12W600,
    );
