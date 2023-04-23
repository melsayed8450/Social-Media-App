import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:social_media_app/app/domain/entities/post_entity.dart';

import '../../injecter.dart';
import '../manager/home_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required User user, required String userId})
      : this.user = user,
        this.userId = userId,
        super(key: key);

  final User user;
  final String userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller;

  @override
  void initState() {
    controller = Get.put(HomeController(user: widget.user));
    print(controller.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            controller.postTextEditingController.value.clear();
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Obx(() {
                    return Container(
                      height: 70.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextField(
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
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon:
                                    Icon(Icons.post_add, color: Colors.blue),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  controller.isUploadingPost.value = true;

                                  await controller.addPostForPerson(
                                    personId: widget.userId,
                                    text: controller
                                        .postTextEditingController.value.text,
                                    date: DateTime.now().toString(),
                                  );
                                  controller.updatePosts();
                                  controller.isUploadingPost.value = false;
                                  Get.back();
                                },
                                child: controller.isUploadingPost.value
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text('Add Post')),
                          ],
                        ),
                      ),
                    );
                  });
                });
          },
        ),
        actions: [
          Obx(() {
            return controller.isSigningOut.value
                ? CircularProgressIndicator()
                : IconButton(
                    onPressed: () {
                      controller.signOut(context: context);
                    },
                    icon: Icon(Icons.logout_outlined));
          }),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () => controller.updatePosts(),
          child: FutureBuilder<List<PostEntity>>(
              future: controller.postsList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No data found'));
                } else {
                  List<PostEntity> dataList = snapshot.data!;
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.w,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.user.displayName!),
                                  dataList[index].personId == widget.userId
                                      ? Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                controller
                                                    .postTextEditingController
                                                    .value
                                                    .text = dataList[
                                                        index]
                                                    .text;
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return Obx(() {
                                                        return Container(
                                                          height: 70.h,
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.w),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                TextField(
                                                                  controller:
                                                                      controller
                                                                          .postTextEditingController
                                                                          .value,
                                                                  maxLines: 10,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Your post',
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.blue),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.grey),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    suffixIcon: Icon(
                                                                        Icons
                                                                            .post_add,
                                                                        color: Colors
                                                                            .blue),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      controller
                                                                          .isUploadingPost
                                                                          .value = true;

                                                                      await controller
                                                                          .updatePost(
                                                                        postId:
                                                                            dataList[index].id,
                                                                        text: controller
                                                                            .postTextEditingController
                                                                            .value
                                                                            .text,
                                                                        date: DateTime.now()
                                                                            .toString(),
                                                                      );
                                                                      controller
                                                                          .updatePosts();
                                                                      controller
                                                                          .isUploadingPost
                                                                          .value = false;
                                                                      Get.back();
                                                                    },
                                                                    child: controller
                                                                            .isUploadingPost
                                                                            .value
                                                                        ? CircularProgressIndicator(
                                                                            color:
                                                                                Colors.white,
                                                                          )
                                                                        : Text(
                                                                            'Edit Post')),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    });
                                              },
                                              iconSize: 20,
                                              icon: Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text('Alert'),
                                                    content:  Text(
                                                            'Are you sure you want to delete this post?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Get.back(),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          controller
                                                              .isDeletingPost
                                                              .value = true;
                                                          await controller
                                                              .deletePost(
                                                                  dataList[
                                                                          index]
                                                                      .id);
                                                          controller.onInit();
                                                          controller
                                                              .isDeletingPost
                                                              .value = false;
                                                          Get.back();
                                                        },
                                                        child: controller
                                                            .isDeletingPost
                                                            .value
                                                        ? CircularProgressIndicator()
                                                        : Text(
                                                            'Yes, Delete'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              iconSize: 20,
                                              icon: Icon(Icons.delete),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      '${dataList[index].date.day.toString()} - ${dataList[index].date.month.toString()} - ${dataList[index].date.year.toString()}  |  ${dataList[index].date.hour.toString()}:${dataList[index].date.minute.toString()}'),
                                ],
                              ),
                              SizedBox(
                                height: 0.6.h,
                              ),
                              Material(
                                elevation: 20,
                                child: Container(
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 2.h,
                                    ),
                                    child: Text(
                                      dataList[index].text,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
        );
      }),
    );
  }
}
