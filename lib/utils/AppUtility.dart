import 'dart:math';
import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:teachy_tec/AbstractClasses/EntityWithImage.dart';
import 'package:teachy_tec/localization/Applocalization.dart';
import 'package:teachy_tec/models/MediaFile/MediaFileViewModel.dart';
import 'package:teachy_tec/screens/networking/AppNetworkProvider.dart';
import 'package:teachy_tec/utils/AppEnums.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
// import 'package:intl/intl.dart';
// import 'package:teachy_tec/utils/AppEnums.dart';

// import 'package:teachy_tec/utils/serviceLocator.dart';

class AppUtility {
  static int decimalPointForCurrency = 2;

  static bool convertStringToBool(String stringValue) {
    return stringValue.toLowerCase() == 'true';
  }

  static String localizedDateYMD(DateTime dateTime, {String? localeName}) {
    if (localeName != null) {
      return DateFormat.yMd(
        // localeName,
        serviceLocator<FlutterLocalization>().currentLocale!.countryCode,
      ).format(dateTime);
    }
    return DateFormat.yMd(
            serviceLocator<FlutterLocalization>().currentLocale!.toString())
        .format(dateTime);
  }

  static String parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    final String parsedString =
        parser.parse(document.body?.text).documentElement?.text ?? '';

