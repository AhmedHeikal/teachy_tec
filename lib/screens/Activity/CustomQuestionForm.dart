import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/Activity/CustomQuestionFormVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/MediaPickerWidget.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class CustomQuestionForm extends StatelessWidget {
  const CustomQuestionForm({
    super.key,
    required this.model,
    this.isInOpenedCustomQuestion = false,
    this.index,
    this.onDelete,
    this.isInPopUp = false,
    this.padding = const EdgeInsets.all(kBottomPadding),
  });

  final bool isInPopUp;
  final EdgeInsets padding;
  final int? index;
  final VoidCallback? onDelete;
  final CustomQuestionFormVM model;
  final bool isInOpenedCustomQuestion;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: ValueListenableBuilder<bool>(
        valueListenable: model.isLoading,
        builder: (context, isLoading, child) => IgnorePointer(
          ignoring: isLoading,
          child: DefaultContainer(
            key: UniqueKey(),
            padding: padding,
            // addDefaultBoxShadow: true,
            width: double.infinity,
            child: Consumer<CustomQuestionFormVM>(
              builder: (context, model, _) => SingleChildScrollView(
                physics:
                    isInPopUp ? null : const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isInOpenedCustomQuestion)
                      index != null
                          ? Text(
                              '${AppLocale.task.getString(context)} $index'
                                  .toUpperCase(),
                              style: TextStyles.InterGrey400S12W600,
                            )
                          : Text(
                              AppLocale.task.getString(context).toUpperCase(),
                              style: TextStyles.InterGrey400S12W600,
                            ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: model.formKey,
                            child: RoundedInputField(
                              hintText: '',
                              isReadOnly: model.isReadOnly,
                              height: isInOpenedCustomQuestion ? 62 : 44,
                              text: model.question,
                              errorHintText: AppLocale.specifyTheQuestion
                                  .getString(context)
                                  .capitalizeFirstLetter(),
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (input) {
                                model.question = input;
                                if (model.onChange != null) {
                                  // if (model.questionVM != null)
                                  //   model.questionVM!.name = input;
                                  model.onChange!();
                                }
                              },
                              isEmptyValidation: true,
                            ),
                          ),
                        ),
                        if (!model.isReadOnly && onDelete != null)
                          SizedBox(
                            height: 24,
                            width: 24 + kBottomPadding,
                            child: !isLoading
                                ? InkWell(
                                    onTap: onDelete,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: kBottomPadding),
                                      child: SvgPicture.asset(
                                        "assets/svg/bin.svg",
                                        color: AppColors.primary700,
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: kBottomPadding),
                                    child: Center(
                                      child: SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary700,
                                          strokeWidth: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                      ],
                    ),
                    const SizedBox(height: kBottomPadding),
                    if (model.addMedia)
                      Column(
                        children: [
                          MediaPickerWidget(
                              maxMediaCount: 1,
                              isReadOnly: model.isReadOnly,
                              canUploadVideos: false,
                              initialList:
                                  model.image != null ? [model.image!] : null,
                              mediaCallBack: (mediaFileList) {
                                // if (model.questionVM != null) {
                                //   model.questionVM!.imageFile =
                                //       mediaFileList != null &&
                                //               mediaFileList.length != 0
                                //           ? mediaFileList.first
                                //           : null;
                                // }
                                model.image = mediaFileList != null &&
                                        mediaFileList.isNotEmpty
                                    ? mediaFileList.first
                                    : null;

                                if (model.onChange != null) model.onChange!();
                              }
                              // model.mediaSelected = mediaFileList ?? [],
                              ),
                          const SizedBox(height: kBottomPadding)
                        ],
                      ),
                    DefaultContainer(
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        // padding: EdgeInsets.only(top: kBottomPadding),
                        itemBuilder: (context, index) {
                          var item = model.options[index];
                          return QuestionOptionComponent(
                            key: UniqueKey(),
                            isCheckbox: true,
                            index: index + 1,
                            model: item,
                            onChange: model.onChange,
                            onDeleteOption: () => model.onDeleteOption(index),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: kBottomPadding),
                        itemCount: model.options.length,
                      ),
                    ),
                    if (!model.isReadOnly) ...[
                      model.options.isEmpty
                          ? const SizedBox()
                          : const SizedBox(height: kBottomPadding),
                      ImaginaryOptionToAddNewOne(
                        currentIndex: model.options.length + 1,
                        onAddFunction: (isTrueselected) =>
                            model.addAnOption(startWithTrue: isTrueselected),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImaginaryOptionToAddNewOne extends StatelessWidget {
  const ImaginaryOptionToAddNewOne({
    super.key,
    required this.currentIndex,
    required this.onAddFunction,
  });
  final int currentIndex;
  final Function(bool) onAddFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocale.option.getString(context).toUpperCase(),
          style: TextStyles.InterGrey300S12W600,
        ),
        const SizedBox(height: 2),
        InkWell(
          onTap: () => onAddFunction(false),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: DottedBorder(
                    // radius: Radius.circular(7),
                    color: AppColors.grey300,
                    dashPattern: const [4, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    // radius: Radius.circular(8),
                    child: Container(
                      width: double.infinity,
                    ),
                  ),
                ),
                // child: Container(
                //   height: 44,
                // ),
              ),
              const SizedBox(width: kBottomPadding),
              SvgPicture.asset(
                "assets/svg/addButton.svg",
                colorFilter: const ColorFilter.mode(
                    AppColors.primary700, BlendMode.srcIn),
                height: 24,
                width: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuestionOptionComponent extends StatelessWidget {
  const QuestionOptionComponent({
    super.key,
    required this.index,
    // required this.onSelectItem,
    required this.onDeleteOption,
    required this.model,
    required this.isCheckbox,
    this.onChange,
  });
  final int index;
  final VoidCallback onDeleteOption;
  final QuestionOptionComponentVM model;
  final bool isCheckbox;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Form(
        key: model.formKey,
        child: Consumer<QuestionOptionComponentVM>(
          builder: (context, model, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppLocale.option.getString(context)} $index'.toUpperCase(),
                style: TextStyles.InterGrey400S12W600,
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomQuestionOptionTextField(
                      key: UniqueKey(),
                      text: model.optionString,
                      isReadOnly: model.isReadOnly,
                      initialOptionSate: model.isCorrect ?? false,
                      onChanged: (input) {
                        model.optionString = input;
                        if (onChange != null) {
                          if (model.option != null) model.option!.name = input;
                          if (onChange != null) onChange!();
                        }
                      },
                      onTrueOptionToggleCallback: (isSelected) {
                        if (model.onSelectItem != null) model.onSelectItem!();
                        if (onChange != null) onChange!();
                        model.isCorrect = isSelected;
                        model.option?.isCorrect = isSelected;
                      },
                    ),
                  ),
                  const SizedBox(width: kBottomPadding),
                  MediaPickerWidget(
                      height: 44,
                      width: 50,
                      isReadOnly: model.isReadOnly,
                      maxMediaCount: 1,
                      canUploadVideos: false,
                      // isExternallyControlledAndSmallPreviewed: true,
                      initialList: model.image != null ? [model.image!] : null,
                      customDesignWithoutSelection: DefaultContainer(
                        height: 44,
                        width: 50,
                        border:
                            Border.all(color: AppColors.grey300, width: 0.5),
                        padding: const EdgeInsets.all(kInternalPadding),
                        child: SvgPicture.asset(
                          "assets/svg/customOptionsEmptyImage.svg",
                          height: 24,
                          width: 24,
                        ),
                      ),
                      mediaCallBack: (mediaFileList) {
                        // if (model.questionVM != null) {
                        //   model.questionVM!.imageFile =
                        //       mediaFileList != null &&
                        //               mediaFileList.length != 0
                        //           ? mediaFileList.first
                        //           : null;
                        // }
                        model.image =
                            mediaFileList != null && mediaFileList.isNotEmpty
                                ? mediaFileList.first
                                : null;
                      }),
                  if (isCheckbox && !model.isReadOnly)
                    InkWell(
                      onTap: onDeleteOption,
                      child: SizedBox(
                        height: 44,
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: kBottomPadding),
                            child: SvgPicture.asset(
                              "assets/svg/bin.svg",
                              color: AppColors.primary700,
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
