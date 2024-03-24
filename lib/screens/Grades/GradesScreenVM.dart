import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:teachy_tec/models/Schema.dart';
import 'package:teachy_tec/screens/Grades/GradesForm.dart';
import 'package:teachy_tec/screens/Grades/GradesFormVM.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/Routing/AppAnalyticsConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

class GradesScreenVM extends ChangeNotifier {
  bool isInitialized = false;
  List<Schema> schemas = [];
  GradesScreenVM() {
    getSchemasList();
  }

  Future<List<Schema>> getSchemasList() async {
    UIRouter.showEasyLoader();
    schemas = await serviceLocator<AppNetworkProvider>().getSchemasList() ?? [];
    isInitialized = true;
    EasyLoading.dismiss(animation: true);
    notifyListeners();

    return schemas;
  }

  Future<void> onAddNewSchema() async {
    /* var newActivity = */
    var newSchema = await UIRouter.pushScreen(GradesForm(model: GradesFormVM()),
        pageName: AppAnalyticsConstants.GradesForm);
    if (newSchema != null) {
      isInitialized = true;
      await getSchemasList();
    }
  }
}
