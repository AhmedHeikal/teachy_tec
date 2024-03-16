import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teachy_tec/Services/hiveStore.dart';
import 'package:teachy_tec/models/Activity.dart';
import 'package:teachy_tec/models/ActivityStudents.dart';
import 'package:teachy_tec/models/AppConfiguration.dart';
import 'package:teachy_tec/models/Class.dart';
import 'package:teachy_tec/models/CustomQuestionOptionModel.dart';
import 'package:teachy_tec/models/Student.dart';
import 'package:teachy_tec/models/Task.dart';
import 'package:teachy_tec/models/TaskViewModel.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
// import 'package:teachy_tec/widgets/showSpecificNotifications.dart';

class HiveInjector {
  static Future<void> setup() async {
    try {
      await Hive.initFlutter();
      _registerAdapters();
      if (serviceLocator<AppConfiguration>().resetCache) {
        await cleanHiveDatabaseLocally();
        var currentAppConfiguration = serviceLocator<AppConfiguration>();
        currentAppConfiguration.resetCache = false;
        await serviceLocator<AppNetworkProvider>()
            .UpdateAppConfiguration(currentAppConfiguration);
        await updateAppConfiguration(currentAppConfiguration);
      }
      await Hive.openBox(Store.activitiesBoxName);
      await Hive.openBox(Store.activityStudentsBoxName);
    } catch (e) {
      if (kDebugMode) {
        print('Heikal - Hive boxes didn\'t open');
      }
      // showErrorNotification(errorText: e.toString());
      await cleanHiveDatabaseLocally();
      await setup();
    }
  }

  static Future<void> cleanHiveDatabaseLocally() async {
    await Hive.deleteBoxFromDisk(Store.activitiesBoxName);
    await Hive.deleteBoxFromDisk(Store.activityStudentsBoxName);
  }

  static void _registerAdapters() {
    Hive.registerAdapter(ActivityAdapter());
    Hive.registerAdapter(StudentAdapter());
    Hive.registerAdapter(ClassAdapter());
    Hive.registerAdapter(GenderAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(AppConfigurationAdapter());
    Hive.registerAdapter(TaskViewModelAdapter());
    Hive.registerAdapter(TaskTypeAdapter());
    Hive.registerAdapter(ActivityStudentsAdapter());
    Hive.registerAdapter(CustomQuestionOptionModelAdapter());
  }
}
