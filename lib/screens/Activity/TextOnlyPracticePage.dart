import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:photo_view/photo_view.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/PracticeMainPageVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/widgets/AppButtons.dart';
import 'package:teachy_tec/widgets/RoundedTextField.dart';
import 'package:teachy_tec/widgets/defaultContainer.dart';

class TextOnlyPracticePage extends StatelessWidget {
  const TextOnlyPracticePage({
    super.key,
    required this.model,
    required this.currentTask,
  });

  final TaskViewModel currentTask;
  final PracticeMainPageVM model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (currentTask.downloadUrl != null) ...[
          Text(currentTask.task, style: TextStyles.InterBlackS18W700),
          const SizedBox(
            height: kMainPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DefaultContainer(
                height: 220,
                width: double.infinity,
                child: PhotoView(
                  imageProvider: NetworkImage(
                    currentTask.downloadUrl!,
                  ),
                  loadingBuilder: (context, event) {
                    final expectedBytes = event?.expectedTotalBytes;
                    final loadedBytes = event?.cumulativeBytesLoaded;
                    final value = loadedBytes != null && expectedBytes != null
                        ? loadedBytes / expectedBytes
                        : null;

                    return Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: value,
                          color: AppColors.primary700,
                        ),
                      ),
                    );
                  },
                  initialScale: PhotoViewComputedScale.contained,
                ),
              ),
            ),
          ),
        ],
        if (currentTask.downloadUrl == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DefaultContainer(
                  height: 220,
                  padding: const EdgeInsets.all(kInternalPadding),
                  color: AppColors.black,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      currentTask.task,
                      style: TextStyles.InterWhiteS18W700,
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
          ),
        const SizedBox(height: kMainPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
          child: RoundedMultilineInputField(
            hintText: AppLocale.indicateYourAnswer
                .getString(context)
                .capitalizeFirstLetter(),
            height: 182,
            text: model.currentAnswerValue,
            onChanged: (input) {
              model.currentAnswerValue = input;
            },
          ),
        ),
        const SizedBox(height: kMainPadding * 2),
        if (model.dayTableModel.selectedShuffledStudent.value != null)
          BottomPageButton(
            onTap: () =>
                model.onSelectOption(null, text: model.currentAnswerValue),
            text: AppLocale.save.getString(context).capitalizeFirstLetter(),
          ),
        const SizedBox(height: kMainPadding),
      ],
    );
  }
}
