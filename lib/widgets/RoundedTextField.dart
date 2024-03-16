import 'dart:math';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/TextFieldEnsureVisibleWhenFocused.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/CustomCheckbox.dart';
import 'package:teachy_tec/widgets/CustomizedDropdown.dart';
import 'package:teachy_tec/widgets/RadioButtonGroup.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';
import 'package:collection/collection.dart';

// ignore: must_be_immutable
class RadioButtonGroupRoundedInput extends StatefulWidget {
  RadioButtonGroupRoundedInput({
    required this.values,
    this.isFirstValueSelected = true,
    required this.focusNode,
    this.text,
    required this.callback,
    super.key,
  });
  bool isFirstValueSelected;
  final List<String> values;
  final FocusNode focusNode;
  final Function(String) callback;

  final String? text;

  @override
  State<RadioButtonGroupRoundedInput> createState() =>
      _RadioButtonGroupRoundedInputState();
}

class _RadioButtonGroupRoundedInputState
    extends State<RadioButtonGroupRoundedInput> {
  late String selectedValue;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.values.first;
    // selectedValue = widget.values.first;
    // Initialize the value in the parent model
    widget.callback(selectedValue);
  }

  @override
  void dispose() {
    super.dispose();
    // if (widget.focusNode != null)
    widget.focusNode.dispose();
  }

  void _onFocusChange(bool focus) {
    // debugPrint('Heikal - Checking Focus $focus');
    if (mounted) {
      setState(() {
        isActive = focus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Remove focus color
      focusColor: Colors.transparent,
      onTap: () async {
        widget.focusNode.requestFocus();
        var result =
            await showRadioGroupDialog(context, widget.values, selectedValue);
        // debugPrint('Heikal - Rounded InputCointainer $result');
        if (result != null) {
          setState(() {
            selectedValue = result;
            widget.isFirstValueSelected = true;
            widget.callback(result);
          });
        }
      },
      child: Focus(
        onFocusChange: _onFocusChange,
        focusNode: widget.focusNode,
        child: DefaultContainer(
            padding: const EdgeInsets.symmetric(
                horizontal: kHelpingPadding, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey200),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.white,
            ),
            // addDefaultBoxShadow: true,
            // boxShadow: KboxShadowsArray,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isFirstValueSelected ? selectedValue : widget.text!,
                  style: isActive
                      ? TextStyles.InterBlackS16W400
                      : widget.isFirstValueSelected
                          ? TextStyles.InterGrey700S16W400
                          : TextStyles.InterGrey300S16W400,
                ),
                SvgPicture.asset(
                  'assets/svg/ArrowDown.svg',
                  colorFilter: ColorFilter.mode(
                      isActive ? AppColors.primary700 : AppColors.grey300,
                      BlendMode.srcIn),
                ),
              ],
            )),
      ),
    );
  }
}

class CustomQuestionOptionTextField extends StatefulWidget {
  const CustomQuestionOptionTextField({
    super.key,
    this.isCheckbox = true,
    this.text,
    // this.onFocusCallBack,
    this.isReadOnly = false,
    this.initialOptionSate = false,
    required this.onTrueOptionToggleCallback,
    required this.onChanged,
  });

  final String? text;
  final bool isCheckbox;
  final bool isReadOnly;
  final ValueChanged<String> onChanged;
  final bool initialOptionSate;
  // final VoidCallback? onFocusCallBack;
  final Function(bool isSelected) onTrueOptionToggleCallback;
  @override
  State<CustomQuestionOptionTextField> createState() =>
      CustomQuestionOptionTextFieldState();
}

