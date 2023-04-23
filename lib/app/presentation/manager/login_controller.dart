import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_app/app/presentation/pages/home.dart';
import 'package:social_media_app/app/presentation/widgets/custom_snackbar.dart';

import '../../data/routes/remote_routes.dart';

class LoginController extends GetxController {
  final isSigningIn = false.obs;
  Dio dio = Dio();

   Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = (await getPersonIdFromEmail(user.email!))!;
      Get.to(HomePage(user: user, userId:userId));
    }

    return firebaseApp;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        if (userCredential.additionalUserInfo!.isNewUser) {
          addPerson(
            name: user?.displayName ?? "No name available",
            email: user?.email ?? "No email available",
            posts: [],
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomWidgets.customSnackBar(
              content: 'The account already exists with a different credential',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomWidgets.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomWidgets.customSnackBar(
            content: 'Error occurred using Google Sign In. Try again.',
          ),
        );
      }
    }

    return user;
  }

  Future<void> addPerson(
      {required String name,
      required String email,
      required List<String> posts}) async {
    try {
      // Make a POST request to create a new person
      var response = await dio.post("${AppRemoteRoutes.baseUrl}people",
          data: {"name": name, "email": email, "posts": posts},
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));

      // Get the ID of the new person
      String personId = response.data["_id"];

      // Do something with the new person ID
      // ...
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getPersonIdFromEmail(String email) async {
    try {
      // Make a GET request to find the person with the given email
      var response = await dio.get("${AppRemoteRoutes.baseUrl}people",
          queryParameters: {"email": email},
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));

      // Check if the person was found
      if (response.data.length > 0) {
        // Return the ID of the first person with the given email
        return response.data[0]["_id"];
      } else {
        // Return null if the person was not found
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
