import 'package:flutter/material.dart';
import 'package:teachy_tec/models/AppConfiguration.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

class MainScaffoldVM extends ChangeNotifier {
  BuildContext? currentContext;

  AppConfiguration? currentUserAppConfiguration;

  void setCurrentContext(BuildContext currentContext) {
    this.currentContext = currentContext;
  }

  getCurrentUserAppConfiguration() async {
    currentUserAppConfiguration =
        await serviceLocator<AppNetworkProvider>().getAppConfiguration();
    notifyListeners();
  }
}
