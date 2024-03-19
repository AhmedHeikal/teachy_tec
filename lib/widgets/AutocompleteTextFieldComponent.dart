import 'dart:async';
import 'package:flutter/material.dart';
import 'package:teachy_tec/models/AutoCompleteViewModel.dart';
import 'package:teachy_tec/models/IdNameViewModel.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/CustomCheckbox.dart';
import 'package:teachy_tec/widgets/HorizontalDottedLine.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

// ignore: must_be_immutable
class AutocompleteTextFieldComponent extends StatefulWidget {
  AutocompleteTextFieldComponent({
    this.list,
    required this.onSelectItem,
    this.initialValue,
    required this.textFieldLabel,
    this.fetchAutoCompleteData,
    this.selectAll,
    this.isOneTimeFetch = true,
    this.onFocusCallBack,
    this.isMultiSelectionSupported = false,
    this.selectedItemsList,
    Key? key,
  }) : super(key: key);

  bool isMultiSelectionSupported;
  Function(AutoCompleteViewModel) onSelectItem;
  VoidCallback? selectAll;
  Function(double)? onFocusCallBack;
  IdNameViewModel? initialValue;
  List<AutoCompleteViewModel>? list;
  List<AutoCompleteViewModel>? selectedItemsList;
  bool isOneTimeFetch;
  String textFieldLabel;
  Future<List<String>> Function()? fetchAutoCompleteData;

  @override
  State<AutocompleteTextFieldComponent> createState() =>
      _AutocompleteTextFieldComponentState();
}

class _AutocompleteTextFieldComponentState
    extends State<AutocompleteTextFieldComponent> {
  late GlobalKey texFieldKey;

  bool isLoading = false;
  late List<AutoCompleteViewModel> autoCompleteData;
  Timer? _debounce;
  late TextEditingController textEditingController;

  @override
  void didUpdateWidget(covariant AutocompleteTextFieldComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      oldWidget.list = widget.list;
    });
    // TODO: implement didUpdateWidget
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // widget.fetchAutoCompleteData().then((value) =>
    texFieldKey = GlobalKey();
    if (widget.list == null)
      setState(() {
        autoCompleteData = [];
      });
    else {
      setState(() {
        autoCompleteData = widget.list!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('Heikal - list length ${autoCompleteData.length}');
    return Autocomplete(
      displayStringForOption: (option) => option.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty ||
            textEditingValue.text.toLowerCase().contains('instance of')) {
          // if (widget.list!.length == 0 &&
          //     widget.addNewIngredientCallBack != null) {
          //   return [
          //     AutoCompleteViewModel(
          //       id: 0,
          //       name: '',
          //     )
          //   ];
          // }

          return widget.list!.where(
            (word) =>
                word.name.trim().isNotEmpty &&
                word.name.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
          );
        } else {
          // if (widget.list!.length == 0
          // &&
          //     widget.addNewIngredientCallBack != null) {
          //   return [
          //     AutoCompleteViewModel(
          //       id: 0,
          //       name: '',
          //     )
          //   ];
          // }

          return widget.list!.where(
            (word) => word.name.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
          );
        }
      },
      optionsViewBuilder:
          (context, void Function(AutoCompleteViewModel) onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: DefaultContainer(
            // color: AppColors.black,
            constraints: const BoxConstraints(maxHeight: 280),
            addDefaultBoxShadow: true,
            // This margin because the Options are stacked on top of this widget
            // So it doen't follow the page's padding
            // And times three + 12 because the Autocomplete widget align its start with
            // the options left border, so we need to add all the padding to rhe right
            margin: const EdgeInsets.only(
              right: kMainPadding * 2,
              top: 4,
            ),
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: kBottomPadding,
                horizontal: kMainPadding,
              ),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                // if (widget.addNewIngredientCallBack != null && index == 0) {
                //   return InkWell(
                //     onTap: widget.addNewIngredientCallBack,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         // SvgPicture.asset(
                //         //   'assets/vectors/PlusSVG.svg',
                //         //   color: TomatoColors.Green700,
                //         // ),
                //         // SizedBox(width: kHelpingPadding),
                //         Text(
                //           AppLocalizations.of(UIRouter.getCurrentContext())
                //               .openAllIngredients
                //               .capitalizeAllWord(),
                //           // 'Open All Ingredients',
                //           style: TomatoTextStyles.InterGreen700S16W600H20,
                //         )
                //       ],
                //     ),
                //   );
                // }
                // final option =
                //     options.elementAt(index - 1) as AutoCompleteViewModel;

                final option = options.elementAt(
                    index /* + (widget.addNewIngredientCallBack != null ? -1 : 0) */);
                return InkWell(
                  onTap: () {
                    onSelected(option);
                    widget.onSelectItem(option);
                  },
                  child: Row(
                    children: [
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(8),
                      //   child: MediaProvider(
                      //     model: option,
                      //     height: 40,
                      //     width: 40,
                      //     emptyImageAlternative: getEmptyImageAlternative(
                      //         option.autoCompleteType, option.goesGreatType),
                      //   ),
                      // ),
                      // SizedBox(width: kHelpingPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.name,
                              style: TextStyles.InterGrey800S14W300,
                            ),
                            // if (option.isAllergen ?? false)
                            //   Container(
                            //     padding: EdgeInsets.symmetric(
                            //       vertical: 2,
                            //       horizontal: 5,
                            //     ),
                            //     decoration: BoxDecoration(
                            //         color: TomatoColors.Red50,
                            //         borderRadius: BorderRadius.circular(12)),
                            //     child: Text(
                            //       AppLocalizations.of(
                            //               UIRouter.getCurrentContext())
                            //           .allergen
                            //           .toLowerCase(),
                            //       style: TomatoTextStyles.InterRed700S12W500H12,
                            //     ),
                            //   ),
                            // if (option.isDish ?? false)
                            //   Container(
                            //     padding: EdgeInsets.symmetric(
                            //       vertical: 2,
                            //       horizontal: 5,
                            //     ),
                            //     decoration: BoxDecoration(
                            //         color: TomatoColors.Blue50,
                            //         borderRadius: BorderRadius.circular(12)),
                            //     child: Text(
                            //       AppLocalizations.of(
                            //               UIRouter.getCurrentContext())
                            //           .dish
                            //           .toLowerCase(),
                            //       style:
                            //           TomatoTextStyles.InterIndigo700S12W500H12,
                            //     ),
                            //   ),
                            Container(
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomCheckBox(
                        isChecked: widget.selectedItemsList?.any(
                                (element) => element.name == option.name) ??
                            false,
                      )
                      // widget.selectedItemsList?.any(
                      //             (element) => element.name == option.name) ??
                      //         false
                      //     ? SvgPicture.asset(
                      //         "assets/svg/CheckedBox.svg",
                      //       )
                      //     : SvgPicture.asset('assets/svg/addButton.svg',
                      //         colorFilter: const ColorFilter.mode(
                      //           AppColors.grey400,
                      //           BlendMode.srcATop,
                      //         )),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, index) => Container(
                padding: const EdgeInsets.symmetric(vertical: kBottomPadding),
                child: HorizontalDottedLine(),
              ),
              itemCount: options.length,

              // +
              //     (widget.addNewIngredientCallBack != null &&
              //             !(options.length == 1 &&
              //                 (options.toList()[0] as AutoCompleteViewModel)
              //                         .autoCompleteType ==
              //                     AutoCompleteType.None)
              //         ? 1
              //         : 0),
            ),
          ),
        );
      },
      onSelected: (AutoCompleteViewModel selection) {
        textEditingController.text = "";
        if (!widget.isMultiSelectionSupported) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        textEditingController = controller;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.text = widget.initialValue?.name ?? "";
        });

        return RoundedInputField(
          hintText: widget.textFieldLabel,
          key: texFieldKey,
          controller: controller,
          onFocusCallBack: widget.onFocusCallBack != null
              ? () => widget.onFocusCallBack!(
                  MediaQuery.sizeOf(context).height -
                      texFieldKey.globalPaintBounds!.top)
              : null,
          // initialValue: widget.initialValue?.name,
          // isEmptyValidation: true,
          focusNode: focusNode,
          textInputAction: TextInputAction.next,
          // Todo Check this
          onChanged: (value) async {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              // widget.onSelectItem(value);
            });
          },
          // onFieldSubmitted: widget.onFieldSubmitted,
        );
      },
    );
  }
}

