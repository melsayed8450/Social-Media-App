// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, duplicate_ignore

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:social_media_app/app/data/routes/remote_routes.dart';
import 'package:social_media_app/app/domain/entities/post_entity.dart';
import 'package:social_media_app/app/presentation/pages/home.dart';
import 'package:social_media_app/app/presentation/routes/app_pages.dart';

import '../widgets/custom_snackbar.dart';

class HomeController extends GetxController {
  HomeController({required User user}) : this.user = user;

  final User user;
  final isSigningOut = false.obs;
  final isUploadingPost = false.obs;
  final isDeletingPost = false.obs;
  var userId;
  Dio dio = Dio();
  Rx<TextEditingController> postTextEditingController = TextEditingController().obs;
  final _postsList = Future.value(<PostEntity>[]).obs;
  Future<List<PostEntity>> get postsList => _postsList.value;

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
              personId: postData['person_id'],
              id: postData['_id'],
              text: postData['text'],
              date: DateTime.parse(postData['date']),
            ))
        .toList();
  }

  Future<void> addPostForPerson({
    required String? personId,
    required String text,
    required String date,
  }) async {
    try {
      // Make a POST request to create a new post
      var response = await dio.post("${AppRemoteRoutes.baseUrl}posts",
          data: {
            "person_id": personId,
            "text": text,
            "date": date,
          },
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));

      // Get the ID of the new post
      String postId = response.data["_id"];

      // Get the person's document from the people collection
      var personResponse =
          await dio.get("${AppRemoteRoutes.baseUrl}people/${personId}",
              options: Options(headers: {
                'content-type': "application/json",
                'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
              }));

      // Update the person's document in the people collection
      List<dynamic> posts = personResponse.data["posts"];
      posts.add(postId);

      await dio.put("${AppRemoteRoutes.baseUrl}people/${personId}",
          data: {"posts": posts},
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));
    } catch (e) {
      print(e);
    }
  }

  // Future<void> addPostForPerson(
  //     {required String? personId, required String text, required String date, XFile? picture}) async {
  //   try {
  //     // Create a FormData object and add the fields
  //     var formData = FormData.fromMap({
  //       "person_id": personId,
  //       "text": text,
  //       "date": date,
  //       "picture": await MultipartFile.fromFile(picture!.path,
  //           filename: "picture.jpg"),
  //     });

  //     // Make a POST request to create a new post
  //     Response response = await dio.post("${AppRemoteRoutes.baseUrl}posts",
  //         data: formData,
  //         options: Options(headers: {
  //           'content-type': "application/json",
  //           'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
  //         }));

  //     // Get the ID of the new post
  //     String postId = response.data["_id"];

  //     // Update the person's document in the people collection
  //     var personResponse =
  //         await dio.get("${AppRemoteRoutes.baseUrl}people/${personId}",
  //             options: Options(headers: {
  //               'content-type': "application/json",
  //               'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
  //             }));

  //     // Update the person's document in the people collection
  //     List<dynamic> posts = personResponse.data["posts"];
  //     posts.add(postId);

  //     await dio.put("${AppRemoteRoutes.baseUrl}people/${personId}",
  //         data: {"posts": posts},
  //         options: Options(headers: {
  //           'content-type': "application/json",
  //           'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
  //         }));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> updatePost(
      {required String postId,
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
      // Make a DELETE request to delete the post
      await dio.delete("${AppRemoteRoutes.baseUrl}posts/${postId}",
          options: Options(headers: {
            'content-type': "application/json",
            'x-apikey': "4ddfd7cd94b5c5584f7c597f4dc3664912dd2",
          }));
    } catch (e) {
      print(e);
    }
  }

  
}
