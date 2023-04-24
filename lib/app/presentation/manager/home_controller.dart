// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, duplicate_ignore

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:social_media_app/app/data/routes/remote_routes.dart';
import 'package:social_media_app/app/domain/entities/post_entity.dart';
import 'package:social_media_app/app/presentation/routes/app_pages.dart';

import '../widgets/custom_widgets.dart';

class HomeController extends GetxController {
  HomeController({required User user}) : this.user = user;

  final User user;
  final isSigningOut = false.obs;
  final isUploadingPost = false.obs;
  final isDeletingPost = false.obs;
  final likeInProgress = false.obs;
  var userId;
  Dio dio = Dio();
  Rx<TextEditingController> postTextEditingController =
      TextEditingController().obs;
  final _postsList = Future.value(<PostEntity>[]).obs;
  Future<List<PostEntity>> get postsList => _postsList.value;
  Rx<MaterialColor> addButtonColor = Colors.grey.obs;

  @override
  void onInit() async {
    updatePosts();

    super.onInit();
  }

  void updatePosts() async {
    _postsList.value = getPosts();
  }

  Future<void> signOut({required BuildContext context}) async {
    try {
      isSigningOut.value = true;
      await FirebaseAuth.instance.signOut();
      Get.offAndToNamed(AppPages.login);
      isSigningOut.value = false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomWidgets.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  Future<List<dynamic>> _getAllPostsSortedByDate() async {
    try {
      var response = await dio.get("${AppRemoteRoutes.baseUrl}posts",
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));

      List<dynamic> posts = response.data;
      posts.sort((a, b) =>
          DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

      return posts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<PostEntity>> getPosts() async {
    final List<dynamic> postsData = await _getAllPostsSortedByDate();

    return postsData
        .map((postData) => PostEntity(
              personName: postData['person_name'],
              personEmail: postData['person_email'],
              id: postData['_id'],
              text: postData['text'],
              likes: postData['likes'],
              likedEmails: postData['liked_emails'],
              date: DateTime.parse(
                postData['date'],
              ),
            ))
        .toList();
  }

  Future<void> addPostForPerson({
    required String personName,
    required String personEmail,
    required String text,
    required String date,
  }) async {
    try {
      // Make a POST request to create a new post
      await dio.post("${AppRemoteRoutes.baseUrl}posts",
          data: {
            "person_name": personName,
            "person_email": personEmail,
            "text": text,
            "date": date,
            "likes": 0,
            "liked_emails": [],
          },
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePost({
    required String postId,
    required String text,
    required String date,
  }) async {
    try {
      // Make a PATCH request to update the post
      await dio.patch("${AppRemoteRoutes.baseUrl}posts/${postId}",
          data: {"text": text, "date": date},
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await dio.delete("${AppRemoteRoutes.baseUrl}posts/${postId}",
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));
    } catch (e) {
      print(e);
    }
  }

  Future<String> getPersonName(String personId) async {
    try {
      Response response = await dio.get(
          "${AppRemoteRoutes.baseUrl}people/$personId",
          options: Options(headers: {"Authorization": "Bearer YOUR_API_KEY"}));

      // Get the name of the person from the response data
      String name = response.data["name"];
      return name;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> addLikeToPost(
    String postId,
  ) async {
    try {
      likeInProgress.value = true;
      final response =
          await dio.get("${AppRemoteRoutes.baseUrl}posts/${postId}",
              options: Options(headers: {
                'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
              }));
      final currentFieldValue = response.data['likes'];
      final currentLikedEmails = response.data['liked_emails'];
      final updatedFieldValue = currentFieldValue + 1;
      currentLikedEmails.add(user.email);
      await dio.patch("${AppRemoteRoutes.baseUrl}posts/${postId}",
          data: {
            "likes": updatedFieldValue,
            "liked_emails": currentLikedEmails,
          },
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));
      likeInProgress.value = false;
    } catch (e) {
      print(e);
      likeInProgress.value = false;
    }
  }
  Future<void> removeLikeFromPost(
    String postId,
  ) async {
    try {
      likeInProgress.value = true;
      final response =
          await dio.get("${AppRemoteRoutes.baseUrl}posts/${postId}",
              options: Options(headers: {
                'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
              }));
      final currentFieldValue = response.data['likes'];
      final currentLikedEmails = response.data['liked_emails'];
      final updatedFieldValue = currentFieldValue - 1;
      currentLikedEmails.removeWhere((str) => str == user.email);
      await dio.patch("${AppRemoteRoutes.baseUrl}posts/${postId}",
          data: {
            "likes": updatedFieldValue,
            "liked_emails": currentLikedEmails,
          },
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));
      likeInProgress.value = false;
    } catch (e) {
      print(e);
      likeInProgress.value = false;
    }
  }
}
