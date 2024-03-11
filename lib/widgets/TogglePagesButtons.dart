import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';

class TogglePagesButton extends StatefulWidget {
  const TogglePagesButton({
    super.key,
    required this.firstPage,
    required this.secondPage,
    required this.firstPageTitle,
    required this.secondPageTitle,
    this.onChangePageCallback,
  });

  final String firstPageTitle;
  final Widget firstPage;
  final Widget secondPage;
  final String secondPageTitle;
  final void Function(String)? onChangePageCallback;

  @override
  State<TogglePagesButton> createState() => _TogglePagesButtonState();
}

class _TogglePagesButtonState extends State<TogglePagesButton> {
  bool isFirstPageChoosen = true;

  void toggleSelectedButton() {
    isFirstPageChoosen = !isFirstPageChoosen;
    if (widget.onChangePageCallback != null) {
      widget.onChangePageCallback!(
          isFirstPageChoosen ? widget.firstPageTitle : widget.secondPageTitle);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const Color activeButtonColor = AppColors.grey900;
    const Color inActiveButtonColor = Colors.transparent;
    const TextStyle activeTextColor = TextStyles.InterYellow700S16W500;
    const TextStyle inActiveTextColor = TextStyles.InterGrey900S16W500;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: InkWell(
                onTap: toggleSelectedButton,
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isFirstPageChoosen
                        ? activeButtonColor
                        : inActiveButtonColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      widget.firstPageTitle,
                      style: isFirstPageChoosen
                          ? activeTextColor
                          : inActiveTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: toggleSelectedButton,
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !isFirstPageChoosen
                        ? activeButtonColor
                        : inActiveButtonColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      widget.secondPageTitle,
                      // AppLocalizations.of(UIRouter.getCurrentContext())
                      //     .dislikes
                      //     .capitalizeFirstLetter(),
                      // 'Dislike',
                      style: !isFirstPageChoosen
                          ? activeTextColor
                          : inActiveTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: kMainPadding),
        Container(
            constraints: const BoxConstraints(maxHeight: 500),
            child: isFirstPageChoosen ? widget.firstPage : widget.secondPage),
      ],
    );
  }
}
