// ignore_for_file: constant_identifier_name
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:collection/collection.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/SoundService.dart';

class BoardEmojisSelector extends StatelessWidget {
  const BoardEmojisSelector(
      {required this.onSelectEmoji,
      this.hideSpecifiedButtons = false,
      this.answerSubmittedType,
      super.key});
  final void Function(Emoji) onSelectEmoji;
  final bool hideSpecifiedButtons;
  final AnswerSubmittedType? answerSubmittedType;

  @override
  Widget build(BuildContext context) {
    List<Emoji> currentEmojisList = (answerSubmittedType == null ||
                answerSubmittedType == AnswerSubmittedType.showFullAnswerOptions
            ? emojisList
            : answerSubmittedType ==
                    AnswerSubmittedType.showCorrectAnswerOptions
                ? emojisList
                    .where((element) => element.emojiType != EmojisTypes.zero)
                : emojisList
                    .where((element) => element.emojiType != EmojisTypes.full))
        .toList();
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (context, index) {
            return BoardEmojisIcon(
              model: currentEmojisList[index],
              onSelectEmoji: onSelectEmoji,
            );
          },
          itemCount: currentEmojisList.length,
        ),
        if (answerSubmittedType == null && !hideSpecifiedButtons) ...[
          const SizedBox(height: kMainPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomEmojisButton(
                onSelectEmoji: onSelectEmoji,
                model: const Emoji(
                  id: '15',
                  name: 'Eraser',
                  emojiPath: EmojisPath.Eraser,
                  soundType: SoundType.eraser,
                  emojiType: EmojisTypes.custom,
                ),
              ),
              CustomEmojisButton(
                onSelectEmoji: onSelectEmoji,
                model: const Emoji(
                  id: '16',
                  name: 'addNote',
                  emojiPath: EmojisPath.AddNote,
                  emojiType: EmojisTypes.custom,
                  soundType: SoundType.note,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

const List<Emoji> emojisList = [
  Emoji(
    id: '1',
    name: 'LovelyFace',
    emojiPath: EmojisPath.LovelyFace,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.full,
  ),
  Emoji(
    id: '2',
    name: 'StarFace',
    emojiPath: EmojisPath.StarFace,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.full,
  ),
  Emoji(
    id: '3',
    name: 'FireHeart',
    emojiPath: EmojisPath.FireHeart,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.full,
  ),
  Emoji(
    id: '4',
    name: 'Correct',
    emojiPath: EmojisPath.Correct,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.full,
  ),
  Emoji(
    id: '5',
    name: 'Gift',
    emojiPath: EmojisPath.Gift,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.full,
  ),
  Emoji(
    id: '6',
    name: 'ThumbsUp',
    emojiPath: EmojisPath.ThumbsUp,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.half,
  ),
  Emoji(
    id: '7',
    name: 'KeepItUp',
    emojiPath: EmojisPath.KeepItUp,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.half,
  ),
  Emoji(
    id: '8',
    name: 'Flower',
    emojiPath: EmojisPath.Flower,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.half,
  ),
  Emoji(
    id: '9',
    name: 'Celebration',
    emojiPath: EmojisPath.Celebration,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.half,
  ),
  Emoji(
    id: '10',
    name: 'Star',
    emojiPath: EmojisPath.Star,
    soundType: SoundType.correct,
    emojiType: EmojisTypes.half,
  ),
  Emoji(
    id: '11',
    name: 'Cry',
    emojiPath: EmojisPath.Cry,
    soundType: SoundType.wrong,
    emojiType: EmojisTypes.zero,
  ),
  Emoji(
    id: '12',
    name: 'Angry',
    emojiPath: EmojisPath.Angry,
    soundType: SoundType.wrong,
    emojiType: EmojisTypes.zero,
  ),
  Emoji(
    id: '13',
    name: 'BrokenFlower',
    emojiPath: EmojisPath.BrokenFlower,
    soundType: SoundType.wrong,
    emojiType: EmojisTypes.zero,
  ),
  Emoji(
    id: '14',
    name: 'Wrong',
    emojiPath: EmojisPath.Wrong,
    soundType: SoundType.wrong,
    emojiType: EmojisTypes.zero,
  ),
  Emoji(
    id: '15',
    name: 'Explosion',
    emojiPath: EmojisPath.Explosion,
    soundType: SoundType.wrong,
    emojiType: EmojisTypes.zero,
  ),
];

Emoji? getEmojiById(String? id) {
  return emojisList.firstWhereOrNull((element) => element.id == id);
}

class Emoji {
  final String id;
  final String name;
  final SoundType soundType;
  final EmojisPath emojiPath;
  final EmojisTypes emojiType;
  const Emoji({
    required this.id,
    required this.name,
    required this.emojiPath,
    required this.emojiType,
    required this.soundType,
  });
}

enum EmojisTypes {
  zero(iconValue: 0),
  half(iconValue: 0.5),
  full(iconValue: 1),
  custom(iconValue: 2);

  final double iconValue;
  const EmojisTypes({
    required this.iconValue,
  });
}

enum EmojisPath {
  LovelyFace(
    iconPath: 'assets/gif/lovelyFace_icon.gif',
    iconGrade: EmojisTypes.full,
  ),
  StarFace(
    iconPath: 'assets/gif/starFace_icon.gif',
    iconGrade: EmojisTypes.full,
  ),
  FireHeart(
    iconPath: 'assets/gif/fireHeart_icon.gif',
    iconGrade: EmojisTypes.full,
  ),
  Correct(
    iconPath: 'assets/gif/correct_icon.gif',
    iconGrade: EmojisTypes.full,
  ),
  Gift(
    iconPath: 'assets/gif/gift_icon.gif',
    iconGrade: EmojisTypes.full,
  ),
  ThumbsUp(
    iconPath: 'assets/gif/thumbsUp_icon.gif',
    iconGrade: EmojisTypes.half,
  ),
  KeepItUp(
    iconPath: 'assets/gif/keepItUp_icon.gif',
    iconGrade: EmojisTypes.half,
  ),
  Flower(
    iconPath: 'assets/gif/flower_icon.gif',
    iconGrade: EmojisTypes.half,
  ),
  Celebration(
    iconPath: 'assets/gif/celebration_icon.gif',
    iconGrade: EmojisTypes.half,
  ),
  Star(
    iconPath: 'assets/gif/star_icon.gif',
    iconGrade: EmojisTypes.half,
  ),
  Cry(
    iconPath: 'assets/gif/cry_icon.gif',
    iconGrade: EmojisTypes.zero,
  ),
  Angry(
    iconPath: 'assets/gif/angry_icon.gif',
    iconGrade: EmojisTypes.zero,
  ),
  BrokenFlower(
    iconPath: 'assets/gif/brokenFlower_icon.gif',
    iconGrade: EmojisTypes.zero,
  ),
  Wrong(
    iconPath: 'assets/gif/wrong_icon.gif',
    iconGrade: EmojisTypes.zero,
  ),
  Explosion(
    iconPath: 'assets/gif/explosion_icon.gif',
    iconGrade: EmojisTypes.zero,
  ),
  Eraser(
    iconPath: 'assets/svg/eraser.svg',
    iconGrade: EmojisTypes.zero,
  ),
  AddNote(
    iconPath: 'assets/svg/addNote.svg',
    iconGrade: EmojisTypes.zero,
  );

  final String iconPath;
  final EmojisTypes iconGrade;

  const EmojisPath({
    required this.iconPath,
    required this.iconGrade,
  });
}

class EmojisIconPreview extends StatelessWidget {
  const EmojisIconPreview({required this.model, super.key});
  final Emoji? model;

  @override
  Widget build(BuildContext context) {
    if (model == null) return Container();
    final color = model!.emojiPath.iconGrade == EmojisTypes.full
        ? AppColors.green600
        : model!.emojiPath.iconGrade == EmojisTypes.half
            ? AppColors.primary700
            : AppColors.red600;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 40,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
                // color.withOpacity(0.02),
                color.withOpacity(0.0),
                // color.withOpacity(0.1),/
                // color.withOpacity(0),
              ].reversed.toList(),
            ),
          ),
          child: model!.emojiPath.iconPath.contains('gif')
              ? Center(
                  child: Image.asset(
                    model!.emojiPath.iconPath,
                    height: 35,
                  ),
                )
              : model!.emojiPath.iconPath.contains('svg')
                  ? Center(
                      child: SvgPicture.asset(
                        model!.emojiPath.iconPath,
                        height: 35,
                      ),
                    )
                  : SizedBox(),
        ),

        // if (model!.emojiPath.iconPath.contains('gif'))
        //   Image.asset(
        //     model!.emojiPath.iconPath,
        //     height: 30,
        //   ),
        // if (model!.emojiPath.iconPath.contains('svg'))
        //   SvgPicture.asset(
        //     model!.emojiPath.iconPath,
        //     height: 30,
        //   ),
      ],
    );
  }
}

