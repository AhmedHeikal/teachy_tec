import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/screens/Classes/ClassForm.dart';
import 'package:teachy_tec/screens/Classes/ClassFormVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/AppExtensions.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:teachy_tec/widgets/Popups/DeleteItemPopup.dart';

class ClassesScreenVM extends ChangeNotifier {
  List<Class> classes = [];
  bool isInitialized = false;

  Future<List<Class>> getClassesList() async {
    UIRouter.showEasyLoader();
    try {
      var classesJson = await serviceLocator<FirebaseFirestore>()
          .collection(FirestoreConstants.teacherClasses)
          .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
          .get();

      classes = ((classesJson.data()?.values.first ?? []) as List)
          .map((e) => Class.fromJson((e as Map<String, dynamic>)))
          .toList();
      isInitialized = true;
      notifyListeners();
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null,
          fatal: false,
          reason:
              "Heikal - getClasses failed in ClassesScreenVM \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
    }

    await EasyLoading.dismiss(animation: true);

    return classes;
  }

  Future<void> onEditClass({required Class classToEdit}) async {
    var returnedClass = await UIRouter.pushScreen(
      ClassForm(
        model: ClassFormVM.edit(
          oldClass: classToEdit,
        ),
      ),
      pageName: AppAnalyticsConstants.ClassFormScreen,
    );

    if (returnedClass != null) {
      var currentIndex =
          classes.indexWhere((classVar) => classVar.id == returnedClass!.id);
      if (currentIndex != -1) {
        classes[currentIndex] = returnedClass;
        notifyListeners();
      }
    }
  }

  Future<void> onDeleteClass({required Class classToEdit}) async {
    await UIRouter.showAppBottomDrawerWithCustomWidget(
      bottomPadding: 0,
      child: DeleteItemPopup(
        onDeleteCallback: () async {
          UIRouter.showEasyLoader();
          UIRouter.popScreen(rootNavigator: true);
          await serviceLocator<AppNetworkProvider>()
              .deleteClass(classId: classToEdit.id!);
          classes.remove(classToEdit);
          notifyListeners();
          EasyLoading.dismiss(animation: true);
        },
        deleteMessage:
            "${AppLocale.areYouSureYouWantToDelete.getString(UIRouter.getCurrentContext()).capitalizeFirstLetter()} ${AppLocale.classVar.getString(UIRouter.getCurrentContext()).toLowerCase()}${AppLocale.questionMark.getString(UIRouter.getCurrentContext())}",
        dangerAdviceText: AppLocale
            .deletingTheClassWillPermanentlyeraseAllStudentDataAssociated
            .getString(UIRouter.getCurrentContext())
            .capitalizeFirstLetter(),
      ),
    );
  }

  Future<void> onAddNewClass() async {
    var addedClass = await UIRouter.pushScreen(
      ClassForm(model: ClassFormVM()),
      pageName: AppAnalyticsConstants.ClassFormScreen,
    );

    if (addedClass != null) {
      classes = [...classes, addedClass];
      notifyListeners();
    }
  }

  ClassesScreenVM() {
    getClassesList();
  }
}
