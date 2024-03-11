import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/AddSingleTaskFormVM.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';

class AddSingleTaskForm extends StatelessWidget {
  const AddSingleTaskForm({required this.model, super.key});
  final AddSingleTaskFormVM model;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: model.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputTitle(
              title:
                  AppLocale.taskTitle.getString(context).capitalizeAllWord()),
          const SizedBox(height: 2),
          RoundedInputField(
            hintText: AppLocale.taskDetails.getString(context).toLowerCase(),
            text: model.title,
            isEmptyValidation: true,
            textInputAction: TextInputAction.next,
            onChanged: (input) {
              model.title = input;
            },
          ),
        ],
      ),
    );
  }
}
