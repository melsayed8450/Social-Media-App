import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';

class CustomWidgets {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      duration: Duration(milliseconds: 1250),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      content: Text(
        content,
        style: TextStyle(color: Colors.white, letterSpacing: 0.5),
      ),
    );
  }

  void showOptions(
      {required context,
      required controller,
      required dataList,
      required widget,
      required index}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height:
                widget.user.email == dataList[index].personEmail ? 30.h : 10.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  child: InkWell(
                    onTap: () {
                      Share.share(dataList[index].text);
                    },
                    child: Container(
                      height: 10.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Text(
                              'Share',
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Icon(Icons.share)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                widget.user.email == dataList[index].personEmail
                    ? Material(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            editPost(
                                context: context,
                                controller: controller,
                                dataList: dataList,
                                index: index);
                          },
                          child: Container(
                            height: 10.h,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                children: [
                                  Text(
                                    'Edit',
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Icon(Icons.edit)
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                widget.user.email == dataList[index].personEmail
                    ? Material(
                        child: InkWell(
                          onTap: () {
                            deletePost(
                                context: context,
                                controller: controller,
                                dataList: dataList,
                                index: index);
                          },
                          child: Container(
                            height: 10.h,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                children: [
                                  Text(
                                    'Delete',
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Icon(Icons.delete)
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          );
        });
  }

  void deletePost({
    required context,
    required controller,
    required dataList,
    required index,
  }) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert'),
        content: Text('Are you sure you want to delete this post?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: () async {
              controller.isDeletingPost.value = true;
              await controller.deletePost(
                dataList[index].id,
              );
              controller.onInit();
              controller.isDeletingPost.value = false;
              Get.back();
              Get.back();
            },
            child: Obx(() {
              return controller.isDeletingPost.value
                  ? CircularProgressIndicator(
                      color: Colors.pink,
                    )
                  : Text(
                      'Yes, Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }

  void editPost(
      {required context,
      required controller,
      required dataList,
      required index}) {
    controller.postTextEditingController.value.text = dataList[index].text;
    controller.addButtonColor.value = Colors.pink;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Obx(() {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller:
                                  controller.postTextEditingController.value,
                              maxLines: 10,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 215, 35, 135),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (controller.postTextEditingController
                                          .value.text.isEmpty) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          CustomWidgets.customSnackBar(
                                            content:
                                                'Please add text to your post',
                                          ),
                                        );
                                      } else {
                                        controller.isUploadingPost.value = true;

                                        await controller.updatePost(
                                          postId: dataList[index].id,
                                          text: controller
                                              .postTextEditingController
                                              .value
                                              .text,
                                          date: DateTime.now().toString(),
                                        );
                                        controller.updatePosts();
                                        controller.isUploadingPost.value =
                                            false;
                                        Get.back();
                                      }
                                    },
                                    icon: controller.isUploadingPost.value
                                        ? CircularProgressIndicator(
                                            color: Colors.pink,
                                          )
                                        : Icon(Icons.edit,
                                            color: controller
                                                .addButtonColor.value)),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  controller.addButtonColor.value = Colors.grey;
                                } else {
                                  controller.addButtonColor.value = Colors.pink;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }

  void addPost({required context, required controller, required widget}) {
    controller.postTextEditingController.value.clear();
    controller.addButtonColor.value = Colors.grey;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Obx(() {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller:
                                  controller.postTextEditingController.value,
                              maxLines: 10,
                              decoration: InputDecoration(
                                labelText: 'Your post',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 215, 35, 135),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (controller.postTextEditingController
                                          .value.text.isEmpty) {
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                          CustomWidgets.customSnackBar(
                                            content:
                                                'Please add text to your post',
                                          ),
                                        );
                                      } else {
                                        controller.isUploadingPost.value = true;

                                        await controller.addPostForPerson(
                                          personName: widget.user.displayName,
                                          personEmail: widget.user.email,
                                          text: controller
                                              .postTextEditingController
                                              .value
                                              .text,
                                          date: DateTime.now().toString(),
                                        );
                                        controller.updatePosts();
                                        controller.isUploadingPost.value =
                                            false;
                                        Get.back();
                                      }
                                    },
                                    icon: controller.isUploadingPost.value
                                        ? CircularProgressIndicator(
                                            color: Colors.pink,
                                          )
                                        : Icon(Icons.post_add,
                                            color: controller
                                                .addButtonColor.value)),
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  controller.addButtonColor.value = Colors.grey;
                                } else {
                                  controller.addButtonColor.value = Colors.pink;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}
