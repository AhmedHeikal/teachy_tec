import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:teachy_tec/Services/hiveStore.dart';
import 'package:teachy_tec/hive/injector/hiveInjector.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/UIRouter.dart';

GetIt serviceLocator = GetIt.instance;

Future setupServiceLocator() async {
  serviceLocator.registerSingletonAsync<UIRouter>(() async {
    final object = UIRouter();
    return object;
  });

  serviceLocator.registerSingletonAsync<FlutterLocalization>(() async {
    final object = FlutterLocalization.instance;
    return object;
  });

  serviceLocator.registerSingletonAsync<FirebaseFirestore>(() async {
    final object = FirebaseFirestore.instance;
    return object;
  });

  serviceLocator.registerSingletonAsync<FirebaseAuth>(() async {
    final object = FirebaseAuth.instance;
    return object;
  });

  serviceLocator.registerSingletonAsync<AppNetworkProvider>(() async {
    final object = AppNetworkProvider();
    return object;
  }, dependsOn: [FirebaseFirestore, FirebaseAuth]);

  // serviceLocator.registerSingletonAsync<ConnectionStatusSingleton>(() async {
  //   final object = ConnectionStatusSingleton.getInstance();
  //   object.initialize();
  //   return object;
  // });

  serviceLocator.registerSingletonAsync<Store>(() async {
    await HiveInjector.setup();
    final object = Store();
    return object;
  });

  // serviceLocator.registerSingletonAsync<TomatoNetworkProvider>(() async {
  //   final object = TomatoNetworkProvider();
  //   await object.init();
  //   return object;
  // }, dependsOn: [LocalStorage]);

  // serviceLocator.registerSingletonAsync<ConnectionStatusSingleton>(() async {
  //   final object = ConnectionStatusSingleton.getInstance();
  //   object.initialize();
  //   return object;
  // }, dependsOn: [TomatoNetworkProvider]);

  // serviceLocator.registerSingletonAsync<AnalyticsService>(
  //   () async {
  //     final object = AnalyticsService();
  //     return object;
  //   },
  // );

  // serviceLocator.registerSingletonAsync<VideoCache>(() async {
  //   final object = VideoCache(8);
  //   return object;
  // });

  // serviceLocator.registerSingletonAsync<TomatoNotificationsService>(() async {
  //   final object = TomatoNotificationsService();
  //   await object.init();
  //   return object;
  // }, dependsOn: [
  //   UIRouter,
  //   TomatoNetworkProvider,
  // ]);

  await serviceLocator.allReady();

  return;
}

// Future updateActiveUser(SignInViewModel userModel) async {
//   await serviceLocator<LocalStorage>()
//       .updateSignedInUser(userModel, FileMode.writeOnly);
//   return;
// }

// Future setupActiveUser(SignInViewModel userModel,
//     {BuildContext? context}) async {
//   // await userModel.getRestuarants();

//   if (userModel.restaurantId == null) {
//     UIRouter.RestartApp(context: context);
//   }

//   serviceLocator<TomatoPermissionsManager>()
//       .setPermissions(userModel.permissions);

//   if (serviceLocator.isRegistered<SignInViewModel>()) {
//     serviceLocator.unregister<SignInViewModel>();
//   }

//   serviceLocator.registerSingleton<SignInViewModel>(userModel);

//   await serviceLocator<LocalStorage>()
//       .updateSignedInUser(userModel, FileMode.writeOnly);
//   AnalyticsService.setUserProperties(userModel: userModel);

//   // var currentUser = await serviceLocator<LocalStorage>().getSignedInUser();
//   // await serviceLocator<TomatoNetworkProvider>()
//   //     .EnablePushNotificationsForDevice();
//   return;
// }
