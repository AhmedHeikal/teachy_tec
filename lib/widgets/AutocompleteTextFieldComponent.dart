import 'dart:async';
import 'package:flutter/material.dart';
import 'package:teachy_tec/models/AutoCompleteViewModel.dart';
import 'package:teachy_tec/models/IdNameViewModel.dart';
import 'package:teachy_tec/styles/AppColors.dart';
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
    this.isEmptyValidation = false,
    super.key,
  });

  bool isMultiSelectionSupported;
  bool isEmptyValidation;
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
      AutocompleteTextFieldComponentState();
}

class AutocompleteTextFieldComponentState
    extends State<AutocompleteTextFieldComponent> {
  bool onSubmitCalled() {
    if (widget.isEmptyValidation &&
        (widget.selectedItemsList?.isEmpty ?? false) &&
        focusNode != null) {
      focusNode!.requestFocus();
      return false;
    }
    return true;
  }

  FocusNode? focusNode;
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
    // if(focusNode?.)
    // focusNode?.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // widget.fetchAutoCompleteData().then((value) =>
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
    // debugPrint('Heikal - list length ${autoCompleteData.length}');
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete(
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
        optionsViewBuilder: (context,
            void Function(AutoCompleteViewModel) onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: DefaultContainer(
              border: Border.all(color: AppColors.grey300),
              width: constraints.maxWidth,
              // color: AppColors.black,
              constraints: const BoxConstraints(maxHeight: 280),
              addDefaultBoxShadow: true,
              // This margin because the Options are stacked on top of this widget
              // So it doen't follow the page's padding
              // And times three + 12 because the Autocomplete widget align its start with
              // the options left border, so we need to add all the padding to rhe right
              margin: const EdgeInsets.only(
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
                  final option = options.elementAt(
                      index /* + (widget.addNewIngredientCallBack != null ? -1 : 0) */);
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
                                style: TextStyles.InterGrey800S14W300,
                              ),
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
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, index) => Container(
                  padding: const EdgeInsets.symmetric(vertical: kBottomPadding),
                  child: HorizontalDottedLine(),
                ),
                itemCount: options.length,
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
          this.focusNode = focusNode;
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
      ),
    );
  }
}