    return parsedString;
  }

  static bool isHTMLEditorEmpty(String htmlString) {
    final document = parser.parse(htmlString);
    final String parsedString =
        parser.parse(document.body?.text).documentElement?.text ?? '';
    if (parsedString.isNotEmpty ||
        htmlString.contains('img') ||
        htmlString.contains('video')) return false;
    return true;
  }

  static String localizedCurrency(double amount,
      {String? localeName, bool? showCurrencySymbol}) {
    if (localeName != null) {
      return (showCurrencySymbol ?? true)
          ? NumberFormat.simpleCurrency(
                  locale: localeName, decimalDigits: decimalPointForCurrency)
              .format(amount)
          : NumberFormat.currency(
                  locale: localeName, decimalDigits: decimalPointForCurrency)
              .format(amount);
    }
    return (showCurrencySymbol ?? true)
        ? NumberFormat.simpleCurrency(
                locale: serviceLocator<FlutterLocalization>()
                    .currentLocale!
                    .toString(),
                decimalDigits: decimalPointForCurrency)
            .format(amount)
        : NumberFormat.currency(
                locale: serviceLocator<FlutterLocalization>()
                    .currentLocale!
                    .toString(),
                decimalDigits: decimalPointForCurrency)
            .format(amount);
  }

  static String capitalizeAllWord(String value) {
    if (value.trim().isEmpty) return "";
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  static Future loadHigherQualityMediaOfEntityWithMedia(
      {required EntityWithMedia model,
      int? height,
      int? width,
      required List<MediaFileViewModel> mediaFiles,
      required ValueNotifier<MapEntry<String, bool>> currentMediaFileString,
      Function(bool)? isLoadingCallback}) async {
    // to prevent further loading if current Media File got notified but didn't change
    var oldCurrentMediaFile = currentMediaFileString.value.key;

    // to prevent furhter API calls if it's already being loaded (it can happen that two calls are adaded in the same time)
    // -> if you want to prevent it completely add the loaded file to this list before initiating the call
    List<String> requestedMediaFiles = [];

    // Checking if to enter the function or not .. if all media files are already loaded in higher quality
    if (mediaFiles.isNotEmpty &&
        (model.loadedHeight == null ||
            ((height ?? 2000) > (model.loadedHeight!)))) {
      // intermediate variables so that if the calls failed the original height in the model doesn't change
      var toBeloadedHeight = height ?? 2000;
      var toBeloadedWidth = width ?? 2000;

      // Add the sequence to load the files .. we start with the currently opened media file and add the nearest media files from left and right
      // so if selected media file index is 3 .. this list will be (3,4,2,5,1,6,0)
      List<String> toBeloadedMediaFiles = [];

      int currentIndexInImages = mediaFiles.indexWhere(
          (element) => element.fileName == currentMediaFileString.value.key);

      toBeloadedMediaFiles.add(currentMediaFileString.value.key);

      for (int i = 0; i < mediaFiles.length; i++) {
        if (currentIndexInImages + i < mediaFiles.length) {
          toBeloadedMediaFiles
              .add(mediaFiles[currentIndexInImages + i].fileName!);
        }
        if (currentIndexInImages - i >= 0) {
          toBeloadedMediaFiles
              .add(mediaFiles[currentIndexInImages - i].fileName!);
        }
      }

      // Loading single Image
      Future loadSingleMedia(MediaFileViewModel file) async {
        if (requestedMediaFiles
                .any((requestedFile) => requestedFile == file.fileName) ||
            (model.loadedMediaFilesWithHeightAndWidthAttributes[file.fileName]
                        ?.keys.first ==
                    toBeloadedHeight &&
                model
                        .loadedMediaFilesWithHeightAndWidthAttributes[
                            file.fileName]
                        ?.values
                        .first ==
                    toBeloadedWidth)) {
          if (currentMediaFileString.value.key == file.fileName &&
              currentMediaFileString.value.value == false) {
            currentMediaFileString.value =
                MapEntry(currentMediaFileString.value.key, true);
            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
            currentMediaFileString.notifyListeners();
          }
          return;
        }

        if (!file.mimeType!.contains("video")) {
          requestedMediaFiles.add(file.fileName ?? '');

          var result = await serviceLocator<AppNetworkProvider>().GetImage(
              imageId: file.fileName,
              height: toBeloadedHeight,
              width: toBeloadedWidth);

          if (result != null) {
            model.mediaEntityList ??= {};

            var currentIndex = model.mediaEntityList?.entries
                .toList()
                .indexWhere((currentSavedElements) =>
                    currentSavedElements.key.name == file.fileName);
            if (currentIndex != null && currentIndex != -1) {
              model.mediaEntityList
                  ?.removeWhere((key, value) => key.name == file.fileName);

              model.loadedMediaFilesWithHeightAndWidthAttributes
                  .removeWhere((key, value) => key == file.fileName);

              List<MapEntry<PlatformFile, String?>> entries =
                  model.mediaEntityList!.entries.toList();
              entries.insert(
                currentIndex,
                MapEntry<PlatformFile, String?>(
                  PlatformFile(
                    name: file.fileName ?? '',
                    size: result.elementSizeInBytes,
                    bytes: result,
                  ),
                  null,
                ),
              );

              model.mediaEntityList =
                  Map<PlatformFile, String?>.fromEntries(entries);

              model.loadedMediaFilesWithHeightAndWidthAttributes.addAll({
                file.fileName ?? '': {toBeloadedHeight: toBeloadedWidth}
              });
            } else {
              model.mediaEntityList!.addAll({
                PlatformFile(
                  name: file.fileName ?? '',
                  size: result.elementSizeInBytes,
                  bytes: result,
                ): null,
              });
              model.loadedMediaFilesWithHeightAndWidthAttributes.addAll({
                file.fileName ?? '': {toBeloadedHeight: toBeloadedWidth}
              });
            }

            // model.mediaEntityList
            //     ?.removeWhere((key, value) => key.name == file.fileName);
            // model.loadedHeight = toBeloadedHeight;
            // model.loadedWidth = toBeloadedWidth;

            // model.mediaEntityList!.addAll({
            //   PlatformFile(
            //     name: file.fileName ?? '',
            //     size: result.elementSizeInBytes,
            //     bytes: result,
            //   ): null
            // });
            // Notify Listeners when the first image is looded to show image faster
            // And check if the images list are large to not call notify listeners many times
            // if (loopCounter == 1 && mediaFiles.length > 2)

            if (currentMediaFileString.value.key == file.fileName) {
              currentMediaFileString.value =
                  MapEntry(currentMediaFileString.value.key, true);
              // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
              currentMediaFileString.notifyListeners();
            }
            model.notifyListenersOverriden();
          }
        } else if (file.thumbnail != null) {
          requestedMediaFiles.add(file.fileName ?? '');

          var result = await serviceLocator<AppNetworkProvider>().GetImage(
            imageId: file.thumbnail!.fileName,
            height: toBeloadedHeight,
            width: toBeloadedWidth,
          );
          // loopCounter++;
          if (result != null) {
            model.mediaEntityList ??= {};

            model.loadedHeight = toBeloadedHeight;
            model.loadedWidth = toBeloadedWidth;
            var currentIndex = model.mediaEntityList?.entries
                .toList()
                .indexWhere((currentSavedElements) =>
                    currentSavedElements.key.name == file.fileName);
            if (currentIndex != null && currentIndex != -1) {
              model.mediaEntityList
                  ?.removeWhere((key, value) => key.name == file.fileName);
              model.loadedMediaFilesWithHeightAndWidthAttributes
                  .removeWhere((key, value) => key == file.fileName);
              List<MapEntry<PlatformFile, String?>> entries =
                  model.mediaEntityList!.entries.toList();
              entries.insert(
                currentIndex,
                MapEntry<PlatformFile, String?>(
                  PlatformFile(
                    name: file.fileName ?? '',
                    size: result.elementSizeInBytes,
                    bytes: result,
                  ),
                  file.fileName,
                ),
              );

              model.mediaEntityList =
                  Map<PlatformFile, String?>.fromEntries(entries);

              // model.mediaEntityList!.entries.toList().insert(
              //     currentIndex,
              //     MapEntry(
              //         PlatformFile(
              //           name: file.fileName ?? '',
              //           size: result.elementSizeInBytes,
              //           bytes: result,
              //         ),
              //         file.fileName));

              model.loadedMediaFilesWithHeightAndWidthAttributes.addAll({
                file.fileName ?? '': {toBeloadedHeight: toBeloadedWidth}
              });
            } else {
              model.mediaEntityList!.addAll({
                PlatformFile(
                  name: file.fileName ?? '',
                  size: result.elementSizeInBytes,
                  bytes: result,
                ): file.fileName,
              });
              model.loadedMediaFilesWithHeightAndWidthAttributes.addAll({
                file.fileName ?? '': {toBeloadedHeight: toBeloadedWidth}
              });
            }

            // model.mediaEntityList
            //     ?.removeWhere((key, value) => key.name == file.fileName);
            // model.loadedHeight = toBeloadedHeight;
            // model.loadedWidth = toBeloadedWidth;

            // model.mediaEntityList!.addAll({
            //   PlatformFile(
            //     name: file.fileName ?? '',
            //     size: result.elementSizeInBytes,
            //     bytes: result,
            //   ): file.fileName
            // });

            // Notify Listeners when the first image is looded to show image faster
            // And check if the images list are large to not call notify listeners many times
            // if (loopCounter == 1 && mediaFiles.length > 2)

            if (currentMediaFileString.value.key == file.fileName) {
              currentMediaFileString.value =
                  MapEntry(currentMediaFileString.value.key, true);
              // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
              currentMediaFileString.notifyListeners();
            }
            model.notifyListenersOverriden();
          }
        }

        // var result = await serviceLocator<TomatoNetworkProvider>().GetImage(
        //   imageId: fileName,
        //   height: toBeloadedHeight,
        //   width: toBeloadedWidth,
        // );

        // requestedMediaFiles.add(fileName);

        // if (result != null) {
        //   if (model.mediaEntityList == null) {
        //     model.mediaEntityList = [];
        //   }
        //   var currentIndex = model.mediaEntityList?.indexWhere(
        //       (currentSavedElements) => currentSavedElements.name == fileName);
        //   if (currentIndex != null && currentIndex != -1) {
        //     model.mediaEntityList?.removeAt(currentIndex);
        //     model.loadedMediaFilesWithHeightAndWidthAttributes
        //         .removeWhere((key, value) => key == fileName);

        //     model.mediaEntityList!.insert(
        //       currentIndex,
        //       PlatformFile(
        //         name: fileName,
        //         size: result.elementSizeInBytes,
        //         bytes: result,
        //       ),
        //     );

        //     model.loadedMediaFilesWithHeightAndWidthAttributes.addAll({
        //       fileName: {toBeloadedHeight: toBeloadedWidth}
        //     });
        //   } else {
        //     model.mediaEntityList!.add(
        //       PlatformFile(
        //         name: fileName,
        //         size: result.elementSizeInBytes,
        //         bytes: result,
        //       ),
        //     );
        //     model.loadedMediaFilesWithHeightAndWidthAttributes.addAll({
        //       fileName: {toBeloadedHeight: toBeloadedWidth}
        //     });
        //   }

        //   // loadedMediaFiles[fileName] = true;
        //   if (currentMediaFileString.value.key == fileName) {
        //     currentMediaFileString.value =
        //         MapEntry(currentMediaFileString.value.key, true);
        //     currentMediaFileString.notifyListeners();
        //   }
        //   model.notifyListenersOverriden();
        // }
      }

      // Listener for the currentMediaFileString
      // to track the current image and load it directly
      currentMediaFileString.addListener(() async {
        // If this is same file then return
        if (currentMediaFileString.value.key == oldCurrentMediaFile) {
          return;
        } else {
          oldCurrentMediaFile = currentMediaFileString.value.key;
        }
        await loadSingleMedia(mediaFiles.firstWhere(
            (element) => element.fileName == currentMediaFileString.value.key));
      });

      // loading the normal reordered list
      await Future.forEach(
        toBeloadedMediaFiles,
        (String fileName) async {
          try {
            await loadSingleMedia(mediaFiles
                .firstWhere((element) => element.fileName == fileName));
          } catch (error) {
            FirebaseCrashlytics.instance.recordError(error, null,
                fatal: false,
                reason:
                    "Heikal - loadSingleMedia in AppUtility \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
          }
        },
      ).then((value) {
        // setting the model loaded height and width
        model.loadedHeight = height ?? 2000;
        model.loadedWidth = width ?? 2000;
        // notify the listener one more time

        // setting the currentMediaFile to be already loaded
        if (!currentMediaFileString.value.value) {
          currentMediaFileString.value =
              MapEntry(currentMediaFileString.value.key, true);
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          currentMediaFileString.notifyListeners();
        }
        model.notifyListenersOverriden();
      });
      model.isLoadedBefore = true;
    } else {
      // setting the currentMediaFile to be already loaded
      currentMediaFileString.value =
          MapEntry(currentMediaFileString.value.key, true);
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      currentMediaFileString.notifyListeners();
    }
  }

  static Future loadNormalMediaOfEntityWithMedia(
      {required EntityWithMedia model,
      int? height,
      int? width,
      required List<MediaFileViewModel> mediaFiles,
      Function(bool)? isLoadingCallback}) async {
    int loopCounter = 0;
    if (mediaFiles.isNotEmpty && !model.isLoadedBefore) {
      model.isLoadedBefore = true;
      var toBeLoadedHeight = height ?? 580;
      var toBeLoadedWidth = width ?? 370;
      Future.forEach(
        mediaFiles,
        (MediaFileViewModel element) async {
          try {
            if (!element.mimeType!.contains("video")) {
              var result = await serviceLocator<AppNetworkProvider>().GetImage(
                imageId: element.fileName,
                height: toBeLoadedHeight,
                width: toBeLoadedWidth,
              );
              loopCounter++;

              if (result != null) {
                model.mediaEntityList ??= {};

                model.mediaEntityList
                    ?.removeWhere((key, value) => key.name == element.fileName);
                model.loadedMediaFilesWithHeightAndWidthAttributes
                    .removeWhere((key, value) => key == element.fileName);

                model.loadedHeight = toBeLoadedHeight;
                model.loadedWidth = toBeLoadedWidth;

                model.mediaEntityList!.addAll({
                  PlatformFile(
                    name: element.fileName ?? '',
                    size: result.elementSizeInBytes,
                    bytes: result,
                  ): null
                });

                model.loadedMediaFilesWithHeightAndWidthAttributes.addAll({
                  element.fileName ?? '': {
                    model.loadedHeight!: model.loadedWidth!
                  }
                });
                // Notify Listeners when the first image is looded to show image faster
                // And check if the images list are large to not call notify listeners many times
                if (loopCounter == 1 && mediaFiles.length > 2) {
                  model.notifyListenersOverriden();
                }
              }
            } else if (element.thumbnail != null) {
              var result = await serviceLocator<AppNetworkProvider>().GetImage(
                  imageId: element.thumbnail!.fileName,
                  height: toBeLoadedHeight,
                  width: toBeLoadedWidth);
              loopCounter++;
              if (result != null) {
                model.mediaEntityList ??= {};

                model.loadedHeight = toBeLoadedHeight;
                model.loadedWidth = toBeLoadedWidth;

                model.mediaEntityList
                    ?.removeWhere((key, value) => key.name == element.fileName);
                model.loadedMediaFilesWithHeightAndWidthAttributes
                    .removeWhere((key, value) => key == element.fileName);

                model.loadedHeight = toBeLoadedHeight;
                model.loadedWidth = toBeLoadedWidth;

                model.mediaEntityList!.addAll({
                  PlatformFile(
                    name: element.fileName ?? '',
                    size: result.elementSizeInBytes,
                    bytes: result,
                  ): element.fileName
                });

                model.loadedMediaFilesWithHeightAndWidthAttributes.addAll({
                  element.fileName ?? '': {
                    model.loadedHeight!: model.loadedWidth!
                  }
                });
                // Notify Listeners when the first image is looded to show image faster
                // And check if the images list are large to not call notify listeners many times
                if (loopCounter == 1 && mediaFiles.length > 2)
                  model.notifyListenersOverriden();
              }
            }
          } catch (error) {
            FirebaseCrashlytics.instance.recordError(error, null,
                fatal: false,
                reason:
                    "Heikal - loadNormalMediaOfEntityWithMedia in AppUtility \ncurrentUID ${serviceLocator<FirebaseAuth>().currentUser?.uid} ");
          }
        },
      ).then(
        (value) => model.notifyListenersOverriden(),
      );
      model.isLoadedBefore = true;
    }
  }

  static num doubleWithoutDecimalToInt(num val) {
    return val % 1 == 0 ? val.toInt() : val;
  }

  static String getNumberRank(int number) {
    if (number == 1) {
      return '1st';
    } else if (number == 2) {
      return '2nd';
    } else if (number == 3) {
      return '3rd';
    } else {
      return '${number}th';
    }
  }

  static String getLanguageString(String language) {
    switch (language) {
      case 'ru':
        return 'Русский 🇷🇺';
      case 'uk':
        return 'Українська 🇺🇦';
      case 'ar':
        return '🇵🇸 عربي';
      default:
        return 'English 🇺🇸';
    }
  }

  static SupportedLocales getLocalLanguageEnum(String language) {
    switch (language) {
      case 'ar':
        return SupportedLocales.ar;
      default:
        return SupportedLocales.en;
    }
  }

  static ui.TextDirection getTextDirectionality() {
    debugPrint(
        'Heikal - directionality serviceLocator<FlutterLocalization>().currentLocale ${serviceLocator<FlutterLocalization>().currentLocale}');

    if (serviceLocator<FlutterLocalization>()
            .currentLocale!
            .languageCode
            .trim()
            .toLowerCase() ==
        "ar".trim().toLowerCase()) return ui.TextDirection.rtl;
    return ui.TextDirection.ltr;
  }

  static bool isDirectionalitionalityLTR() {
    debugPrint(
        'Heikal - directionality serviceLocator<FlutterLocalization>().currentLocale ${serviceLocator<FlutterLocalization>().currentLocale!.languageCode}');
    if (serviceLocator<FlutterLocalization>()
        .currentLocale!
        .languageCode
        .trim()
        .toLowerCase()
        .contains("ar".trim().toLowerCase())) return false;
    return true;
  }

  static String getArrowAssetLocalized({bool rightArrowInLTR = true}) {
    return rightArrowInLTR
        ? isDirectionalitionalityLTR()
            ? "assets/svg/ArrowLeft.svg"
            : "assets/svg/ArrowRight.svg"
        : isDirectionalitionalityLTR()
            ? "assets/svg/ArrowRight.svg"
            : "assets/svg/ArrowLeft.svg";
  }

  static String getDayNameFromDateTime(DateTime day) {
    return DateFormat('EEEE',
            serviceLocator<FlutterLocalization>().currentLocale!.languageCode)
        .format(day);
  }
  // static String getDayName(WeekDays day) {
  //   switch (day) {
  //     case WeekDays.Monday:
  //       return AppLocalizations.of(UIRouter.getCurrentContext())
  //           .mondayFullWord
  //           .capitalizeFirstLetter();

  //     case WeekDays.Tuesday:
  //       return AppLocalizations.of(UIRouter.getCurrentContext())
  //           .tuesdayFullWord
  //           .capitalizeFirstLetter();

  //     case WeekDays.Wednesday:
  //       return AppLocalizations.of(UIRouter.getCurrentContext())
  //           .wednesdayFullWord
  //           .capitalizeFirstLetter();
  //     case WeekDays.Thursday:
  //       return AppLocalizations.of(UIRouter.getCurrentContext())
  //           .thursdayFullWord
  //           .capitalizeFirstLetter();
  //     case WeekDays.Friday:
  //       return AppLocalizations.of(UIRouter.getCurrentContext())
  //           .fridayFullWord
  //           .capitalizeFirstLetter();
  //     //  break;
  //     case WeekDays.Saturday:
  //       return AppLocalizations.of(UIRouter.getCurrentContext())
  //           .saturdayFullWord
  //           .capitalizeFirstLetter();
  //     case WeekDays.Sunday:
  //       return AppLocalizations.of(UIRouter.getCurrentContext())
  //           .sundayFullWord
  //           .capitalizeFirstLetter();
  //   }
  // }

  static int getLocalTimeFromSeconds(int utcInSeconds) {
    var localSeconds =
        utcInSeconds; /*  + DateTime.now().timeZoneOffset.inSeconds; */
    localSeconds = (localSeconds) > 86400 ? localSeconds - 86400 : localSeconds;
    return localSeconds;
  }

  static String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  static DateTime removeTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static T selectRandomItem<T>(List<T> list) {
    Random random = Random();
    int randomIndex = random.nextInt(list.length);
    return list[randomIndex];
  }

  static String getAMPMTimeFromSeconds(int seconds, {bool inUtc = true}) {
    // seconds =
    //     inUtc ? seconds : (seconds + DateTime.now().timeZoneOffset.inSeconds);
    var newDateTime = inUtc
        ? DateTime.utc(0, 0, 0, 0, 0, seconds)
        : DateTime.utc(
            0, 0, 0, 0, 0, seconds + DateTime.now().timeZoneOffset.inSeconds);
    return DateFormat('hh:mm a',
            serviceLocator<FlutterLocalization>().currentLocale!.languageCode)
        .format(newDateTime)
        .toString();
    // var min = (seconds % 3600) ~/ 60;
    // var hours = seconds ~/ 3600;
    // String timeType = hours >= 12 ? 'PM' : 'AM';
    // hours = hours > 12 ? hours - 12 : hours;
    // hours = hours == 0 ? 12 : hours;

    // return '${hours.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $timeType';
  }

  static String getTwentyFourTimeFromSeconds(int seconds, {bool inUtc = true}) {
    // seconds = 3600;
    // var current = 4 * -3600;
    // var curretn = DateTime.now();
    var newDateTime = inUtc
        ? DateTime.utc(0, 0, 0, 0, 0, seconds)
        : DateTime(
            0, 0, 0, 0, 0, seconds + DateTime.now().timeZoneOffset.inSeconds);
    return DateFormat('HH:mm',
            serviceLocator<FlutterLocalization>().currentLocale!.languageCode)
        .format(newDateTime)
        .toString();
    // seconds =
    //     inUtc ? seconds : (seconds + DateTime.now().timeZoneOffset.inSeconds);
    // var min = (seconds % 3600) ~/ 60;
    // var hours = seconds ~/ 3600;
    // if (hours > 24) {
    //   hours = hours % 24;
    // }
    // String timeType = hours >= 12 ? 'PM' : 'AM';
    // hours = hours > 12 ? hours - 12 : hours;
    // hours = hours == 0 ? 12 : hours;
    // return '${newDateTime.hour.toString().padLeft(2, '0')}:${newDateTime.minute.toString().padLeft(2, '0')}';
    // if (inUtc)
    // // return '${hours.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    // else {
    //   // var date = DateTime.utc(0, 0, 0, hours, min).toLocal();
    //   return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    // }
  }

  static int getMillisecondsSinceEpoch(DateTime date,
      {bool addTimeOffset = false}) {
    // return date.add(date.timeZoneOffset).millisecondsSinceEpoch;
    return date
        .add(addTimeOffset ? date.timeZoneOffset : Duration())
        .millisecondsSinceEpoch;
  }

  // static String getMMHHFromDuration(Duration dur) {
  //   bool inHours = dur.inHours > 0;

  //   var value = inHours
  //       ? AppLocalizations.of(UIRouter.getCurrentContext())
  //           .hoursShortcut
  //           .toLowerCase()
  //       : AppLocalizations.of(UIRouter.getCurrentContext())
  //           .minutesShortcut
  //           .toLowerCase();

  //   return '${dur.inHours.toString().padLeft(2, '0')}:${dur.inMinutes.remainder(60).toString().padLeft(2, '0')} $value';
  // }

  // static String getSMMHHFromSeconds(int seconds) {
  //   var value = seconds ~/ 3600 > 0
  //       ? AppLocalizations.of(UIRouter.getCurrentContext())
  //           .hoursShortcut
  //           .toLowerCase()
  //       // 'h'
  //       : ((seconds % 3600) ~/ 60) > 0
  //           ? AppLocalizations.of(UIRouter.getCurrentContext())
  //               .minutesShortcut
  //               .toLowerCase()
  //           // 'min'
  //           : AppLocalizations.of(UIRouter.getCurrentContext())
  //               .secondShortcut
  //               .toLowerCase() /* 'sec' */;
  //   var hoursValue = (seconds ~/ 3600);
  //   var minsValue = (seconds % 3600) ~/ 60;
  //   var secondsValue = (seconds % 60);

  //   String hoursString = '';
  //   // if (seconds ~/ 3600 > 0) {
  //   hoursString = hoursValue.toString().padLeft(2, '0');
  //   // }

  //   String minsString = '';
  //   // if (((seconds % 3600) ~/ 60) > 0 || ((seconds % 60) > 0)) {
  //   minsString = minsValue.toString().padLeft(2, '0');
  //   // }
  //   String secondsString = '';
  //   // if ((seconds % 60) > 0) {
  //   secondsString = (secondsValue.toString().padLeft(2, '0'));
  //   // }

  //   if (value ==
  //       AppLocalizations.of(UIRouter.getCurrentContext())
  //           .hoursShortcut
  //           .toLowerCase() /* 'h' */) {
  //     if (minsValue == 0 && secondsValue == 0)
  //       return hoursValue.toString() +
  //           " " +
  //           AppLocalizations.of(UIRouter.getCurrentContext())
  //               .hoursShortcut
  //               .toLowerCase() /* ' h' */;
  //     else if (secondsValue == 0) return '$hoursString:$minsString $value';
  //     return '$hoursString:$minsString:$secondsString $value';
  //   } else if (value ==
  //       AppLocalizations.of(UIRouter.getCurrentContext())
  //           .minutesShortcut
  //           .toLowerCase() /* 'min' */) {
  //     if (seconds == 0)
  //       return minsValue.toString() +
  //           " " +
  //           AppLocalizations.of(UIRouter.getCurrentContext())
  //               .minutesShortcut
  //               .toLowerCase() /*  ' min' */;
  //     return '$minsString:$secondsString $value';
  //   } else {
  //     return secondsValue.toString() +
  //         " " +
  //         AppLocalizations.of(UIRouter.getCurrentContext())
  //             .secondShortcut
  //             .toLowerCase() /* ' sec' */;
  //   }
  // }

//   static Future<void> logOutTapped(BuildContext context) async {
//     // serviceLocator<UIRouter>().tabItem = TabItem.Home;
//     await serviceLocator<TomatoNetworkProvider>().SignOut(context: context);
//     // serviceLocator<UIRouter>().tabIndex = 0;
// // serviceLocator<TomatoCachedResourceProvider>().un
//     // await UIRouter.popAllAndPushRoot(
//     //     context: context, pushDirection: PageTransitionType.leftToRight);
//     // await UIRouter.RestartApp(context: context);

//     // await UIRouter.popAllToSignInScreen();
//   }

  // static String getCurrentLocalizationtext() {
  //   if (widget.appLanguage.appLocal == Locale(SupportedLocales.ar.name)) {
  //     serviceLocator<AppLanguage>().appLocal.languageCode;
  //     // initializeDateFormattingCustom(locale: "ar");
  //     // initializeDateFormatting("en", null);
  //   } else if (widget.appLanguage.appLocal ==
  //       Locale(SupportedLocales.ru.name)) {
  //     // initializeDateFormattingCustom(locale: "ru");
  //     initializeDateFormatting("ru", null);
  //   } else if (widget.appLanguage.appLocal ==
  //       Locale(SupportedLocales.uk.name)) {
  //     // initializeDateFormattingCustom(locale: "uk");
  //     initializeDateFormatting("uk", null);
  //   } else if (widget.appLanguage.appLocal ==
  //       Locale(SupportedLocales.es.name)) {
  //     // initializeDateFormattingCustom(locale: "es");
  //     initializeDateFormatting("ar", null);
  //   } else {
  //     // initializeDateFormattingCustom(locale: "en");
  //     initializeDateFormatting("es", null);
  //   }
  // }

  static String getSMMHHFromSeconds(int seconds) {
    var value = seconds ~/ 3600 > 0
        ? AppLocale.hoursShortcut
            .getString(UIRouter.getCurrentContext())
            .toLowerCase()

        // 'h'
        : ((seconds % 3600) ~/ 60) > 0
            ? AppLocale.minutesShortcut
                .getString(UIRouter.getCurrentContext())
                .toLowerCase()
            : AppLocale.secondShortcut
                .getString(UIRouter.getCurrentContext())
                .toLowerCase();
    var hoursValue = (seconds ~/ 3600);
    var minsValue = (seconds % 3600) ~/ 60;
    var secondsValue = (seconds % 60);

    String hoursString = '';
    // if (seconds ~/ 3600 > 0) {
    hoursString = hoursValue.toString().padLeft(2, '0');
    // }

    String minsString = '';
    // if (((seconds % 3600) ~/ 60) > 0 || ((seconds % 60) > 0)) {
    minsString = minsValue.toString().padLeft(2, '0');
    // }
    String secondsString = '';
    // if ((seconds % 60) > 0) {
    secondsString = (secondsValue.toString().padLeft(2, '0'));
    // }

    if (value ==
        AppLocale.hoursShortcut
            .getString(UIRouter.getCurrentContext())
            .toLowerCase() /* 'h' */) {
      if (minsValue == 0 && secondsValue == 0) {
        return "$hoursValue ${AppLocale.hoursShortcut.getString(UIRouter.getCurrentContext()).toLowerCase()}" /* ' h' */;
      } else if (secondsValue == 0) {
        return '$hoursString:$minsString $value';
      }
      return '$hoursString:$minsString:$secondsString $value';
    } else if (value ==
        AppLocale.minutesShortcut
            .getString(UIRouter.getCurrentContext())
            .toLowerCase() /* 'min' */) {
      if (seconds == 0) {
        return "$minsValue ${AppLocale.minutesShortcut.getString(UIRouter.getCurrentContext()).toLowerCase()}" /*  ' min' */;
      }
      return '$minsString:$secondsString $value';
    } else {
      return "$secondsValue ${AppLocale.secondShortcut.getString(UIRouter.getCurrentContext()).toLowerCase()}" /* ' sec' */;
    }
  }

  static String getTimerTextFromSeconds(int seconds) {
    var hoursValue = (seconds ~/ 3600);
    var minsValue = (seconds % 3600) ~/ 60;
    var secondsValue = (seconds % 60);

    String hoursString = '';
    // if (seconds ~/ 3600 > 0) {
    hoursString = hoursValue.toString().padLeft(2, '0');
    // }

    String minsString = '';
    // if (((seconds % 3600) ~/ 60) > 0 || ((seconds % 60) > 0)) {
    minsString = minsValue.toString().padLeft(2, '0');
    // }
    String secondsString = '';
    // if ((seconds % 60) > 0) {
    secondsString = secondsValue.toString().padLeft(2, '0');
    // }

    if (hoursValue > 0) {
      return "$hoursString:$minsString:$secondsString" /* ' h' */;
    } else {
      return '$minsString:$secondsString';
    }
  }

  static String appTimeFormat(
    DateTime date, {
    bool showTime = false,
    BuildContext? context,
    bool isUTC = false,
    bool forceEnglish = false,
  }) {
    var is24HoursFormat = MediaQuery.of(context ?? UIRouter.getCurrentContext())
        .alwaysUse24HourFormat;

    if (!showTime) {
      return DateFormat(
              'MMM d, y',
              forceEnglish
                  ? 'en'
                  : serviceLocator<FlutterLocalization>()
                      .currentLocale!
                      .languageCode)
          .format(date)
          .toString();
    }

    if (showTime && is24HoursFormat) {
      return DateFormat(
              'MMM d, y HH:mm',
              forceEnglish
                  ? 'en'
                  : serviceLocator<FlutterLocalization>()
                      .currentLocale!
                      .languageCode)
          .format(date)
          .toString();
    }

    return DateFormat(
            'MMM d, y hh:mm a',
            forceEnglish
                ? 'en'
                : serviceLocator<FlutterLocalization>()
                    .currentLocale!
                    .languageCode)
        .format(date)
        .toString();
  }

  // static String getPublishedItemsTimeFormat(int min) {
  //   int hours = min ~/ 60;
  //   int mins = min % 60;
  //   if (hours == 0)
  //     return "$mins ${AppLocalizations.of(UIRouter.getCurrentContext()).minutesShortcut.toLowerCase()}";
  //   //  ${mins == 1 ? "min" : "mins"}
  //   return "$hours:${mins.toString().padLeft(2, '0')} ${AppLocalizations.of(UIRouter.getCurrentContext()).hoursShortcut.toLowerCase()}";

  //   // return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  // }

  // static String getDayTimeFromMS(int ms,
  //     {BuildContext? context,
  //     bool? is24TimeFormatByDefault,
  //     bool isUtc = false}) {
  //   DateTime dur = DateTime.fromMillisecondsSinceEpoch(
  //     ms,
  //     isUtc: isUtc,
  //   );

  //   return MediaQuery.of(context ?? UIRouter.getCurrentContext())
  //               .alwaysUse24HourFormat ||
  //           is24TimeFormatByDefault == true
  //       ? DateFormat(
  //               'HH:mm', serviceLocator<AppLanguage>().appLocal.languageCode)
  //           .format(dur)
  //       : DateFormat(
  //               'hh:mm a', serviceLocator<AppLanguage>().appLocal.languageCode)
  //           .format(dur);
  // }

  // static String getFullTimeFromMS(int ms,
  //     {BuildContext? context, bool isUtc = true}) {
  //   DateTime dur = DateTime.fromMillisecondsSinceEpoch(ms);
  //   return MediaQuery.of(context ?? UIRouter.getCurrentContext())
  //           .alwaysUse24HourFormat
  //       ? DateFormat('HH:mm dd MMM, yyyy',
  //               serviceLocator<AppLanguage>().appLocal.languageCode)
  //           .format(dur)
  //       : DateFormat('hh:mm a dd MMM, yyyy',
  //               serviceLocator<AppLanguage>().appLocal.languageCode)
  //           .format(dur);
  // }

// static String getRestaurantAddress(String address, String? address2, String? city, bool isUSA ){
//     if (/* selectedCountry?.code.toLowerCase() == 'USD'.toLowerCase() */isUSA)
//       return address +
//           ', ' +
//           (address2 != null && address2.trim().isNotEmpty ? address2 + ', ' : '') +
//           (city ?? '') ;

//     return address ;
//   }

// }

  static String getvideoDurationFromDuration(Duration dur) {
    String minutes =
        (dur.inHours * 60 + dur.inMinutes.remainder(60)).toString();
    String seconds = dur.inSeconds.remainder(60).toString();
    seconds = seconds.length == 1 ? "0$seconds" : seconds;
    return '$minutes:$seconds';
    // return '${dur.inHours.toString().padLeft(2, '0')}:${dur.inMinutes.remainder(60).toString().padLeft(2, '0')}';
  }

  static String formatedTimeFromSeconds(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(min.toString()) + ":" + getParsedTime(sec.toString());
    return parsedTime;
  }

  static Size getSize(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return Size(0, 0);
    // debugPrint('Heikal - Size of customized Widget ${box.size}');
    return box.size;
  }
}
