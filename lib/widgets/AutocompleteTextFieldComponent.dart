import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/models/AutoCompleteViewModel.dart';
import 'package:teachy_tec/models/IdNameViewModel.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/AppTextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';

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
    this.addNewIngredientCallBack,
    this.isOneTimeFetch = true,
    this.onFocusCallBack,
    this.addButtonIcon = true,
    Key? key,
  }) : super(key: key);

  Function(AutoCompleteViewModel) onSelectItem;
  VoidCallback? addNewIngredientCallBack;
  Function(double)? onFocusCallBack;
  IdNameViewModel? initialValue;
  List<AutoCompleteViewModel>? list;
  bool addButtonIcon;
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
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    texFieldKey = GlobalKey();
    if (widget.list == null) {
      setState(() {
        autoCompleteData = [];
      });
    } else {
      setState(() {
        autoCompleteData = widget.list!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      displayStringForOption: (AutoCompleteViewModel option) => option.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty ||
            textEditingValue.text.toLowerCase().contains('instance of')) {
          if (widget.list!.isEmpty && widget.addNewIngredientCallBack != null) {
            return [
              AutoCompleteViewModel(
                id: 0,
                name: '',
              )
            ];
          }

          return widget.list!.where(
            (word) =>
                word.name.trim().isNotEmpty &&
                word.name.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
          );
        } else {
          if (widget.list!.isEmpty && widget.addNewIngredientCallBack != null) {
            return [
              AutoCompleteViewModel(
                id: 0,
                name: '',
              )
            ];
          }

          return widget.list!.where(
            (word) => word.name.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
          );
        }
      },
      optionsViewBuilder: (context,
          void Function(AutoCompleteViewModel) onSelected,
          Iterable<AutoCompleteViewModel> options) {
        return Align(
          alignment: AlignmentDirectional.topCenter,
          child: DefaultContainer(
            constraints: const BoxConstraints(maxHeight: 280),
            addDefaultBoxShadow: true,
            // This margin because the Options are stacked on top of this widget
            // So it doen't follow the page's padding
            // And times three + 12 because the Autocomplete widget align its start with
            // the options left border, so we need to add all the padding to rhe right
            margin: const EdgeInsetsDirectional.only(
              end: kMainPadding * 3 + kBottomPadding,
              start: 4,
            ),
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: kBottomPadding,
                horizontal: kMainPadding,
              ),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final AutoCompleteViewModel option = options.elementAt(
                    index + (widget.addNewIngredientCallBack != null ? -1 : 0));
                return InkWell(
                  onTap: () {
                    onSelected(option);
                    widget.onSelectItem(option);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.name,
                              style: AppTextStyles.gray800S14W400,
                            ),
                            Container(height: 1),
                          ],
                        ),
                      ),
                      if (widget.addButtonIcon) ...[
                        const SizedBox(height: 4),
                        SvgPicture.asset(
                          'assets/svg/addButton.svg',
                          color: AppColors.grey400,
                        ),
                      ],
                    ],
                  ),
                );
              },
              separatorBuilder: (_, index) => Container(
                padding: const EdgeInsets.symmetric(vertical: kBottomPadding),
                child: Container(
                  height: 1,
                  color: AppColors.grey100,
                ),
              ),
              itemCount: options.length +
                  (widget.addNewIngredientCallBack != null &&
                          !(options.length == 1)
                      ? 1
                      : 0),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
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
          focusNode: focusNode,
          textInputAction: TextInputAction.next,
          // Todo Check this
          onChanged: (value) async {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {});
          },
        );
      },
    );
  }
}
