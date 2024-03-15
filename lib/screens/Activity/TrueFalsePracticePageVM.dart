import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/Activity/PracticeMainPageVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';

class TrueFalsePracticePageVM extends ChangeNotifier {
  TaskViewModel currentTask;
  PracticeMainPageVM model;

  TrueFalsePracticePageVM({
    required this.currentTask,
    required this.model,
  }) {
    selectedValue = model.getIsCurrentSelectedOptionIsCorrect() ??
        model.currentSelectedOption?.isCorrect;
  }

  Offset _position = Offset.zero;
  bool _isDragging = false;
  double _angle = 0;
  Size _screenSize = Size.zero;
  bool isFinishedByTapping = false;
  Offset get positon => _position;
  bool get isDragging => _isDragging;
  double get angle => _angle;

  void startPosition(DragStartDetails details) {
    if (selectedValue != null || model.currentSelectedOption != null) {
      return;
    }
    _isDragging = true;
  }

  void updatePosition(DragUpdateDetails details) {
    if (selectedValue != null) {
      return;
    }
    _position += details.delta;
    final xPosition = _position.dx;
    if (_screenSize.width == 0) {
      _angle = 45 * xPosition / 400;
    } else {
      _angle = 45 * xPosition / _screenSize.width;
    }
    notifyListeners();
  }

  void setScreenSize(Size size) => _screenSize = size;
  bool? selectedValue;
  void submitAnswer(bool isTrueButton, {bool finishedByTapping = false}) {
    bool rightAnswerValue = getAnswerValue();

    _submitAnswer(isTrueButton == rightAnswerValue);

    selectedValue = isTrueButton == rightAnswerValue;
    isFinishedByTapping = finishedByTapping;
    notifyListeners();
  }

  bool? endPosition() {
    _isDragging = false;
    notifyListeners();

    bool? _isFalseSelected = isFalseSelected();
    if (_isFalseSelected != null) {
      if (_isFalseSelected) {
        animateToRight();
      } else {
        animateToLeft();
      }
    } else {
      resetPositon();
    }
    return _isFalseSelected;
  }

  bool? isFalseSelected() {
    final xPosition = _position.dx;

    const delta = 150;

    if (xPosition >= delta) {
      return true;
    } else if (xPosition <= -delta) {
      return false;
    }
    return null;
  }

  void animateToRight() {
    _angle = 20;
    _position += Offset(_screenSize.width != 0 ? _screenSize.width : 500, 0);
    notifyListeners();
  }

  void animateToLeft() {
    _angle = -20;
    _position -= Offset(_screenSize.width != 0 ? _screenSize.width : 500, 0);
    notifyListeners();
  }

  void resetPositon() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  Widget getQuestionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
      child: Text(
        currentTask.task.trim(),
        style: TextStyles.InterBlackS18W600,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getGridEmptyAlternative() {
    return Container(
      height: 375,
      width: double.infinity,
      color: AppColors.grey400,
      child: SvgPicture.asset(
        'assets/vectors/policyAlternative.svg',
        height: 84,
        color: AppColors.grey200,
      ),
    );
  }

  bool getAnswerValue() {
    return currentTask.options?.first.isCorrect ?? false;
  }

  String getItemName() {
    return currentTask.task;
  }

  // int getItemId() {
  //   switch (T) {
  //     case WineItemContainsIngredientQuizViewModel:
  //       return (model as WineItemContainsIngredientQuizViewModel).wineItem!.id;
  //     case MenuItemContainsIngredientQuizViewModel:
  //       return (model as MenuItemContainsIngredientQuizViewModel).menuItem!.id;
  //     case QuizCustomQuestionViewModel:
  //       return (model as QuizCustomQuestionViewModel).policyViewModel?.id ?? 0;
  //     default:
  //       return 0;
  //   }
  //   // return (model as dynamic).wineItem!.id;
  // }

  // String getQuestionIdentifier() {
  //   switch (T) {
  //     case WineItemContainsIngredientQuizViewModel:
  //       return (model as WineItemContainsIngredientQuizViewModel).id;
  //     case MenuItemContainsIngredientQuizViewModel:
  //       return (model as MenuItemContainsIngredientQuizViewModel).id;
  //     case QuizCustomQuestionViewModel:
  //       return (model as QuizCustomQuestionViewModel).id;
  //     default:
  //       return "";
  //     // return (model as dynamic).id;
  //   }
  // }

  // dynamic getRelatedMaterials() {
  //   switch (T) {
  //     case WineItemContainsIngredientQuizViewModel:
  //       return (model as WineItemContainsIngredientQuizViewModel).wineItem!;
  //     case MenuItemContainsIngredientQuizViewModel:
  //       return (model as MenuItemContainsIngredientQuizViewModel).menuItem!;
  //     default:
  //       return 0;
  //   }
  //   // return (model as dynamic).wineItem;
  // }

  void _submitAnswer(bool isCorrectAnswer) {
    // switch (T) {
    //   case WineItemContainsIngredientQuizViewModel:
    //     (submittedList as List<WineItemContainsIngredientAnswerModel>).add(
    //       WineItemContainsIngredientAnswerModel(
    //           getItemId(),
    //           getQuestionIdentifier(),
    //           isCorrectAnswer,
    //           DateTime.now().toUtc().millisecondsSinceEpoch ~/
    //               Duration.millisecondsPerSecond),
    //     );
    //     break;
    //   case MenuItemContainsIngredientQuizViewModel:
    //     (submittedList as List<MenuItemContainsIngredientAnswerModel>).add(
    //       MenuItemContainsIngredientAnswerModel(
    //           getItemId(),
    //           getQuestionIdentifier(),
    //           isCorrectAnswer,
    //           DateTime.now().toUtc().millisecondsSinceEpoch ~/
    //               Duration.millisecondsPerSecond),
    //     );
    //     break;
    //   case QuizCustomQuestionViewModel:
    //     (submittedList)?.add(
    //       CustomQuestionAnswerModel(
    //         getItemId(),
    //         (model as QuizCustomQuestionViewModel).policyViewModel != null &&
    //                 customCategoryId == null
    //             ? (model as QuizCustomQuestionViewModel).policyViewModel!.id
    //             : null,
    //         (model as QuizCustomQuestionViewModel).wineItem != null
    //             ? (model as QuizCustomQuestionViewModel).wineItem!.id
    //             : null,
    //         [
    //           (model as QuizCustomQuestionViewModel)
    //               .options
    //               .firstWhere((element) => element.isCorrect == isCorrectAnswer)
    //               .id!
    //         ],
    //         (model as QuizCustomQuestionViewModel).menuItem != null
    //             ? (model as QuizCustomQuestionViewModel).menuItem!.id
    //             : null,
    //         (model as QuizCustomQuestionViewModel).id,
    //         isCorrectAnswer,
    //         DateTime.now().toUtc().millisecondsSinceEpoch ~/
    //             Duration.millisecondsPerSecond,
    //         customCategoryId: customCategoryId ?? 0,
    //         // model.policyViewModel != null ? model.policyViewModel!.id : null,
    //       ),
    //     );
    //     break;
    //   default:
    //     break;
    // }
  }
}
