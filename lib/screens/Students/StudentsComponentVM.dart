import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/screens/Students/StudentPreviewInFormVM.dart';
import 'package:teachy_tec/screens/Students/studentDetailsScreen.dart';
import 'package:teachy_tec/screens/Students/studentDetailsScreenVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/showSpecificNotifications.dart';

class StudentsComponentVM extends ChangeNotifier {
  List<StudentPreviewInFormVM> studentsList = [];
  Gender currentGender = Gender.male;
  PlatformFile? currentFile;
  bool isPreview;
  StudentsComponentVM.edit({
    required Class? currentClass,
    this.isPreview = false,
  }) {
    laodStudentsFromDB(currentClass);
  }
  StudentsComponentVM.preview(
      {required Class? currentClass, this.isPreview = true}) {
    laodStudentsFromDB(currentClass);
  }
  StudentsComponentVM({
    this.isPreview = false,
  });

  Future<void> onTapStudentInPreviewDetails(
      StudentPreviewInFormVM studentFormVM) async {
    await UIRouter.pushScreen(
        StudentDetailsScreen(
            model: StudentDetailsScreenVM(
          currentStudent: studentFormVM.currentStudent,
          onDeleteStudent: () {
            studentsList.removeWhere((element) =>
                element.studentFormVM.oldStudent?.id ==
                studentFormVM.currentStudent.id);
            notifyListeners();
          },
          onUpdateStudent: (newStudent) {
            var currentIndex = studentsList.indexWhere((element) =>
                element.studentFormVM.oldStudent?.id ==
                studentFormVM.currentStudent.id);
            if (currentIndex != -1) {
              studentsList[currentIndex].currentStudent = newStudent;
              notifyListeners();
            }
          },
        )),
        pageName: AppAnalyticsConstants.StudentDetailsScreen);
  }

  Future<void> laodStudentsFromDB(Class? currentClass) async {
    if (currentClass != null) {
      UIRouter.showEasyLoader();
      List<Student> studentClassList =
          await serviceLocator<AppNetworkProvider>()
              .getStudentsList(class_: currentClass);
      onAddNewStudentsFromExcel(studentClassList);
      EasyLoading.dismiss(animation: true);
    }
  }

  void setCurrentGender(Gender currentGender) {
    this.currentGender = currentGender;
  }

