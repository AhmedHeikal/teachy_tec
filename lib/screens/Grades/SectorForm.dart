import 'package:flutter/cupertino.dart';
import 'package:teachy_tec/screens/Grades/SectorFormVM.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/InputTitle.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';

class SectorForm extends StatelessWidget {
  const SectorForm({
    required this.model,
    super.key,
  });
  final SectorFormVM model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedInputField(
          hintText: 'ex. Midterm'.capitalizeAllWord(),
          text: '',
          textInputAction: TextInputAction.next,
          onChanged: (input) {},
        ),
        const SizedBox(height: kBottomPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InputTitle(
                    title: 'Real Weight'.capitalizeAllWord(),
                  ),
                  const SizedBox(height: 2),
                  RoundedInputField(
                    hintText: 'ex. Primary Class'.capitalizeAllWord(),
                    text: '',
                    isEmptyValidation: true,
                    textInputAction: TextInputAction.next,
                    onChanged: (input) {},
                  ),
                ],
              ),
            ),
            const SizedBox(width: kHelpingPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InputTitle(
                    title: 'Percentage Weight'.capitalizeAllWord(),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RoundedInputField(
                          hintText: 'ex. Primary Class'.capitalizeAllWord(),
                          text: '',
                          isEmptyValidation: true,
                          textInputAction: TextInputAction.next,
                          onChanged: (input) {},
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          '%',
                          style: TextStyles.InterBlackS20W500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
