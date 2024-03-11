import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teachy_tec/hive/injector/hiveInjector.dart';
import 'package:teachy_tec/utils/AppConstants.dart';
import 'package:teachy_tec/utils/UIRouter.dart';
import 'package:teachy_tec/utils/serviceLocator.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<UserCredential?> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  UserCredential user =
      await FirebaseAuth.instance.signInWithCredential(credential);

  debugPrint('Heikal - currentUser logged in ${user.user?.displayName}');
  final newTeacher = <String, String?>{
    FirestoreConstants.name: user.user?.displayName,
    FirestoreConstants.email: user.user?.email,
  };

  await serviceLocator<FirebaseFirestore>()
      .collection(FirestoreConstants.teachers)
      .doc(user.user?.uid)
      .set(newTeacher)
      .onError((e, _) => debugPrint("Error writing document: $e"));

  UIRouter.RestartApp();

  // Once signed in, return the UserCredential
  return user;
}

Future<void> deleteUserAccount() async {
  try {
    await FirebaseAuth.instance.currentUser!.delete();
  } on FirebaseAuthException catch (e) {
    debugPrint(e.toString());
    // log.e(e);

    if (e.code == "requires-recent-login") {
      await _reauthenticateAndDelete();
    } else {
      // Handle other Firebase exceptions
    }
  } catch (e) {
    debugPrint(e.toString());
    // Handle general exception
  } finally {
    await HiveInjector.cleanHiveDatabaseLocally();
    UIRouter.RestartApp();
  }
}

Future<void> _reauthenticateAndDelete() async {
  try {
    final providerData =
        serviceLocator<FirebaseAuth>().currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await serviceLocator<FirebaseAuth>()
          .currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await serviceLocator<FirebaseAuth>()
          .currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    }

    await serviceLocator<FirebaseAuth>().currentUser?.delete();
  } catch (e) {
    // Handle exceptions
  }
}

Future<UserCredential?> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  if (loginResult.accessToken?.token == null) return null;
  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
