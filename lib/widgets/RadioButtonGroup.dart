import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class RadioButtonGroup extends StatelessWidget {
  const RadioButtonGroup(
      {required this.values, required this.selection, super.key});
  final List<String> values;
  final String selection;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
        padding: const EdgeInsets.symmetric(
          vertical: kBottomPadding,
          horizontal: kMainPadding,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => radioButtonOption(
            () => Navigator.pop(context, values[index]),
            selection == values[index],
            values[index],
          ),
          separatorBuilder: (_, __) => Container(
            height: 1,
            width: double.infinity,
            color: AppColors.grey100,
          ),
          itemCount: values.length,
        ));
  }
}

Widget radioButtonOption(VoidCallback onTap, bool isSelected, String text) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: kHelpingPadding),
      child: Row(
        children: [
          SvgPicture.asset(
            isSelected
                ? 'assets/svg/activeRadioButton.svg'
                : 'assets/svg/inActiveRadioButton.svg',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12.5),
          Text(
            text,
            style: isSelected
                ? TextStyles.InterYellow700S16W600
                : TextStyles.InterGrey700S16W600,
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> showRadioGroupDialog(
    BuildContext context, List<String> values, String intialSelection) {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
            child: RadioButtonGroup(
              values: values,
              selection: intialSelection,
            ),
          ),
        );
      });
    },
  );
  // // debugPrint('Heikal 5555555 - $response');
}
