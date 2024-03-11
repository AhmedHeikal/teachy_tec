import 'package:flutter/material.dart';
import 'package:teachy_tec/utils/UIRouter.dart';


class PopScreenBackArrow extends StatelessWidget {
  const PopScreenBackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return const InkWell(
      onTap: UIRouter.popScreen,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 24,
        ),
      ),
    );
  }
}