// Widget menuEmptyAlternative() => Container(
//       color: Colors.Green50,
//       width: 40,
//       height: 40,
//       padding: EdgeInsets.symmetric(horizontal: 6.5, vertical: 9),
//       child: SvgPicture.asset(
//         'assets/vectors/menuAlternative.svg',
//         color: TomatoColors.Green700,
//       ),
//     );

// Widget barEmptyAlternative() => Container(
//       color: TomatoColors.Green50,
//       width: 40,
//       height: 40,
//       padding: EdgeInsets.symmetric(horizontal: 6.5, vertical: 9),
//       child: SvgPicture.asset(
//         'assets/vectors/barAlternative.svg',
//         color: TomatoColors.Green700,
//       ),
//     );

// Widget policyEmptyAlternative() => Container(
//       color: TomatoColors.Green50,
//       width: 40,
//       height: 40,
//       padding: EdgeInsets.symmetric(horizontal: 6.5, vertical: 9),
//       child: SvgPicture.asset(
//         'assets/vectors/policyAlternative.svg',
//         color: TomatoColors.Green700,
//       ),
//     );

// Widget getEmptyImageAlternative(
//     AutoCompleteType type, MenuItemLiteTypeEnum? goesGreatWithType) {
//   switch (type) {
//     case AutoCompleteType.GoesGreatWith:
//       // if (goesGreatWithType == null) break;
//       if (goesGreatWithType == MenuItemLiteTypeEnum.Menu)
//         return menuEmptyAlternative();
//       else
//         return barEmptyAlternative();

//     // break;
//     case AutoCompleteType.IngredientViewModel:
//       return menuEmptyAlternative();

//     case AutoCompleteType.AdditionalIngredientViewModel:
//       return menuEmptyAlternative();
//     case AutoCompleteType.MenuItemViewModel:
//       return menuEmptyAlternative();
//     case AutoCompleteType.AlcoholicItemViewModel:
//       return barEmptyAlternative();
//     case AutoCompleteType.MenuItemLiteViewModel:
//       return menuEmptyAlternative();

//     case AutoCompleteType.WineItemLiteViewModel:
//       return menuEmptyAlternative();

//     case AutoCompleteType.AlcoholicItemIngredientViewModel:
//       return barEmptyAlternative();
//     case AutoCompleteType.MaterialLinkViewModel:
//     default:
//       return Container(
//         height: 40,
//         width: 40,
//         color: TomatoColors.Grey100,
//       );
//   }
// }
