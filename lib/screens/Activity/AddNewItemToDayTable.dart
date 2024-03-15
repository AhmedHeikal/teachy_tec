import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/AddNewItemToDayTableVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/TogglePagesButtons.dart';

class AddNewItemToDayTable extends StatefulWidget {
  const AddNewItemToDayTable({required this.model, super.key});
  final AddNewItemToDayTableVM model;
  @override
  State<AddNewItemToDayTable> createState() => _AddNewItemToDayTableState();
}

class _AddNewItemToDayTableState extends State<AddNewItemToDayTable> {
  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: const EdgeInsets.only(top: kMainPadding),
      child: Column(
        children: [
          TogglePagesButton(
              firstPage: widget.model.firstItemWidget,
              secondPage: widget.model.secongItemWidget,
              firstPageTitle: widget.model.firstPageName,
              secondPageTitle: widget.model.secondPageName,
              onChangePageCallback: widget.model.onChangePageCallback),
          // const SizedBox(height: kMainPadding),
          Container(
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(
                color: AppColors.grey400.withOpacity(0.15),
                width: 2,
              ),
            )),
            padding: const EdgeInsets.only(top: kInternalPadding),
            child: BottomPageButton(
              onTap: widget.model.onSubmitForm,
              // color: AppColors.black,
              addShadows: true,
              text: AppLocale.add.getString(context).capitalizeFirstLetter(),
            ),
          ),
          if (keyboardHeight > 0) SizedBox(height: keyboardHeight),
        ],
      ),
    );
  }
}