class BoardEmojisIcon extends StatelessWidget {
  const BoardEmojisIcon(
      {required this.onSelectEmoji, required this.model, super.key});
  final Emoji model;
  final void Function(Emoji)? onSelectEmoji;
  @override
  Widget build(BuildContext context) {
    final color = model.emojiPath.iconGrade == EmojisTypes.full
        ? AppColors.green600
        : model.emojiPath.iconGrade == EmojisTypes.half
            ? AppColors.primary700
            : AppColors.red700;
    return InkWell(
      onTap: onSelectEmoji != null ? () => onSelectEmoji!(model) : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(0.57),
                  color.withOpacity(0),
                ],
              ),
            ),
          ),
          if (model.emojiPath.iconPath.contains('gif'))
            Image.asset(
              model.emojiPath.iconPath,
              height: 50,
            ),
          if (model.emojiPath.iconPath.contains('svg'))
            SvgPicture.asset(
              model.emojiPath.iconPath,
              height: 50,
            ),
        ],
      ),
    );
  }
}

class CustomEmojisButton extends StatelessWidget {
  const CustomEmojisButton(
      {required this.onSelectEmoji, required this.model, super.key});
  final Emoji model;
  final void Function(Emoji) onSelectEmoji;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectEmoji(model),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.grey500,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        // radius: const Radius.circular(12),
        // borderType: BorderType.RRect,
        // dashPattern: const [8, 5],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(kMainPadding),
                child: model.emojiPath.iconPath.contains('gif')
                    ? Image.asset(
                        model.emojiPath.iconPath,
                        height: 50,
                      )
                    : SvgPicture.asset(
                        model.emojiPath.iconPath,
                        height: 50,
                      ),
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppColors.grey300,
                    ),
                    child: Text(
                      model.emojiPath == EmojisPath.Eraser
                          ? AppLocale.eraser
                              .getString(context)
                              .capitalizeAllWord()
                          : AppLocale.addNote
                              .getString(context)
                              .capitalizeAllWord(),
                      style: TextStyles.InterGrey900S10W400,
                      textAlign: TextAlign.center,
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
