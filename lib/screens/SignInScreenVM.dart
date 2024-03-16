import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
// import 'package:teachy_tec/widgets/showSpecificNotifications.dart';

class SignInScreenVM extends ChangeNotifier {
  Future<void> signUpByGmail() async {
    try {
      UIRouter.showEasyLoader();
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await signInWithCredentials(userCredential);
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null,
          fatal: false,
          reason: "Heikal - Sign up failed in SignInScreenVM in signupByGmail");
      // showErrorNotification(
      //   errorText: e.toString(),
      // );
      await EasyLoading.dismiss(animation: true);
    }
  }

  Future<void> signInWithCredentials(UserCredential credential) async {
    debugPrint(
        'Heikal - currentUser logged in ${credential.user?.displayName}');
    final newTeacher = <String, String?>{
      FirestoreConstants.name: credential.user?.displayName,
      FirestoreConstants.email: credential.user?.email,
    };

    final newAppConfiguration = <String, bool?>{
      FirestoreConstants.closeApp: false,
      FirestoreConstants.resetCache: false,
      FirestoreConstants.updateRequired: false,
    };

    await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.teachers)
        .doc(credential.user?.uid)
        .set(newTeacher)
        .onError((e, _) => debugPrint("Error writing document: $e"));

    await serviceLocator<FirebaseFirestore>()
        .collection(FirestoreConstants.applicationConfiguration)
        .doc(credential.user?.uid)
        .set(newAppConfiguration)
        .onError((e, _) => debugPrint("Error writing document: $e"));

    await EasyLoading.dismiss(animation: true);
    UIRouter.RestartApp();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signUpByApple() async {
    try {
      UIRouter.showEasyLoader();
      // final rawNonce = generateNonce();
      // final nonce = sha256ofString(rawNonce);
      // final appleCredential = await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      //   nonce: nonce,
      // );

      // final oauthCredential = OAuthProvider("apple.com").credential(
      //   idToken: appleCredential.identityToken,
      //   rawNonce: rawNonce,
      // );

      final appleProvider = AppleAuthProvider();
      UserCredential userCredentials =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);

      await signInWithCredentials(userCredentials);
      debugPrint('Heikal - currentUserCredentials in apple');
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null,
          fatal: false,
          reason:
              "Heikal - Sign up failed in SignInScreenVM in signupByApple ");
      await EasyLoading.dismiss(animation: true);
    }
  }
}