  void onAddNewStudent() {
    for (var element in studentsList) {
      if (!element.studentFormVM.validateForm()) return;
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    finishAllOtherStudents();
    // });
    int currentIndex = studentsList.length;
    studentsList.add(
      StudentPreviewInFormVM(
        currentStudent: Student(id: currentIndex.toString(), name: ''),
        isInEditMode: true,
        isPreview: isPreview,
        changeGeneralGenderSettings: setCurrentGender,
        gender: currentGender,
        onEditTapped: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            finishAllOtherStudents(indexTrigerredFunction: currentIndex);
          });
        },
        onFinishTapped: (newStudent, startAddingNewStudent) {
          studentsList[currentIndex].currentStudent = newStudent;
          if (startAddingNewStudent) onAddNewStudent();
          notifyListeners();
        },
        onDeleteTapped: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            studentsList.removeAt(currentIndex);
            notifyListeners();
          });
        },
      ),
    );
    notifyListeners();
  }

  void onAddNewStudentsFromExcel(List<Student> students) {
    for (var element in studentsList) {
      if (!element.studentFormVM.validateForm()) return;
    }

    var removedStudentsCount = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      finishAllOtherStudents();
    });

    for (var student in students) {
      int currentIndex = studentsList.length;
      if (student.name.trim().isEmpty) continue;
      if (studentsList.any((studentObject) =>
          studentObject.currentStudent.name.trim().toLowerCase() ==
          student.name.trim().toLowerCase())) {
        removedStudentsCount += 1;
      } else {
        studentsList.add(
          StudentPreviewInFormVM(
            currentStudent: student,
            isInEditMode: false,
            isPreview: isPreview,
            changeGeneralGenderSettings: setCurrentGender,
            gender: currentGender,
            onEditTapped: () async {
              finishAllOtherStudents(indexTrigerredFunction: currentIndex);
            },
            onFinishTapped: (newStudent, startAddingNewStudent) {
              studentsList[currentIndex].currentStudent = newStudent;
              if (startAddingNewStudent) onAddNewStudent();
              notifyListeners();
            },
            onDeleteTapped: () {
              studentsList.removeAt(currentIndex);
              notifyListeners();
            },
          ),
        );
      }
      if (removedStudentsCount > 0) {
        showSpecificNotificaiton(
            notifcationDetails:
                AppNotifcationsItems.duplicateValuesInAvailability(
                    removedStudentsCount));
      }
    }
    notifyListeners();
  }

  finishAllOtherStudents({int? indexTrigerredFunction}) {
    var currentIndex = 0;
    for (var element in studentsList) {
      if (element.isInEditMode && currentIndex != indexTrigerredFunction) {
        if (element.studentFormVM.name?.isNotEmpty == true) {
          element.studentFormVM.onCompleteButtonTapped();
        } else {
          element.onDeleteTapped();
        }
      }
      currentIndex++;
    }
  }

  Future<void> onUploadFile() async {
    FilePicker picker = FilePicker.platform;

    FilePickerResult? result = await picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
      allowMultiple: false,
    );

    if (result?.files == null || result!.files.isEmpty) return;
    currentFile = result.files.first;
    var bytes = File(currentFile!.path ?? '').readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var headers = excel.tables.values.first.rows.first;
    int nameIndex = -1;
    int genderIndex = -1;
    for (int i = 0; i < headers.length; i++) {
      for (var element in nameAlternatives) {
        if (((headers[i]?.value) ?? "")
            .toString()
            .trim()
            .toLowerCase()
            .contains(element.trim().toLowerCase())) {
          nameIndex = i;
          break;
        }
      }
      for (var element in genderAlternatives) {
        if (((headers[i]?.value) ?? "")
            .toString()
            .trim()
            .toLowerCase()
            .contains(element.trim().toLowerCase())) {
          genderIndex = i;
          break;
        }
      }
    }

    if (nameIndex == -1) {
      showSpecificNotificaiton(
          notifcationDetails: AppNotifcationsItems.didntFindNamesColumn);
      return;
    }

    List<Student> newStudents = [];
    for (int i = 1; i < excel.tables.values.first.rows.length; i++) {
      Gender? currentGender;
      if (genderIndex == -1) {
        currentGender = null;
      } else {
        for (var element in maleAlternatives) {
          if ((excel.tables.values.first.rows[i][genderIndex])
              .toString()
              .trim()
              .toLowerCase()
              .contains(
                element.trim().toLowerCase(),
              )) {
            currentGender = Gender.male;
            break;
          }
        }
        for (var element in femaleAlternatives) {
          if ((excel.tables.values.first.rows[i][genderIndex])
              .toString()
              .trim()
              .toLowerCase()
              .contains(element.trim().toLowerCase())) {
            currentGender = Gender.female;
            break;
          }
        }
      }

      newStudents.add(Student(
          id: (studentsList.length + i - 1).toString(),
          name: (excel.tables.values.first.rows[i][nameIndex]?.value ?? "")
              .toString()
              .trim(),
          gender: currentGender));
    }
    onAddNewStudentsFromExcel(newStudents);
  }

  Future<void> downloadFileFromAssets() async {
    Directory downloadDirectory;

    if (Platform.isIOS) {
      downloadDirectory = await getApplicationDocumentsDirectory();
    } else {
      downloadDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadDirectory.exists()) {
        downloadDirectory = (await getExternalStorageDirectory())!;
      }
    }

    final file = File("${downloadDirectory.path}/Students template1.xlsx");
    String targetPath = "${downloadDirectory.path}/Students template1.xlsx";
    if (await file.exists()) {
      // File already exists, no need to download
      if (kDebugMode) {
        print('File already exists at $targetPath');
      }
      await OpenFile.open(file.path);
      return;
    }

    try {
      // Load the asset using rootBundle
      final ByteData data =
          await rootBundle.load('assets/excel/Students template1.xlsx');
      // await rootBundle.load('assets/excel/ds.xlsx');
      final List<int> bytes = data.buffer.asUint8List();

      // Write the bytes to the file
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);

      if (kDebugMode) {
        print('File downloaded and saved to $targetPath');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }

      FirebaseCrashlytics.instance.recordError(e, null,
          fatal: false,
          reason:
              "Heikal - downloadFileFromAssets in StudentsComponentVM \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
    }
  }

  List<Student> getStudentsList() {
    List<Student> studentsListToReturn = [];
    for (var student in studentsList) {
      student.studentFormVM.onCompleteButtonTapped();
      if (student.currentStudent.name.trim().isNotEmpty) {
        student.currentStudent.id = null;
        studentsListToReturn.add(student.currentStudent);
      }
    }

    return studentsListToReturn;
  }
}

List<String> nameAlternatives = [
  'الاسم',
  'name',
  'full name',
  'student name',
  'اسم الطالب',
];
List<String> genderAlternatives = [
  'الجنس',
  'النوع',
  'gender',
  'type',
];
List<String> maleAlternatives = [
  'ذكر',
  'الذكر',
  'male',
  'man',
];
List<String> femaleAlternatives = [
  'انثى',
  'أنثى',
  'الأنثى',
  'انثي',
  'أنثي',
  'الأنثي',
  'female',
  'woman',
];