class CustomQuestionOptionTextFieldState
    extends State<CustomQuestionOptionTextField> with InputValidationMixin {
  bool isValid = true;
  bool isActive = false;
  late Function? validateFunction;
  late FocusNode focusNode;
  // Focus Node => Required because of the green current typing stats
  String? errorHintText;
  late bool isTrueOption;
  late TextEditingController _controller;

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        isActive = focusNode.hasFocus;
        // if (isActive) {
        //   if (widget.onFocusCallBack != null) widget.onFocusCallBack!();
        // }
      });
    }
  }

  validationFunctionPrototype(
      {required String input,
      required List<bool Function(String)> checkConditionFunctions}) {
    bool checkedCondition = false;
    // int index = 0;

    checkConditionFunctions.forEach((func) {
      // bool functionResult = func(input);
      if (func(input)) {
        checkedCondition = true;
      }
      // // debugPrint('Heikal - Validation $index $functionResult');
      // ++index;
    });

    if (checkedCondition) {
      // Try catch is required because the moment of transition; it rebuilds the widget
      // which means a dirty widget, but this widget is currently in use
      // Which cause an error => But I didn't find a way arround this

      if (isValid) {
        try {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // _ensureVisible();
              setState(() {
                isValid = false;
                if (!focusNode.hasFocus)
                  FocusScope.of(context).requestFocus(focusNode);
              });
            });
          }
          // Return Text Error If Required => It won't appear becasue error style set to 0
        } catch (error) {
          FirebaseCrashlytics.instance.recordError(e, null,
              fatal: false,
              reason:
                  "Heikal - getPreviewData in linkDetectionParser \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
        }
      }
      return '';
    } else if (!checkedCondition && !isValid) {
      try {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isValid = true;
            });
          });
        }
      } catch (error) {}
    }
  }

  @override
  void didUpdateWidget(covariant CustomQuestionOptionTextField oldWidget) {
    isTrueOption = widget.initialOptionSate;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    isTrueOption = widget.initialOptionSate;
    _controller = TextEditingController(text: widget.text);

    // If passed controller then the initial value must be null
    // if (widget.controller != null) {
    //   widget.text = null;
    //   _controller = widget.controller!;
    // } else {
    // _controller = TextEditingController(text: '');
    // }

    validateFunction = null;
    List<bool Function(String)> validationConditionsList = [];
    // Validation Function => For each kind of validation make the logic here
    focusNode.addListener(_onFocusChange);

    validationConditionsList.add((String input) {
      var check = isFieldEmpty(input);
      if (check &&
          errorHintText !=
              AppLocale.indicateYourAnswer
                  .getString(context)
                  .capitalizeFirstLetter()) {
        // 'Please fill in the empty field')
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              errorHintText = AppLocale.indicateYourAnswer
                  .getString(context)
                  .capitalizeFirstLetter();
              // 'Please fill in the empty field';
            });
          }
        });
      }

      return check;
    });

    // In case we need to add multiple validations in the same text field we will need
    // a list of condition functions =>
    if (validationConditionsList.isEmpty) {
      validateFunction = null;
    } else {
      validateFunction = (String input) => validationFunctionPrototype(
          input: input, checkConditionFunctions: validationConditionsList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: kHelpingPadding),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: isValid
                  ? Border.all(color: AppColors.grey200)
                  : Border.all(width: 0.5, color: AppColors.red500),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: Alignment.center,
              child: EnsureVisibleWhenFocused(
                focusNode: focusNode,
                child: TextFormField(
                  controller: _controller,
                  readOnly: widget.isReadOnly,
                  cursorColor: AppColors.primary700,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.sentences,
                  style:
                      //  style: widget.textStyle != null
                      //       ? isActive
                      //           ? widget.textStyle!.copyWith(color: AppColors.black)
                      //           : isValid
                      //               ? widget.textStyle
                      //               : widget.textStyle!
                      //                   .copyWith(color: AppColors.red700)
                      //       : (widget.isReadOnly ?? false)
                      //           ? TextStyles.InterGrey400S14W400
                      //           : isActive
                      //               ? TextStyles.InterBlackS14W400
                      //               : isValid
                      //                   ? TextStyles.InterGrey700S14W400
                      //                   : TextStyles.InterRed700S14W400,
                      widget.isReadOnly
                          ? TextStyles.InterGrey400S14W400
                          : isActive
                              ? TextStyles.InterBlackS14W400
                              : TextStyles.InterGrey700S14W400,
                  validator: validateFunction == null
                      ? null
                      : (input) => validateFunction!(input),
                  focusNode: focusNode,
                  onChanged: (value) {
                    widget.onChanged(value);
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    counterText: "",
                    errorStyle: const TextStyle(height: 0),
                    suffixIcon: InkWell(
                      onTap: widget.isReadOnly
                          ? null
                          : () {
                              widget.onChanged(_controller.text);
                              setState(() {
                                if (widget.isCheckbox) {
                                  isTrueOption = !isTrueOption;
                                } else {
                                  isTrueOption = true;
                                }
                                widget.onTrueOptionToggleCallback(isTrueOption);
                              });
                            },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: kBottomPadding),
                        child: widget.isCheckbox
                            ? CustomCheckBox(
                                isChecked: isTrueOption,
                              )
                            : SvgPicture.asset(
                                isTrueOption
                                    ? 'assets/svg/activeRadioButton.svg'
                                    : 'assets/svg/inActiveRadioButton.svg',
                                width: 24,
                                height: 24,
                              ),
                      ),
                    ),
                    suffixIconConstraints:
                        const BoxConstraints(maxWidth: 35, minWidth: 35),
                    hintStyle: TextStyles.InterGrey300S14W400,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            )
            // ),
            ),
        if (!isValid && errorHintText != null) ...[
          const SizedBox(height: 1),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/warning.svg',
                // color: TomatoColors.Red500,
                color: AppColors.grey400,
                height: 16,
              ),
              const SizedBox(width: 2),
              Text(
                errorHintText!,
                style: TextStyles.InterGrey400S12W400,
                // style: TomatoTextStyles.InterRed500S12W400H16,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

enum InputFieldTypeEnum {
  // Search,
  email,
  Password,
  USState,
  ClassField,
  Custom,
}

// ignore: must_be_immutable
class RoundedInputField extends StatefulWidget {
  String? hintText;
  String? text;
  // String? initialValue;
  double? height;
  Widget? prefixIcon;
  Widget? suffixIcon;
  TextInputType? inputType;
  bool? isObscure;
  late double borderRadius;
  Function? onFieldSubmitted;
  Function? onSaved;
  TextStyle? hintTextStyle;
  TextStyle? textStyle;
  // Keyboard Type
  TextInputAction? textInputAction;
  bool? isReadOnly;
  // First Type of validation ==> Any other validation =>
  bool addBorder;
  bool? isEmptyValidation;
  bool? isEmailValidation;
  int? max;
  // Are Only For numbers
  int? min;
  // To Add % or $ or other sufix after <Numbers Only>
  String? suffixTextForNumericalValues;
  TextEditingController? controller;
  int? validateLargerThan;
  FocusNode? focusNode;
  VoidCallback? onCancelSearchFunction;
  VoidCallback? onFocusCallBack;
  List<TextInputFormatter>? inputFormatters;
  TextCapitalization? textCapitalization;
  String? errorHintText;
  final ValueChanged<String> onChanged;
  List<String>? classesNames;

  /// It must take two values only, [nim, max]
  List<int>? validateBetween;

  late InputFieldTypeEnum inputFieldType;
  RoundedInputField({
    super.key,
    required this.hintText,
    this.hintTextStyle,
    this.addBorder = true,
    this.height = 44,
    this.onFocusCallBack,
    this.textStyle,
    this.isReadOnly = false,
    this.textInputAction,
    this.validateLargerThan,
    this.errorHintText,
    this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType = TextInputType.multiline,
    this.isObscure,
    this.textCapitalization,
    this.isEmptyValidation = false,
    this.isEmailValidation = false,
    this.suffixTextForNumericalValues,
    this.validateBetween,
    this.onFieldSubmitted,
    this.onSaved,
    this.max,
    this.min,
    this.focusNode,
    this.borderRadius = 8,
    this.inputFormatters,
    required this.onChanged,
    this.controller,
  }) {
    inputFieldType = InputFieldTypeEnum.Custom;
  }
// getClassesList
  RoundedInputField.classField({
    super.key,
    required this.hintText,
    required this.classesNames,
    this.hintTextStyle,
    this.addBorder = true,
    this.height = 44,
    this.onFocusCallBack,
    this.textStyle,
    this.isReadOnly = false,
    this.textInputAction,
    this.validateLargerThan,
    this.errorHintText,
    this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType = TextInputType.multiline,
    this.isObscure,
    this.textCapitalization,
    this.isEmptyValidation = false,
    this.isEmailValidation = false,
    this.suffixTextForNumericalValues,
    this.validateBetween,
    this.onFieldSubmitted,
    this.onSaved,
    this.max,
    this.min,
    this.focusNode,
    this.borderRadius = 8,
    this.inputFormatters,
    required this.onChanged,
    this.controller,
  }) {
    inputFieldType = InputFieldTypeEnum.ClassField;
  }

  RoundedInputField.password({
    super.key,
    this.height = 44,
    required this.onChanged,
    this.textInputAction,
    this.hintText = "",
    this.errorHintText,
    this.addBorder = true,
    this.text,
  }) {
    hintText = "";
    borderRadius = 8;
    isObscure = true;
    isReadOnly = false;
    textCapitalization = TextCapitalization.none;
    inputType = TextInputType.visiblePassword;
    inputFieldType = InputFieldTypeEnum.Password;
    inputFormatters = [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

  RoundedInputField.email({
    super.key,
    this.height = 44,
    required this.onChanged,
    this.textInputAction,
    this.hintText = "",
    this.errorHintText,
    this.addBorder = true,
    this.text,
    this.isEmailValidation = true,
    this.isEmptyValidation = true,
  }) {
    borderRadius = 8;
    isReadOnly = false;
    textCapitalization = TextCapitalization.none;
    inputType = TextInputType.emailAddress;
    inputFieldType = InputFieldTypeEnum.email;
    inputFormatters = [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
  }

  RoundedInputField.uSState({
    super.key,
    this.height = 44,
    required this.onChanged,
    this.textInputAction,
    this.hintText = "",
    this.addBorder = true,
    this.errorHintText,
    this.text,
  }) {
    borderRadius = 8;
    isEmptyValidation = true;
    inputFieldType = InputFieldTypeEnum.USState;
    inputFormatters = [
      MaskedInputFormatter(
        '##',
        allowedCharMatcher: RegExp(r'^[A-Za-z]+$'),
      ),
      UpperCaseTextFormatter(),
    ];
  }
  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField>
    with InputValidationMixin {
  bool isValid = true;
  bool isActive = false;
  late Function? validateFunction;
  late FocusNode focusNode;
  // Focus Node => Required because of the green current typing stats
  late bool isObscure;
  late TextEditingController _controller;
  String? errorHintText;

  void _onFocusChange() {
    if (mounted) {
      setState(
        () {
          isActive = focusNode.hasFocus;
          if (isActive) {
            if (widget.onFocusCallBack != null) widget.onFocusCallBack!();
          }
        },
      );
    }
  }

  validationFunctionPrototype(
      {required String input,
      required List<bool Function(String)> checkConditionFunctions}) {
    bool checkedCondition = false;

    for (var func in checkConditionFunctions) {
      if (func(input)) {
        checkedCondition = true;
      }
    }

    if (checkedCondition) {
      // Try catch is required because the moment of transition; it rebuilds the widget
      // which means a dirty widget, but this widget is currently in use
      // Which cause an error => But I didn't find a way arround this
      if (isValid) {
        try {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // _ensureVisible();
            if (mounted) {
              setState(() {
                isValid = false;
                if (!focusNode.hasFocus) {
                  FocusScope.of(context).requestFocus(focusNode);
                }
              });
            }
          });
          // Return Text Error If Required => It won't appear becasue error style set to 0
        } catch (error) {}
      }
      return '';
    } else if (!checkedCondition && !isValid) {
      try {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (mounted) {
              setState(
                () {
                  isValid = true;
                },
              );
            }
          },
        );
      } catch (error) {}
    }
  }

  @override
  void didUpdateWidget(covariant RoundedInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      _controller = TextEditingController(text: widget.text);
    }
  }

  @override
  void initState() {
    super.initState();

    focusNode = widget.focusNode ?? FocusNode();
    // If passed controller then the initial value must be null
    if (widget.controller != null) {
      widget.text = null;
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.text);
    }

    validateFunction = null;
    isObscure = widget.isObscure ?? false;
    List<bool Function(String)> validationConditionsList = [];
    focusNode.addListener(_onFocusChange);

    // if (widget.inputFieldType == InputFieldTypeEnum.USState) {
    //   validationConditionsList.add((String input) {
    //     var check = isUSState(input);
    //     if (check && errorHintText == null) {
    //       WidgetsBinding.instance.addPostFrameCallback((_) {
    //         if (mounted) {
    //           setState(() {
    //             errorHintText = AppLocale.pleaseEnteraValidStateAbbreviation
    //                 .getString(context)
    //                 .capitalizeFirstLetter();

    //             // 'Please enter a valid State Abbreviation';
    //           });
    //         }
    //       });
    //     }
    //     return check;
    //   });
    // }

    if (widget.isEmailValidation ?? false) {
      validationConditionsList.add((String input) {
        var check = !isEmail(input);
        if (check && errorHintText == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                errorHintText = AppLocale.emailFormatIsIncorrect
                    .getString(context)
                    .capitalizeFirstLetter();
                // 'Email format is incorrect';
              });
            }
          });
        }

        return check;
      });
    }

    if (widget.isEmptyValidation ?? false) {
      validationConditionsList.add((String input) {
        var check = isFieldEmpty(input);
        if (check && errorHintText == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                errorHintText = AppLocale.pleaseFillInTheEmptyField
                    .getString(context)
                    .capitalizeFirstLetter();

                // 'Please fill in the empty field';
              });
            }
          });
        }
        return check;
      });
    }

    if (widget.inputFieldType == InputFieldTypeEnum.Password) {
      validationConditionsList.add((String input) {
        var check = !isPasswordCorrect(input);
        if (check && errorHintText == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                errorHintText = AppLocale.passwordShouldBeAtLeast8Characters
                    .getString(context)
                    .capitalizeFirstLetter();

                // 'Password should be at least 8 characters';
              });
            }
          });
        }

        return check;
      });
    }

    if (widget.inputFieldType == InputFieldTypeEnum.ClassField) {
      validationConditionsList.add((String input) {
        var check = isClassNameExists(input, widget.classesNames ?? []);
        if (check && errorHintText == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                errorHintText = AppLocale.classNamesShouldBeUnique
                    .getString(context)
                    .capitalizeFirstLetter();
                // 'Password should be at least 8 characters';
              });
            }
          });
        }

        return check;
      });
    }

    if (widget.validateLargerThan != null) {
      validationConditionsList.add((String input) {
        var check = isLargerThan(input, widget.validateLargerThan!);
        if (check && errorHintText == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                errorHintText =
                    ("${AppLocale.numbersMustBeLagrerThan.getString(context)} ${widget.validateLargerThan}")
                        .capitalizeFirstLetter();
                // 'Numbers must be larger than ${widget.validateLargerThan}';
              });
            }
          });
        }

        return check;
      });
    }

    if (widget.validateBetween != null) {
      validationConditionsList.add((String input) {
        var check = isBetween(
            input, widget.validateBetween![0], widget.validateBetween![1]);
        if (check && errorHintText == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                errorHintText =
                    ("${AppLocale.numbersMustBeInaRangeBetween.getString(context)} ${widget.validateBetween![0]}-${widget.validateBetween![0]}")
                        .capitalizeFirstLetter();

                // 'Numbers must be in a range between ${widget.validateBetween![0]}-${widget.validateBetween![1]}';
              });
            }
          });
        }

        return isBetween(
            input, widget.validateBetween![0], widget.validateBetween![1]);
      });
    }

    // In case we need to add multiple validations in the same text field we will need
    // a list of condition functions =>
    if (validationConditionsList.isEmpty) {
      validateFunction = null;
    } else {
      validateFunction = (String input) => validationFunctionPrototype(
            input: input,
            checkConditionFunctions: validationConditionsList,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !focusNode.hasFocus
          ? () => FocusScope.of(context).requestFocus(focusNode)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              constraints: BoxConstraints(
                  minHeight: widget.height ?? 44,
                  maxHeight: widget.inputType == TextInputType.multiline
                      ? double.infinity
                      : widget.height ?? 44),
              padding: EdgeInsets.symmetric(
                horizontal: kHelpingPadding,
                vertical: widget.inputType == TextInputType.multiline
                    ? kHelpingPadding
                    : 0,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: isValid
                    ? Border.all(
                        color: widget.addBorder
                            ? AppColors.grey200
                            : Colors.transparent)
                    : Border.all(width: 0.8, color: AppColors.red500),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Align(
                alignment: Alignment.center,
                child: EnsureVisibleWhenFocused(
                  focusNode: focusNode,
                  child: TextFormField(
                    enabled: !(widget.isReadOnly ?? false),
                    controller: _controller,
                    maxLength: widget.inputType != TextInputType.number
                        ? widget.max
                        : null,
                    maxLines:
                        widget.inputType == TextInputType.multiline ? null : 1,

                    cursorColor: AppColors.primary700,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    keyboardType: widget.inputType,

                    textCapitalization: widget.textCapitalization ??
                        TextCapitalization.sentences,
                    // Add the required formatters here like the one in the end of the page
                    inputFormatters: widget.inputFormatters ??
                        (widget.inputType != null &&
                                widget.inputType == TextInputType.number
                            ?
                            // Integer Validation
                            [
                                FilteringTextInputFormatter.digitsOnly,
                                if (widget.max != null && widget.min != null)
                                  NumericalRangeFormatter(
                                      max: widget.max!,
                                      min: widget.min!,
                                      suffixText:
                                          widget.suffixTextForNumericalValues),
                              ]
                            :
                            // Decimal Validation
                            widget.inputType != null &&
                                    widget.inputType ==
                                        const TextInputType.numberWithOptions(
                                            decimal: true)
                                ?
                                // [DecimalTextInputFormatter(decimalRange: 2)]
                                [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(
                                        '^\$|^(0|([1-9][0-9]{0,}))([,.]{1}[0-9]{0,2})?\$',
                                      ),
                                    ),
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      try {
                                        var text = newValue.text;
                                        if (text.isEmpty) {
                                          if (oldValue.text.length == 1) {
                                            return newValue;
                                          }
                                          text = oldValue.text;
                                          double.tryParse(text);
                                          return oldValue;
                                        }
                                        double.tryParse(text);
                                        return newValue;
                                      } catch (e) {
                                        return oldValue;
                                      }
                                      // return oldValue;
                                    }),
                                    if (widget.max != null &&
                                        widget.min != null)
                                      NumericalRangeFormatter(
                                          max: widget.max!,
                                          min: widget.min!,
                                          suffixText: widget
                                              .suffixTextForNumericalValues),
                                  ]
                                : []),
                    style: widget.textStyle != null
                        ? isActive
                            ? widget.textStyle!.copyWith(color: AppColors.black)
                            : isValid
                                ? widget.textStyle
                                : widget.textStyle!
                                    .copyWith(color: AppColors.red700)
                        : (widget.isReadOnly ?? false)
                            ? TextStyles.InterGrey400S14W400
                            : isActive
                                ? TextStyles.InterBlackS14W400
                                : isValid
                                    ? TextStyles.InterGrey700S14W400
                                    : TextStyles.InterRed700S14W400,
                    // We specify the Validate function above and here assuring not null
                    validator: validateFunction == null
                        ? null
                        : (input) => validateFunction!(input),
                    focusNode: focusNode,
                    onSaved: widget.onSaved == null
                        ? null
                        : (input) => widget.onSaved!(input),
                    onFieldSubmitted: widget.onFieldSubmitted == null
                        ? null
                        : (input) => widget.onFieldSubmitted!(),
                    onChanged: (value) {
                      var output = '';
                      if (widget.inputType ==
                          const TextInputType.numberWithOptions(
                            decimal: true,
                          )) {
                        output = value.replaceAll(',', '.');
                      } else {
                        output = value;
                      }

                      widget.onChanged(output);
                    },
                    // textInputAction: widget.textInputAction,
                    textInputAction: TextInputAction.done,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      counterText: "",
                      errorStyle: const TextStyle(height: 0),
                      prefixIcon: widget.prefixIcon,
                      suffixIcon:
                          widget.inputFieldType == InputFieldTypeEnum.Password
                              ? InkWell(
                                  onTap: () => setState(() {
                                    isObscure = !isObscure;
                                  }),
                                  child: SvgPicture.asset(
                                    isObscure
                                        ? 'assets/svg/passwordHidden.svg'
                                        : 'assets/svg/passwordShown.svg',
                                  ),
                                )
                              : widget.suffixIcon,
                      prefixIconConstraints:
                          const BoxConstraints(maxWidth: 32, minWidth: 32),
                      suffixIconConstraints:
                          const BoxConstraints(maxWidth: 32, minWidth: 32),
                      hintText: widget.hintText,
                      hintStyle: widget.hintTextStyle ??
                          ((widget.isReadOnly ?? false)
                              ? TextStyles.InterGrey400S14W400
                              : TextStyles.InterGrey300S14W400),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              )
              // ),
              ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            reverseDuration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: !isValid &&
                    (widget.errorHintText != null || errorHintText != null)
                ? Column(
                    children: [
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/warning.svg',
                            // color: TomatoColors.Red500,
                            colorFilter: const ColorFilter.mode(
                                AppColors.grey400, BlendMode.srcIn),
                            height: 16,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              widget.errorHintText ?? errorHintText!,
                              style: TextStyles.InterGrey400S12W400,
                              // style: TomatoTextStyles.InterRed500S12W400H16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchTextField extends StatefulWidget {
  String? hintText;
  String? text;
  // String? initialValue;
  TextInputType? inputType;
  final ValueChanged<String> onChanged;
  Function? onFieldSubmitted;
  Function? onSaved;

  TextEditingController? controller;
  FocusNode? focusNode;
  VoidCallback? onCancelSearchFunction;
  VoidCallback? onFocusCallBack;
  bool isBorder;
  SearchTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onCancelSearchFunction,
    this.isBorder = true,
    this.controller,
    this.text,
  }) {
    inputType = TextInputType.text;
  }

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField>
    with InputValidationMixin {
  bool isActive = false;
  late FocusNode focusNode;
  late TextEditingController _controller;

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        isActive = focusNode.hasFocus;
        if (isActive) {
          if (widget.onFocusCallBack != null) widget.onFocusCallBack!();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    // If passed controller then the initial value must be null
    if (widget.controller != null) {
      widget.text = null;
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.text);
    }

    // Validation Function => For each kind of validation make the logic here
    focusNode.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 44,
        padding: const EdgeInsets.symmetric(
            horizontal: kHelpingPadding, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: widget.isBorder ? Border.all(color: AppColors.grey200) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.center,
          child: TextFormField(
            controller: _controller,
            cursorColor: AppColors.primary700,
            keyboardType: widget.inputType,
            textCapitalization: TextCapitalization.sentences,
            // Add the required formatters here like the one in the end of the page

            style: TextStyles.InterGrey700S16W400,

            focusNode: focusNode,
            onSaved: widget.onSaved == null
                ? null
                : (input) => widget.onSaved!(input),
            onFieldSubmitted: widget.onFieldSubmitted == null
                ? null
                : (input) => widget.onFieldSubmitted!(),
            onChanged: (value) {
              var output = '';
              if (widget.inputType ==
                  const TextInputType.numberWithOptions(decimal: true)) {
                output = value.replaceAll(',', '.');
              } else {
                output = value;
              }
              widget.onChanged(output);
            },
            decoration: InputDecoration(
              counterText: "",
              errorStyle: const TextStyle(height: 0),
              prefixIcon: SvgPicture.asset(
                "assets/svg/search.svg",
                height: 19,
              ),
              prefixIconConstraints:
                  const BoxConstraints(maxWidth: 32, minWidth: 32),
              suffixIconConstraints:
                  const BoxConstraints(maxWidth: 32, minWidth: 32),
              suffixIcon: _controller.text.trim().isNotEmpty
                  ? InkWell(
                      onTap: () => setState(() {
                        _controller.text = "";
                        widget.onChanged("");
                      }),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.grey300,
                        size: 22,
                      ),
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: TextStyles.InterGrey400S16W400,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.symmetric(horizontal: -15),
            ),
            // prefixIcon:
          ),
        )
        // ),
        // if (!isValid)
        //   Text(
        //     'Please fill the title field',
        //     style: TomatoTextStyles.InterGrey300S12W400H16,
        //   ),
        // ],
        );
  }
}

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    this.labelStyle = TextStyles.InterGrey400S12W600,
    this.isEmptyValidation = false,
    this.initialPhoneNumber,
    required this.onChanged,
  });
  final bool isEmptyValidation;
  final ValueChanged<String> onChanged;
  final String? initialPhoneNumber;
  final TextStyle labelStyle;
  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField>
    with InputValidationMixin {
  PhoneCountryData? _initialCountryData;
  bool countryIsValid = true;
  bool phoneNumberIsValid = true;
  late FocusNode phoneNumberFocusNode;
  late FocusNode countryFocusNode;
  late TextEditingController countryCodeTextFieldController;
  // late TextEditingController phoneNumberCodeTextFieldController;
  bool countryIsActive = false;
  bool phoneNumberIsActive = false;

  late Function? phoneNumberValidateFunction;
  late Function? countryValidateFunction;
  countryValidationFunctionPrototype(
      {required String input,
      required List<bool Function(String)> checkConditionFunctions}) {
    bool checkedCondition = false;
    // int index = 0;
    for (var func in checkConditionFunctions) {
      // bool functionResult = func(input);
      if (func(input)) {
        checkedCondition = true;
      }
      // // debugPrint('Heikal - Validation $index $functionResult');
      // ++index;
    }

    if (checkedCondition) {
      // Try catch is required because the moment of transition; it rebuilds the widget
      // which means a dirty widget, but this widget is currently in use
      // Which cause an error => But I didn't find a way arround this
      if (countryIsValid) {
        try {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                countryIsValid = false;
                phoneNumberIsValid = false;
              });
            });
          }
          // Return Text Error If Required => It won't appear becasue error style set to 0
        } catch (error) {}
      }
      return '';
    } else if (!checkedCondition && !countryIsValid) {
      try {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              countryIsValid = true;
            });
          });
        }
      } catch (error) {}
    }
  }

  phoneNumberValidationFunctionPrototype(
      {required String input,
      required List<bool Function(String)> checkConditionFunctions}) {
    bool checkedCondition = false;
    // int index = 0;

    for (var func in checkConditionFunctions) {
      // bool functionResult = func(input);
      if (func(input)) {
        checkedCondition = true;
      }
      // debugPrint('Heikal - Validation $index $functionResult');
      // ++index;
    }

    if (checkedCondition) {
      // Try catch is required because the moment of transition; it rebuilds the widget
      // which means a dirty widget, but this widget is currently in use
      // Which cause an error => But I didn't find a way arround this
      if (phoneNumberIsValid) {
        try {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                phoneNumberIsValid = false;
              });
            });
          }
          // Return Text Error If Required => It won't appear becasue error style set to 0
        } catch (error) {}
      }
      return '';
    } else if (!checkedCondition && !phoneNumberIsValid) {
      try {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              phoneNumberIsValid = true;
            });
          });
        }
      } catch (error) {}
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        phoneNumberIsActive = phoneNumberFocusNode.hasFocus;
        countryIsActive = countryFocusNode.hasFocus;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // if (widget.focusNode != null)
    countryCodeTextFieldController = TextEditingController();
    // phoneNumberCodeTextFieldController = TextEditingController();
    phoneNumberFocusNode = FocusNode();
    countryFocusNode = FocusNode();

    // focusNode = widget.focusNode ?? FocusNode();
    phoneNumberFocusNode.addListener(_onFocusChange);
    List<bool Function(String)> phoneNumberValidationConditionsList = [];
    List<bool Function(String)> countryValidationConditionsList = [];

    if (widget.isEmptyValidation) {
      phoneNumberValidationConditionsList.add((String input) => isFieldEmpty(
            input,
          ));
      countryValidationConditionsList.add((input) => isFieldEmpty(
            input,
          ));
    }

    phoneNumberValidationConditionsList.add((String input) {
      bool value = isPhoneValid(
        '${countryCodeTextFieldController.text} $input',
      );
      return !value;
    });

    countryValidationConditionsList.add((input) =>
        PhoneCodes.getAllCountryDatas().firstWhereOrNull((element) =>
            element.phoneCode == input.replaceAll(RegExp(r'[^0-9]'), '')) ==
        null);

    phoneNumberValidateFunction =
        (String input) => phoneNumberValidationFunctionPrototype(
              input: input,
              checkConditionFunctions: phoneNumberValidationConditionsList,
            );

    countryValidateFunction =
        (String input) => countryValidationFunctionPrototype(
              input: input,
              checkConditionFunctions: countryValidationConditionsList,
            );

    if (widget.initialPhoneNumber != null &&
        widget.initialPhoneNumber!.trim().isNotEmpty) {
      var phoneNumber = formatAsPhoneNumber(widget.initialPhoneNumber!
              .trim()
              .replaceAll(RegExp(r'[^0-9]'), '')) ??
          '';
      if (phoneNumber.isNotEmpty) {
        int index = phoneNumber.indexOf(" ");

        countryCodeTextFieldController.text =
            widget.initialPhoneNumber!.substring(0, index);

        currentPhoneNumber = phoneNumber.substring(index + 1);

        _initialCountryData = PhoneCodes.getAllCountryDatas().firstWhereOrNull(
            (element) =>
                element.phoneCode ==
                countryCodeTextFieldController.text.substring(1));
      }
    } else {
      // else
      _initialCountryData = PhoneCodes.getAllCountryDatas().first;
    }
    //  else if (serviceLocator.isRegistered<SignInViewModel>() &&
    //     serviceLocator<SignInViewModel>().phoneNumber != null) {
    //   var phoneNumber = formatAsPhoneNumber(serviceLocator<SignInViewModel>()
    //           .phoneNumber!
    //           .trim()
    //           .replaceAll(new RegExp(r'[^0-9]'), '')) ??
    //       '';
    //   if (phoneNumber.length > 0) {
    //     int index = phoneNumber.indexOf(" ");

    //     countryCodeTextFieldController.text =
    //         serviceLocator<SignInViewModel>().phoneNumber!.substring(0, index);

    //     currentPhoneNumber = phoneNumber.substring(index + 1);

    //     _initialCountryData = PhoneCodes.getAllCountryDatas().firstWhereOrNull(
    //         (element) =>
    //             element.phoneCode ==
    //             countryCodeTextFieldController.text.substring(1));
    //   }
    //   currentPhoneNumber = "";
    // }

    // else {
    //   countryCodeTextFieldController.text = "";
    //   currentPhoneNumber = "";
    //   // serviceLocator.registerSingleton<AppLanguage>(
    //   if (serviceLocator.isRegistered<AppLanguage>()) {
    //     if (serviceLocator<AppLanguage>().appLocal.countryCode == 'ar') {
    //       _initialCountryData = PhoneCodes.getAllCountryDatas()
    //               .firstWhereOrNull((element) =>
    //                   element.country?.toLowerCase() ==
    //                   'Egypt'.toLowerCase()) ??
    //           PhoneCodes.getAllCountryDatas().first;
    //     } else if (serviceLocator<AppLanguage>().appLocal.countryCode == 'es') {
    //       _initialCountryData = PhoneCodes.getAllCountryDatas()
    //               .firstWhereOrNull((element) =>
    //                   element.country?.toLowerCase() ==
    //                   'Spain'.toLowerCase()) ??
    //           PhoneCodes.getAllCountryDatas().first;
    //     } else if (serviceLocator<AppLanguage>().appLocal.countryCode == 'uk') {
    //       _initialCountryData = PhoneCodes.getAllCountryDatas()
    //               .firstWhereOrNull((element) =>
    //                   element.country?.toLowerCase() ==
    //                   'Ukraine'.toLowerCase()) ??
    //           PhoneCodes.getAllCountryDatas().first;
    //     } else if (serviceLocator<AppLanguage>().appLocal.countryCode == 'ru') {
    //       _initialCountryData = PhoneCodes.getAllCountryDatas()
    //               .firstWhereOrNull((element) =>
    //                   element.country?.toLowerCase() ==
    //                   'Russia'.toLowerCase()) ??
    //           PhoneCodes.getAllCountryDatas().first;
    //     } else {
    //       _initialCountryData = PhoneCodes.getAllCountryDatas()
    //               .firstWhereOrNull((element) =>
    //                   element.country?.toLowerCase() ==
    //                   'United States'.toLowerCase()) ??
    //           PhoneCodes.getAllCountryDatas().first;
    //     }
    //   } else
    //     // else
    //     _initialCountryData = PhoneCodes.getAllCountryDatas().first;
    // }
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumberFocusNode.dispose();
    countryFocusNode.dispose();
  }

  String currentPhoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.country.getString(context).toUpperCase(),
                  // 'COUNTRY',
                  style: widget.labelStyle,
                ),
                const SizedBox(height: 2),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    //  countryIsValid
                    //     ? TomatoColors.White
                    //     : TomatoColors.Red50,
                    border: countryIsValid
                        ? Border.all(color: AppColors.grey200)
                        : Border.all(width: 0.5, color: AppColors.red500),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: CountryPhoneCodesDropDown(
                          chosenCountryCode: _initialCountryData,
                          onChange: (countryData) {
                            if (mounted) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  if (_initialCountryData != null &&
                                      _initialCountryData!.countryCode !=
                                          countryData.countryCode) {
                                    currentPhoneNumber = "";
                                  }
                                  _initialCountryData = countryData;
                                  countryCodeTextFieldController.text =
                                      '+${countryData.phoneCode!}';
                                });
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: EnsureVisibleWhenFocused(
                          focusNode: countryFocusNode,
                          child: TextFormField(
                            focusNode: countryFocusNode,
                            controller: countryCodeTextFieldController,
                            maxLength: 5,
                            onChanged: (value) async {
                              var extracteNumbers =
                                  value.replaceAll(RegExp(r'[^0-9]'), '');

                              var country = PhoneCodes.getAllCountryDatas()
                                  .firstWhereOrNull((element) =>
                                      element.phoneCode == extracteNumbers);
                              if (country != null) {
                                if (mounted) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      if (_initialCountryData != null &&
                                          _initialCountryData!.countryCode !=
                                              country.countryCode) {
                                        currentPhoneNumber = "";
                                      }
                                      _initialCountryData = country;
                                      countryCodeTextFieldController.text =
                                          '+${country.phoneCode!}';
                                    });
                                  });
                                }
                                await Future.delayed(
                                    const Duration(milliseconds: 50));
                                if (!phoneNumberFocusNode.hasFocus) {
                                  // ignore: use_build_context_synchronously
                                  FocusScope.of(context)
                                      .requestFocus(phoneNumberFocusNode);
                                }
                              }
                              widget.onChanged(
                                  '${countryCodeTextFieldController.text} $currentPhoneNumber');
                            },
                            cursorColor: AppColors.primary700,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.phone,
                            validator: countryValidateFunction == null
                                ? null
                                : (input) => countryValidateFunction!(input),
                            style: countryIsActive
                                ? TextStyles.InterBlackS14W400
                                : countryIsValid
                                    ? TextStyles.InterGrey700S14W400
                                    : TextStyles.InterRed700S14W400,
                            decoration: const InputDecoration(
                              counterText: "",
                              errorStyle: TextStyle(height: 0),
                              prefixIconConstraints:
                                  BoxConstraints(maxWidth: 32, minWidth: 32),
                              suffixIconConstraints:
                                  BoxConstraints(maxWidth: 32, minWidth: 32),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: kHelpingPadding),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: kHelpingPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocale.phoneNumber.getString(context).toUpperCase(),
                    // 'PHONE NUMBER',
                    style: widget.labelStyle,
                  ),
                  const SizedBox(height: 2),
                  Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(
                        horizontal: kHelpingPadding,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,

                        // color: phoneNumberIsValid
                        //     ? TomatoColors.White
                        //     : TomatoColors.Red50,
                        border: phoneNumberIsValid
                            ? Border.all(color: AppColors.grey200)
                            : Border.all(width: 0.5, color: AppColors.red500),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: EnsureVisibleWhenFocused(
                          focusNode: phoneNumberFocusNode,
                          child: TextFormField(
                            initialValue: currentPhoneNumber,
                            focusNode: phoneNumberFocusNode,
                            // controller: phoneNumberCodeTextFieldController,
                            onChanged: (value) {
                              currentPhoneNumber = value;
                              widget.onChanged(
                                  '${countryCodeTextFieldController.text} $value');
                            },
                            key: ValueKey(_initialCountryData?.country ??
                                AppLocale.country
                                    .getString(context)
                                    .toLowerCase() /* 'country' */),
                            cursorColor: AppColors.primary700,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: phoneNumberValidateFunction == null
                                ? null
                                : (input) =>
                                    phoneNumberValidateFunction!(input),
                            inputFormatters: [
                              PhoneInputFormatter(
                                allowEndlessPhone: false,
                                defaultCountryCode:
                                    _initialCountryData?.countryCode,
                              )
                            ],
                            style: phoneNumberIsActive
                                ? TextStyles.InterBlackS14W400
                                : phoneNumberIsValid
                                    ? TextStyles.InterGrey700S14W400
                                    : TextStyles.InterRed700S14W400,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              counterText: "",
                              errorStyle: const TextStyle(height: 0),
                              prefixIconConstraints: const BoxConstraints(
                                  maxWidth: 32, minWidth: 32),
                              suffixIconConstraints: const BoxConstraints(
                                  maxWidth: 32, minWidth: 32),
                              hintText: _initialCountryData
                                  ?.phoneMaskWithoutCountryCode,
                              hintStyle: TextStyles.InterGrey400S14W400,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
        if (!countryIsValid || !phoneNumberIsValid) ...[
          const SizedBox(height: 1),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/warning.svg',
                // color: TomatoColors.Red500,
                colorFilter:
                    const ColorFilter.mode(AppColors.grey400, BlendMode.srcIn),

                height: 16,
              ),
              const SizedBox(width: 2),
              Text(
                AppLocale.phoneNumberFormatIsIncorrect
                    .getString(context)
                    .capitalizeFirstLetter(),
                // 'Phone number format is incorrect',
                // style: TomatoTextStyles.InterRed500S12W400H16,
                style: TextStyles.InterGrey400S12W400,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// // ignore: must_be_immutable
// class ChatTextfield extends StatelessWidget {
//   ChatTextfield(
//       {required this.changeTypingState,
//       this.onFinishedDetection,
//       this.onDetectionTyped,
//       required this.onChanged,
//       required this.controller,
//       super.key});
//   Function(bool) changeTypingState;
//   Function(String)? onDetectionTyped;
//   VoidCallback? onFinishedDetection;
//   final ValueChanged<String> onChanged;
//   final TextEditingController controller;

//   // bool isTyping = false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(left: 16 + 8, right: 6 + 8, top: 8, bottom: 8),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DetectableTextField(
//         scrollPhysics: ClampingScrollPhysics(),
//         controller: controller,
//         textInputAction: TextInputAction.newline,
//         cursorColor: AppColors.primary700,
//         detectionRegExp: detectionRegExp()!,
//         decoratedStyle: TextStyles.InterBlue700S14W400,
//         basicStyle: TextStyles.InterBlackS14W400,
//         onDetectionTyped: (value) => onDetectionTyped,
//         onDetectionFinished: onFinishedDetection,
//         maxLines: 5,
//         minLines: 1,
//         keyboardType: TextInputType.multiline,
//         onChanged: (value) {
//           onChanged(value);
//           if (value.trim().isEmpty) {
//             // if (isTyping) {
//             //   isTyping = false;
//             //   changeTypingState(false);
//             // }
//             changeTypingState(false);
//           } else
//             changeTypingState(true);

//           // if (!isTyping) {
//           //   isTyping = true;
//           //   changeTypingState(true);
//           // }
//         },
//         decoration: InputDecoration(
//           // contentPadding: EdgeInsets.only(top: kMainPadding),
//           // suffixIcon: Padding(
//           //   padding: EdgeInsets.all(kHelpingPadding),
//           //   child: InkWell(
//           //     onTap: () {},
//           //     child: SvgPicture.asset(
//           //       'assets/vectors/stickers.svg',
//           //     ),
//           //   ),
//           // ),
//           errorStyle: TextStyle(height: 0),
//           hintText:
//               AppLocalizations.of(context).typeHere.capitalizeFirstLetter(),
//           //  'Type here',
//           hintStyle: TomatoTextStyles.InterGrey400S14W400,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class CommentTextfield extends StatefulWidget {
//   CommentTextfield({
//     Key? key,
//     this.focusNode,
//     this.startWithFocus = true,
//     // required this.onChanged,
//     required this.onSendPressed,
//     required this.controller,
//   }) : super(key: key);

//   bool startWithFocus;
//   FocusNode? focusNode;
//   TextEditingController controller;
//   // final ValueChanged<String> onChanged;
//   final VoidCallback onSendPressed;
//   @override
//   State<CommentTextfield> createState() => _CommentTextfieldState();
// }

// class _CommentTextfieldState extends State<CommentTextfield> {
//   bool isTyping = false;
//   late FocusNode focusNode;
//   double _inputHeight = 40;

//   @override
//   void initState() {
//     super.initState();
//     focusNode = widget.focusNode ?? FocusNode();
//     if (widget.startWithFocus) focusNode.requestFocus();
//     widget.controller.addListener(_checkInputHeight);
//   }

//   void _checkInputHeight() async {
//     int count = widget.controller.text.split('\n').length;

//     if (count == 0 && _inputHeight == 40.0) {
//       return;
//     }
//     if (count <= 2) {
//       var newHeight = count == 0 ? 40.0 : 26.0 + (count * 14.0);
//       setState(() {
//         _inputHeight = newHeight;
//       });
//     }
//   }

//   void submitTextField() {
//     if (widget.controller.text.trim().isNotEmpty) {
//       widget.onSendPressed();
//       widget.controller.text = '';
//       if (mounted)
//         setState(() {
//           isTyping = false;
//         });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: serviceLocator<AppLanguage>().isTextDirectionLTR
//           ? EdgeInsets.only(left: 16, right: 6)
//           : EdgeInsets.only(left: 6, right: 16),
//       height: _inputHeight,
//       decoration: BoxDecoration(
//         color: TomatoColors.White,
//         borderRadius: BorderRadius.circular(50),
//         border: Border.all(color: TomatoColors.Grey300),
//         // boxShadow: KboxShadowsArray,
//       ),
//       child: TextFormField(
//         focusNode: focusNode,
//         cursorColor: TomatoColors.Green700,
//         controller: widget.controller,
//         style: TomatoTextStyles.InterBlackS14W400,
//         textInputAction: TextInputAction.newline,

//         // minLines: 1,
//         maxLines: 2,
//         keyboardType: TextInputType.multiline,
//         onChanged: (value) {
//           if (value.trim().isEmpty) {
//             if (isTyping) {
//               if (mounted)
//                 setState(() {
//                   isTyping = false;
//                 });
//             }
//           } else if (!isTyping) {
//             if (mounted)
//               setState(() {
//                 isTyping = true;
//               });
//           }
//         },
//         // onFieldSubmitted: (value) => submitTextField(),

//         decoration: InputDecoration(
//           suffixIcon: Container(
//             // margin: EdgeInsets.all(kHelpingPadding),
//             child: InkWell(
//               onTap: submitTextField,
//               child: SizedBox(
//                 height: 40,
//                 width: 40,
//                 child: Center(
//                   child: SvgPicture.asset(
//                     'assets/vectors/send.svg',
//                     color: isTyping ? null : TomatoColors.Grey400,
//                     height: 24,
//                     width: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           errorStyle: TextStyle(height: 0),
//           hintText:
//               AppLocalizations.of(context).addComment.capitalizeFirstLetter(),
//           hintStyle: TomatoTextStyles.InterGrey400S14W400.copyWith(
//             fontStyle: FontStyle.italic,
//           ),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
class RoundedMultilineInputField extends StatefulWidget {
  final String hintText;
  final String? text;
  final double height;
  final double? maxHeight;
  final int? maxLines;
  final ValueChanged<String> onChanged;
  final double borderRadius;
  final Function? onFieldSubmitted;
  final Function? onSaved;
  final TextInputAction? textInputAction;
  final bool isEmptyValidation;
  FocusNode? focusNode;
  TextCapitalization? textCapitalization;
  bool addBorder;

  String? errorHintText;
  RoundedMultilineInputField({
    super.key,
    required this.hintText,
    this.focusNode,
    this.text,
    this.borderRadius = 8,
    this.height = 150,
    this.addBorder = true,
    this.textCapitalization,
    this.maxHeight,
    this.isEmptyValidation = false,
    this.maxLines,
    this.onFieldSubmitted,
    this.onSaved,
    this.textInputAction,
    this.errorHintText,
    required this.onChanged,
  });

  @override
  State<RoundedMultilineInputField> createState() =>
      _RoundedMultilineInputFieldState();
}

class _RoundedMultilineInputFieldState extends State<RoundedMultilineInputField>
    with InputValidationMixin {
  bool isValid = true;
  bool isActive = false;
  late Function? validateFunction;
  late FocusNode focusNode;
  String? errorHintText;
  void _onFocusChange() {
    if (mounted) {
      setState(() {
        isActive = focusNode.hasFocus;
      });
    }
  }

  @override
  void didUpdateWidget(covariant RoundedMultilineInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      _controller = TextEditingController(text: widget.text);
    }
  }

  // @override
  // void didUpdateWidget(covariant RoundedInputField oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   if (widget.text != oldWidget.text) {
  //     _controller = TextEditingController(text: widget.text);
  //   }
  // }

  late TextEditingController _controller;

  // if (widget.text != oldWidget.text) {
  //   _controller = TextEditingController(text: widget.text);
  // }

  validationFunctionPrototype(
      {required String input,
      required List<bool Function(String)> checkConditionFunctions}) {
    bool checkedCondition = false;
    // int index = 0;

    for (var func in checkConditionFunctions) {
      // bool functionResult = func(input);
      if (func(input)) {
        checkedCondition = true;
      }
      // // debugPrint('Heikal - Validation $index $functionResult');
      // ++index;
    }

    if (checkedCondition) {
      // Try catch is required because the moment of transition; it rebuilds the widget
      // which means a dirty widget, but this widget is currently in use
      // Which cause an error => But I didn't find a way arround this
      if (isValid) {
        try {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isValid = false;
              });
            });
          }
          // Return Text Error If Required => It won't appear becasue error style set to 0
        } catch (error) {}
      }
      return '';
    } else if (!checkedCondition && !isValid) {
      try {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isValid = true;
            });
          });
        }
      } catch (error) {}
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    // if (widget.focusNode != null)
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(_onFocusChange);
    List<bool Function(String)> validationConditionsList = [];
    // If passed controller then the initial value must be null

    _controller = TextEditingController(text: widget.text);

    if (widget.isEmptyValidation) {
      validationConditionsList.add((String input) {
        var check = isFieldEmpty(input);
        if (check && errorHintText == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                errorHintText = AppLocale.pleaseFillInTheEmptyField
                    .getString(context)
                    .capitalizeFirstLetter();
                // 'Please fill in the empty field';
              });
            }
          });
        }
        return check;
      });

      // validationConditionsList.add((String input) => isFieldEmpty(
      //       input,
      //     ));
    }

    // In case we need to add multiple validations in the same text field we will need
    // a list of condition functions =>
    if (validationConditionsList.isEmpty) {
      validateFunction = null;
    } else {
      validateFunction = (String input) => validationFunctionPrototype(
          input: input, checkConditionFunctions: validationConditionsList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: kHelpingPadding, vertical: 10),
          constraints: BoxConstraints(
              minHeight: widget.height,
              maxHeight: widget.maxHeight ?? double.infinity),
          // height: widget.height,
          decoration: BoxDecoration(
            // color: isValid ? TomatoColors.White : TomatoColors.Red50,
            color: AppColors.white,
            // border: Border.all(color: Colors.grey),
            border: isValid
                ? Border.all(
                    color: widget.addBorder
                        ? AppColors.grey200
                        : Colors.transparent)
                : Border.all(width: 0.5, color: AppColors.red500),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: EnsureVisibleWhenFocused(
            focusNode: focusNode,
            child: TextFormField(
              scrollPhysics: const ClampingScrollPhysics(),
              // initialValue: widget.text,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.sentences,

              cursorColor: AppColors.primary700,
              // textInputAction: TextInputAction.done,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // validator: validator == null ? null : (value) => validator!(value),
              style: isActive
                  ? TextStyles.InterBlackS14W400
                  : isValid
                      ? TextStyles.InterGrey700S14W400
                      : TextStyles.InterRed700S14W400,
              validator: validateFunction == null
                  ? null
                  : (input) => validateFunction!(input),
              controller: _controller,
              focusNode: focusNode,
              onSaved: widget.onSaved == null
                  ? null
                  : (input) => widget.onSaved!(input),
              onFieldSubmitted: widget.onFieldSubmitted == null
                  ? null
                  : (input) => widget.onFieldSubmitted!(input),
              // minLines: widget.minLines,
              maxLines: null,
              // maxLines: widget.minLines > widget.minLines
              //     ? widget.minLines
              //     : widget.maxLines,
              keyboardType: TextInputType.multiline,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyles.InterGrey300S14W400,
                  hintMaxLines: 3,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero),
            ),
          ),
        ),
        if (!isValid &&
            (widget.errorHintText != null || errorHintText != null)) ...[
          const SizedBox(height: 1),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/warning.svg',
                // color: TomatoColors.Red500,
                colorFilter:
                    const ColorFilter.mode(AppColors.grey400, BlendMode.srcIn),
                height: 16,
              ),
              const SizedBox(
                width: 2,
              ),
              Expanded(
                child: Text(
                  widget.errorHintText ?? errorHintText!,
                  style: TextStyles.InterGrey400S12W400,
                  // style: TomatoTextStyles.InterRed500S12W400H16,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// // ignore: must_be_immutable
// class SubstepsRoundedMultilineInputField extends StatefulWidget {
//   final String hintText;
//   final String? text;
//   final double height;
//   final double? maxHeight;
//   final int? maxLines;
//   final ValueChanged<String> onChanged;
//   final double borderRadius;
//   final Function? onFieldSubmitted;
//   final Function? onSaved;
//   final TextInputAction? textInputAction;
//   final bool isEmptyValidation;
//   FocusNode? focusNode;
//   TextCapitalization? textCapitalization;
//   List<SubStepViewModel>? initialList;
//   // Function(List<SubStepViewModel>) submitsubsteps;

//   SubstepsRoundedMultilineInputField({
//     Key? key,
//     required this.hintText,
//     this.focusNode,
//     this.text,
//     this.borderRadius = 8,
//     this.initialList,
//     // required this.submitsubsteps,
//     this.height = 150,
//     this.textCapitalization,
//     this.maxHeight,
//     this.isEmptyValidation = false,
//     this.maxLines,
//     this.onFieldSubmitted,
//     this.onSaved,
//     this.textInputAction,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   State<SubstepsRoundedMultilineInputField> createState() =>
//       SubstepsRoundedMultilineInputFieldState();
// }

// class SubstepsRoundedMultilineInputFieldState
//     extends State<SubstepsRoundedMultilineInputField>
//     with InputValidationMixin {
//   bool isValid = true;
//   bool isActive = false;
//   late GlobalKey reorderableWidgetKey;
//   late Function? validateFunction;
//   late FocusNode focusNode;
//   late ValueNotifier<List<SubStepViewModel>> substeps;
//   TextEditingController controller = TextEditingController();
//   List<FocusNode> focusNodeList = [];
//   late ValueNotifier<bool> showDescriptionPlaceHolder;
//   List<TextEditingController> textEditingControllerList = [];
//   String initialText = '';

//   List<SubStepViewModel> submitSubsteps() {
//     substeps.value.removeWhere((element) =>
//         ((element.description) ?? '').replaceAll('\u200b', '').trim().isEmpty);

//     return substeps.value;
//   }

//   validationFunctionPrototype(
//       {required String input,
//       required List<bool Function(String)> checkConditionFunctions}) {
//     bool checkedCondition = false;
//     // int index = 0;

//     checkConditionFunctions.forEach((func) {
//       // bool functionResult = func(input);
//       if (func(input)) {
//         checkedCondition = true;
//       }
//       // // debugPrint('Heikal - Validation $index $functionResult');
//       // ++index;
//     });

//     if (checkedCondition) {
//       // Try catch is required because the moment of transition; it rebuilds the widget
//       // which means a dirty widget, but this widget is currently in use
//       // Which cause an error => But I didn't find a way arround this
//       if (isValid) {
//         try {
//           if (mounted)
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               setState(() {
//                 isValid = false;
//               });
//             });
//           // Return Text Error If Required => It won't appear becasue error style set to 0
//         } catch (error) {}
//       }
//       return '';
//     } else if (!checkedCondition && !isValid) {
//       try {
//         if (mounted)
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             setState(() {
//               isValid = true;
//             });
//           });
//       } catch (error) {}
//     }
//   }

//   void _onFocusChange() {
//     if (mounted)
//       setState(() {
//         isActive = focusNode.hasFocus;
//       });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     focusNode.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // if (widget.focusNode != null)
//     if (widget.text == null || widget.text!.isEmpty)
//       showDescriptionPlaceHolder = ValueNotifier(true);
//     else
//       showDescriptionPlaceHolder = ValueNotifier(false);
//     focusNode = widget.focusNode ?? FocusNode();
//     focusNode.addListener(_onFocusChange);
//     reorderableWidgetKey = GlobalKey();
//     controller.text +=
//         widget.text != null ? ("\u200b" + widget.text!) : "\u200b";

//     List<bool Function(String)> validationConditionsList = [];
//     substeps = ValueNotifier(widget.initialList ?? []);
//     substeps.value.forEach((element) {
//       FocusNode focusNode = FocusNode();

//       TextEditingController controller =
//           TextEditingController(text: '\u200b' + (element.description ?? ''));
//       focusNodeList.add(focusNode);
//       textEditingControllerList.add(controller);
//     });

//     if (widget.isEmptyValidation) {
//       validationConditionsList.add((String input) => isFieldEmpty(
//             input,
//           ));
//     }

//     // In case we need to add multiple validations in the same text field we will need
//     // a list of condition functions =>
//     if (validationConditionsList.length == 0)
//       validateFunction = null;
//     else
//       validateFunction = (String input) => validationFunctionPrototype(
//           input: input, checkConditionFunctions: validationConditionsList);

//     // showDescriptionPlacehoderFn();

//     controller.addListener(() {
//       showDescriptionPlacehoderFn();
//     });
//   }

//   void showDescriptionPlacehoderFn() {
//     var isShown = false;
//     if (widget.hintText.trim().isNotEmpty &&
//         (controller.text == "\u200b" || controller.text.isEmpty) &&
//         substeps.value.isEmpty) isShown = true;

//     if (showDescriptionPlaceHolder.value == isShown)
//       return;
//     else
//       showDescriptionPlaceHolder.value = isShown;
//   }

//   void _handleReorder(
//     int oldIndex,
//     int newIndex,
//   ) async {
//     if (oldIndex < newIndex) {
//       newIndex -= 1;
//     }

//     final item = substeps.value.removeAt(oldIndex);
//     final currentFocus = focusNodeList.removeAt(oldIndex);
//     final currentController = textEditingControllerList.removeAt(oldIndex);

//     substeps.value.insert(newIndex, item);
//     focusNodeList.insert(newIndex, currentFocus);
//     textEditingControllerList.insert(newIndex, currentController);

//     for (int i = 0; i < substeps.value.length; i++) {
//       substeps.value[i].index = i;
//     }

//     setState(() {});
//   }

//   void addNewStep() {
//     if (substeps.value.any((element) => ((element.description) ?? '')
//         .replaceAll('\u200b', '')
//         .trim()
//         .isEmpty)) {
//       var indexOfEmptySubstep = substeps.value.indexWhere((element) =>
//           ((element.description) ?? '')
//               .replaceAll('\u200b', '')
//               .trim()
//               .isEmpty);
//       focusNodeList[indexOfEmptySubstep].requestFocus();
//       return;
//     }

//     FocusNode focusNode = FocusNode();

//     TextEditingController controller = TextEditingController(text: '\u200b');
//     focusNodeList.add(focusNode);
//     textEditingControllerList.add(controller);
//     substeps.value.add(SubStepViewModel(
//         /* id: */ null, null, /* descritption: */ '', substeps.value.length));
//     // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//     substeps.notifyListeners();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> getListItems() {
//       return substeps.value
//           .asMap()
//           .map((index, item) => MapEntry(
//                 index,
//                 SubStepForm(
//                   key: ValueKey(index),
//                   model: item,
//                   focusNode: focusNodeList.elementAt(index),
//                   controller: textEditingControllerList.elementAt(index),
//                   addNewSubStep: addNewStep,
//                   onDelete: () {
//                     textEditingControllerList.removeAt(index);
//                     focusNodeList.removeAt(index);
//                     substeps.value.removeAt(index);

//                     debugPrint(
//                       'Heikal - index of empty identation after deleting step ${controller.text.indexOf("\u200b")}',
//                     );

//                     debugPrint(
//                       'Heikal - index of empty identation size ${controller.text.length}',
//                     );

//                     if (controller.text.indexOf("\u200b") == -1) {
//                       controller.text = controller.text + "\u200b";
//                     }

//                     // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
//                     substeps.notifyListeners();

//                     if (focusNodeList.isEmpty)
//                       focusNode.requestFocus();
//                     else
//                       focusNodeList.last.requestFocus();
//                   },
//                 ),
//               ))
//           .values
//           .toList();
//     }

//     return InkWell(
//       onTap: () => focusNode.requestFocus(),
//       child: Container(
//         // padding: EdgeInsets.symmetric(
//         //     horizontal: kHelpingPadding, vertical: kHelpingPadding),

//         // decoration: BoxDecoration(
//         //   color: TomatoColors.White,
//         //   border: isValid
//         //       ? Border.all(color: TomatoColors.Grey200)
//         //       : Border.all(width: 0.5, color: TomatoColors.Red500),
//         //   borderRadius: BorderRadius.circular(widget.borderRadius),
//         // ),
//         child: Column(
//           children: [
//             // InkWell(
//             //   onTap: addNewStep,
//             //   child: Container(
//             //     padding: const EdgeInsets.all(kInternalPadding),
//             //     margin: const EdgeInsets.only(bottom: kHelpingPadding),
//             //     decoration: BoxDecoration(
//             //       borderRadius: BorderRadius.circular(4),
//             //       color: TomatoColors.Green50,
//             //     ),
//             //     child: Row(
//             //       children: [
//             //         SvgPicture.asset(
//             //           'assets/vectors/plus.svg',
//             //           width: 14,
//             //           height: 14,
//             //           color: TomatoColors.Green700,
//             //         ),
//             //         SizedBox(width: 2),
//             //         Text(
//             //           AppLocalizations.of(context)
//             //               .addSubstep
//             //               .capitalizeAllWord(),
//             //           // 'Add substep',
//             //           style: TomatoTextStyles.InterGreen700S12W600H16,
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             ValueListenableBuilder<List<SubStepViewModel>>(
//               valueListenable: substeps,
//               builder: (context, substepsData, child) => ReorderableListView(
//                   key: reorderableWidgetKey,
//                   physics: ClampingScrollPhysics(),
//                   shrinkWrap: true,
//                   onReorder: _handleReorder,
//                   onReorderStart: (index) {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                   },
//                   // itemCount: substepsData.length,
//                   children: getListItems()
//                   // itemBuilder: (context, index) {
//                   //   var item = substepsData[index];
//                   //   return
//                   // },
//                   ),
//               //     ReorderableListView.builder(
//               //   key: reorderableWidgetKey,
//               //   physics: ClampingScrollPhysics(),
//               //   shrinkWrap: true,
//               //   onReorder: _handleReorder,
//               //   itemCount: substepsData.length,
//               //   itemBuilder: (context, index) {
//               //     var item = substepsData[index];
//               //     return SubStepForm(
//               //       key: ValueKey(item.index),
//               //       model: item,
//               //       focusNode: focusNodeList.elementAt(index),
//               //       controller: textEditingControllerList.elementAt(index),
//               //       addNewSubStep: addNewStep,
//               //       onDelete: () {
//               //         textEditingControllerList.removeAt(index);
//               //         focusNodeList.removeAt(index);
//               //         substeps.value.removeAt(index);

//               //         debugPrint(
//               //           'Heikal - index of empty identation after deleting step ${controller.text.indexOf("\u200b")}',
//               //         );

//               //         debugPrint(
//               //           'Heikal - index of empty identation size ${controller.text.length}',
//               //         );

//               //         if (controller.text.indexOf("\u200b") == -1) {
//               //           controller.text = controller.text + "\u200b";
//               //         }

//               //         substeps.notifyListeners();

//               //         if (focusNodeList.isEmpty)
//               //           focusNode.requestFocus();
//               //         else
//               //           focusNodeList.last.requestFocus();
//               //       },
//               //     );
//               //   },
//               // ),
//             ),

//             /* Positioned.fill(
//               child:  */
//             Container(
//               constraints: BoxConstraints(
//                 minHeight: widget.height,
//                 maxHeight: widget.maxHeight ?? double.infinity,
//               ),
//               child: Stack(
//                 children: [
//                   EnsureVisibleWhenFocused(
//                     focusNode: focusNode,
//                     child: TextFormField(
//                       // initialValue: initialText,
//                       controller: controller,
//                       inputFormatters: [
//                         InsertEmptyCharacted(
//                           requestLastFocus: () {
//                             if (focusNodeList.length > 0) {
//                               var isRequestCompleted = FocusManager
//                                   .instance.primaryFocus
//                                   ?.previousFocus();
//                               if (isRequestCompleted != true) {
//                                 focusNodeList.last.requestFocus();
//                               }
//                             }
//                           },
//                         )
//                       ],
//                       textCapitalization: widget.textCapitalization ??
//                           TextCapitalization.sentences,
//                       cursorColor: TomatoColors.Green700,
//                       // textInputAction: TextInputAction.done,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       // validator: validator == null ? null : (value) => validator!(value),
//                       style: isActive
//                           ? TomatoTextStyles.InterBlackS14W400
//                           : isValid
//                               ? TomatoTextStyles.InterGrey700S14W400
//                               : TomatoTextStyles.InterRed700S14W400,
//                       validator: validateFunction == null
//                           ? null
//                           : (input) => validateFunction!(input),
//                       focusNode: focusNode,
//                       onSaved: widget.onSaved == null
//                           ? null
//                           : (input) => widget.onSaved!(input),
//                       onFieldSubmitted: widget.onFieldSubmitted == null
//                           ? null
//                           : (input) => widget.onFieldSubmitted!(input),
//                       maxLines: null,
//                       keyboardType: TextInputType.multiline,
//                       onChanged: widget.onChanged,
//                       decoration: InputDecoration(
//                           hintText: widget.hintText,
//                           hintStyle: TomatoTextStyles.InterGrey300S14W400,
//                           hintMaxLines: 3,
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.zero),
//                     ),
//                     // ),
//                   ),
//                   if (widget.hintText.trim().isNotEmpty &&
//                       (controller.text == "\u200b" || controller.text.isEmpty))
//                     ValueListenableBuilder<bool>(
//                       valueListenable: showDescriptionPlaceHolder,
//                       builder: (context, showDescriptionPlaceHolder, child) =>
//                           !showDescriptionPlaceHolder
//                               ? Container()
//                               : Text(
//                                   widget.hintText,
//                                   style: TomatoTextStyles.InterGrey300S14W400,
//                                 ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// To validate Inputs Do it here ==>
mixin InputValidationMixin {
  bool isFieldEmpty(String input) => input.checkEmpty;
  bool isPasswordCorrect(String input) => RegExp(r"^.{8,}$").hasMatch(input);
  bool isClassNameExists(String input, List<String> stringList) {
    return stringList
        .map((e) => e.trim().toLowerCase())
        .contains(input.trim().toLowerCase());

    // String pattern = stringList
    //     .map((str) => RegExp.escape(str.trim().toLowerCase()))
    //     .join('|');
    // return RegExp(pattern).hasMatch(input.trim().toLowerCase());
  }

  // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
  bool isEmail(String input) => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')

      // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(input);

  // bool isUSState(String input) =>
  //     USStates.getAllAbbreviations().firstWhereOrNull(
  //         (element) => element.toLowerCase() == input.toLowerCase()) ==
  //     null;

  bool isLargerThan(String input, int value) =>
      (int.tryParse(input) ?? 0) < value;
  bool isBetween(String input, int min, int max) =>
      input.isNotEmpty &&
      ((int.tryParse(input) ?? 0) < min || (int.tryParse(input) ?? min) > max);
}

// The Text formatting is done here =>
class NumericalRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;
  final String? suffixText;
  NumericalRangeFormatter({this.min = 0, required this.max, this.suffixText});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    newValue = const TextEditingValue().copyWith(
        text: newValue.text.replaceAll(',', '.'),
        selection: TextSelection.collapsed(offset: newValue.text.length));
    oldValue = const TextEditingValue().copyWith(
        text: oldValue.text.replaceAll(',', '.'),
        selection: TextSelection.collapsed(offset: oldValue.text.length));

    if (suffixText != null) {
      newValue = const TextEditingValue().copyWith(
          text: newValue.text.split(suffixText!)[0],
          selection: TextSelection.collapsed(offset: newValue.text.length));
      oldValue = const TextEditingValue().copyWith(
          text: oldValue.text.split(suffixText!)[0],
          selection: TextSelection.collapsed(offset: oldValue.text.length));
    }
    if (newValue.text == '') {
      return newValue;
    } else if (double.tryParse(newValue.text)! < min) {
      return suffixText == null
          ? const TextEditingValue().copyWith(
              text: min.toString(),
              selection: TextSelection.collapsed(offset: min.toString().length))
          : const TextEditingValue().copyWith(
              text: min.toString() + suffixText!,
              selection:
                  TextSelection.collapsed(offset: min.toString().length));
    } else {
      if (suffixText == null) {
        return (double.tryParse(newValue.text)! > max) ? oldValue : newValue;
      }
      if (int.parse(newValue.text) > max) {
        return const TextEditingValue().copyWith(
            text: oldValue.text + suffixText!,
            selection: TextSelection.collapsed(offset: oldValue.text.length));
      } else {
        return const TextEditingValue().copyWith(
            text: newValue.text + suffixText!,
            selection: TextSelection.collapsed(offset: newValue.text.length));
      }
    }
  }
}

class InsertEmptyCharacted extends TextInputFormatter {
  final VoidCallback requestLastFocus;
  InsertEmptyCharacted({required this.requestLastFocus});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    debugPrint(
        'Heikal - empty character position ${oldValue.text.indexOf("\u200b")}');

    if (oldValue.text.length == 1 && newValue.text.isEmpty) {
      newValue = const TextEditingValue().copyWith(
          text: "\u200b", selection: const TextSelection.collapsed(offset: 1));

      requestLastFocus();
    }

    if (!newValue.text.contains("\u200b")) {
      newValue = const TextEditingValue().copyWith(
          text: "${newValue.text}\u200b",
          selection: TextSelection.collapsed(offset: newValue.text.length + 2));
    }
    return newValue;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;
      int dotValue = '.'.allMatches(value).length;
      int commaValue = ','.allMatches(value).length;
      if ((dotValue == 1 && commaValue == 1) ||
          (dotValue > 1) ||
          (commaValue > 1)) {
        truncated = oldValue.text;
        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      } else if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value.contains(",") &&
          value.substring(value.indexOf(",") + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";
        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      } else if (value == ",") {
        truncated = "0,";

        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

// class SuffixTextFormatter extends TextInputFormatter {
//   final String text;

//   SuffixTextFormatter({required this.text});

//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     if (newValue.text == '')
//       return newValue;
//     else
//       return TextEditingValue().copyWith(text: newValue.text + text);

//     // return int.parse(newValue.text) > max ? oldValue : newValue;
//   }
// }

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
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
