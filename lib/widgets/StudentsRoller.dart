import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/styles/TextStyles.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';

class StudentsRoller extends StatefulWidget {
  const StudentsRoller({
    required this.students,
    required this.shuffledStudents,
    required this.onRestartShuffle,
    required this.onSelectStudent,
    required this.onCancelShuffle,
    required this.startRollerSound,
    super.key,
  });

  final List<Student> students;
  final List<Student> shuffledStudents;
  final void Function(Student) onSelectStudent;
  final VoidCallback onRestartShuffle;
  final VoidCallback onCancelShuffle;
  final VoidCallback startRollerSound;

  @override
  State<StudentsRoller> createState() => _StudentsRollerState();
}

class _StudentsRollerState extends State<StudentsRoller> {
  late int selectedIndex;
  // final player = AudioPlayer();
  StreamController<int> controller = StreamController<int>();
  late List<Student> shuffledStudents;
  bool isAnimationRunning = true;
  ValueNotifier<Student?> currentStudentInTheWheel = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    shuffledStudents = widget.shuffledStudents;
    selectedIndex = getRandomStudent();
    controller.add(selectedIndex);
  }

  int getRandomStudent() {
    // generates a new Random object
    final random = Random();
    // startRollerSound();
    var newStudentsList = [];
    for (var element in widget.students) {
      if (!shuffledStudents.contains(element)) {
        newStudentsList.add(element);
      }
    }

    // generate a random index based on the list length
    // and use it to retrieve the element
    Student selectedStudent =
        newStudentsList[random.nextInt(newStudentsList.length)];

    // widget.shuffledStudents.add(selectedStudent);
    selectedIndex = widget.students.indexWhere(
        (currentStudent) => selectedStudent.id == currentStudent.id);
    setState(
      () {
        controller.add(selectedIndex);
      },
    );
    return selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: FortuneWheel(
            selected: controller.stream,
            rotationCount: 10,
            duration: const Duration(seconds: 6),
            indicators: const <FortuneIndicator>[
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: TriangleIndicator(
                  color: AppColors.primary900,
                ),
              )
            ],
            onFocusItemChanged: (index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                currentStudentInTheWheel.value = widget.students[index];
              });
            },
            onAnimationStart: () {
              widget.startRollerSound();
              isAnimationRunning = true;
            },
            onAnimationEnd: () {
              isAnimationRunning = false;
            },
            items: widget.students
                .mapWithIndex((e, index) => FortuneItem(
                      child: Padding(
                        padding: const EdgeInsets.all(kMainPadding * 2),
                        child: Text(
                          e.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.start,
                          textScaler: const TextScaler.linear(1),
                          style: /*  index % 5 == 0
                              ? TextStyles.InterYellow700S12W400
                              :  */
                              index % 2 == 0
                                  ? TextStyles.InterBlackS12W400
                                  : TextStyles.InterWhiteS12W400,
                        ),
                      ),
                      style: FortuneItemStyle(
                        color: /*  index % 5 == 0
                            ? AppColors.grey800
                            :  */
                            index % 2 == 0
                                ? AppColors.grey400
                                : AppColors.grey900,
                        borderColor: AppColors.primary50,
                        borderWidth: 0,
                      ),
                    ))
                .toList(),
            physics: NoPanPhysics(),
          ),
        ),
        Flexible(
          child: Column(
            children: [
              ValueListenableBuilder<Student?>(
                valueListenable: currentStudentInTheWheel,
                builder: (context, currentStudentInTheWheel, child) =>
                    currentStudentInTheWheel == null
                        ? const SizedBox()
                        : Text(
                            AppLocale.currentStudent
                                .getString(context)
                                .capitalizeAllWord(),
                            style: TextStyles.InterBlackS20W700,
                          ),
              ),
              ValueListenableBuilder<Student?>(
                valueListenable: currentStudentInTheWheel,
                builder: (context, currentStudentInTheWheel, child) =>
                    currentStudentInTheWheel == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(kInternalPadding),
                            child: Text(
                              currentStudentInTheWheel.name,
                              style: TextStyles.InterBlackS20W700,
                            ),
                          ),
              ),
              ValueListenableBuilder<Student?>(
                valueListenable: currentStudentInTheWheel,
                builder: (context, currentStudentInTheWheel, child) =>
                    currentStudentInTheWheel == null
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              widget.onSelectStudent(currentStudentInTheWheel);
                              widget.onCancelShuffle();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.grey900,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(kHelpingPadding),
                              child: const Icon(
                                Icons.done,
                                color: AppColors.primary700,
                                size: 40,
                              ),
                            ),
                          ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // BottomPageButton(onTap: () {}, text: 'Cancel'),
                  InkWell(
                    onTap: () {
                      if (isAnimationRunning) return;
                      getRandomStudent();
                    },
                    child: SvgPicture.asset(
                      'assets/svg/replay.svg',
                      height: 50,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (isAnimationRunning) return;
                      widget.onRestartShuffle();
                      setState(() {
                        widget.students.addAll(shuffledStudents);
                        shuffledStudents = [];
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/svg/restart.svg',
                      height: 50,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.onCancelShuffle();
                    },
                    child: SvgPicture.asset(
                      'assets/svg/cancel.svg',
                      height: 50,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
