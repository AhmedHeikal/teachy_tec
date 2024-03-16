// // 17-11-2023
// // Besmillah .. In the name of Allah we start
import 'dart:async';
import 'dart:ui';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teachy_tec/firebase_options.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/screens/MainScaffold.dart';
import 'package:teachy_tec/screens/MainScaffoldVM.dart';
import 'package:teachy_tec/styles/AppColors.dart';
import 'package:teachy_tec/utils/Routing/TabItem.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';

Future<void> main() async {
  BindingBase.debugZoneErrorsAreFatal = false;
  // runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final _ = await setupServiceLocator();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
  // FirebaseCrashlytics.instance.crash();
  // }, (error, stackTrace) {
  //   // Handle the error
  //   print('Zone Error: $error');
  //   showErrorNotification(
  //       errorText: error.toString(), stackTrace: stackTrace.toString());
  // });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()?.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      serviceLocator<UIRouter>().tabItem = TabItem.home;

      key = UniqueKey();
      UIRouter.mainNavigatorKey = GlobalKey<NavigatorState>();
      UIRouter.navigatorKeys
          .updateAll((key, value) => value = GlobalKey<NavigatorState>());
    });
  }

  @override
  void initState() {
    debugPrint(
        'Heikal - current userID ${serviceLocator<FirebaseAuth>().currentUser?.uid}');
    serviceLocator<FlutterLocalization>().init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.en,
          countryCode: 'US',
          fontFamily: 'Sora',
        ),
        const MapLocale(
          'ar',
          AppLocale.ar,
          countryCode: 'PS',
          fontFamily: 'Marhey',
        ),
      ],
      initLanguageCode: 'en',
    );
    serviceLocator<FlutterLocalization>().onTranslatedLanguage =
        _onTranslatedLanguage;

    // FlutterError.onError = (FlutterErrorDetails details) {
    //   // Handle the error
    //   print('Flutter Error: ${details.exception}');

    //   showErrorNotification(errorText: details.exception.toString());
    // };
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    // setState(() {
    restartApp();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: serviceLocator<UIRouter>(),
        ),
      ],
      child: MaterialApp(
        key: key,
        navigatorKey: UIRouter.mainNavigatorKey,
        locale: serviceLocator<FlutterLocalization>().currentLocale,
        supportedLocales:
            serviceLocator<FlutterLocalization>().supportedLocales,
        localizationsDelegates: [
          ...serviceLocator<FlutterLocalization>().localizationsDelegates,
          RefreshLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          fontFamily: serviceLocator<FlutterLocalization>().fontFamily,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          scaffoldBackgroundColor: AppColors.appBackgroundColor,
          inputDecorationTheme: const InputDecorationTheme(
            isDense: true,
          ),
        ),
        home: AnimatedSplashScreen.withScreenFunction(
          splash: Stack(
            children: [
              Align(
                child: SvgPicture.asset('assets/svg/logo.svg', height: 250),
              ),
            ],
          ),
          backgroundColor: AppColors.primary100.withOpacity(0.2),
          splashIconSize: double.infinity,
          pageTransitionType: PageTransitionType.bottomToTop,
          splashTransition: SplashTransition.fadeTransition,
          duration: 1000,
          animationDuration: const Duration(milliseconds: 1000),
          curve: Curves.decelerate,
          screenFunction: () async {
            UIRouter.configureEasyLoader();

            return Scaffold(
              backgroundColor: AppColors.appBackgroundColor,
              resizeToAvoidBottomInset: false,
              body: ColorfulSafeArea(
                bottom: false,
                overflowRules: const OverflowRules.all(true),
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                color: AppColors.appBackgroundColor.withOpacity(0.3),
                child: MainScaffold(
                  model: MainScaffoldVM(),
                ),
              ),
            );
          },
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}
