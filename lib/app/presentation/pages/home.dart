import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:social_media_app/app/domain/entities/post_entity.dart';
import 'package:social_media_app/app/presentation/routes/app_pages.dart';
import 'package:social_media_app/app/presentation/widgets/custom_widgets.dart';
import '../manager/home_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required User user,
  })  : this.user = user,
        super(key: key);

  final User user;

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
        backgroundColor: Color.fromARGB(255, 215, 35, 135),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            CustomWidgets().addPost(
                context: context, controller: controller, widget: widget);
          },
        ),
        actions: [
          IconButton(
            onPressed: () => controller.updatePosts(),
            icon: Icon(Icons.refresh),
          ),
          IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Alert'),
                    content: Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.signOut(context: context);
                          Get.offAndToNamed(AppPages.login);
                        },
                        child: Text(
                          'Yes, Logout',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout_outlined)),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () => controller.updatePosts(),
          child: FutureBuilder<List<PostEntity>>(
              future: controller.postsList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.pink,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.length == 0) {
                  return Center(
                      child: Text(
                    'No data found',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ));
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
                                  Text(dataList[index].personName),
                                  // dataList[index].personId == widget.userId
                                  //     ? Row(
                                  //         children: [
                                  //           IconButton(
                                  //             onPressed: () {
                                  //               controller
                                  //                   .postTextEditingController
                                  //                   .value
                                  //                   .text = dataList[
                                  //                       index]
                                  //                   .text;
                                  //               showModalBottomSheet(
                                  //                   isScrollControlled: true,
                                  //                   context: context,
                                  //                   builder: (context) {
                                  //                     return Obx(() {
                                  //                       return Container(
                                  //                         height: 70.h,
                                  //                         child: Padding(
                                  //                           padding: EdgeInsets
                                  //                               .symmetric(
                                  //                                   horizontal:
                                  //                                       10.w),
                                  //                           child: Column(
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment
                                  //                                     .spaceAround,
                                  //                             children: [
                                  //                               TextField(
                                  //                                 controller:
                                  //                                     controller
                                  //                                         .postTextEditingController
                                  //                                         .value,
                                  //                                 maxLines: 10,
                                  //                                 decoration:
                                  //                                     InputDecoration(
                                  //                                   labelText:
                                  //                                       'Your post',
                                  //                                   labelStyle:
                                  //                                       TextStyle(
                                  //                                     color: Colors
                                  //                                         .grey,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                   ),
                                  //                                   focusedBorder:
                                  //                                       OutlineInputBorder(
                                  //                                     borderSide:
                                  //                                         BorderSide(
                                  //                                             color: Colors.blue),
                                  //                                     borderRadius:
                                  //                                         BorderRadius.circular(
                                  //                                             10.0),
                                  //                                   ),
                                  //                                   enabledBorder:
                                  //                                       OutlineInputBorder(
                                  //                                     borderSide:
                                  //                                         BorderSide(
                                  //                                             color: Colors.grey),
                                  //                                     borderRadius:
                                  //                                         BorderRadius.circular(
                                  //                                             10.0),
                                  //                                   ),
                                  //                                   suffixIcon: Icon(
                                  //                                       Icons
                                  //                                           .post_add,
                                  //                                       color: Colors
                                  //                                           .blue),
                                  //                                 ),
                                  //                               ),
                                  //                               ElevatedButton(
                                  //                                   onPressed:
                                  //                                       () async {
                                  //                                     controller
                                  //                                         .isUploadingPost
                                  //                                         .value = true;
                                  //                                     await controller
                                  //                                         .updatePost(
                                  //                                       postId:
                                  //                                           dataList[index].id,
                                  //                                       text: controller
                                  //                                           .postTextEditingController
                                  //                                           .value
                                  //                                           .text,
                                  //                                       date: DateTime.now()
                                  //                                           .toString(),
                                  //                                     );
                                  //                                     controller
                                  //                                         .updatePosts();
                                  //                                     controller
                                  //                                         .isUploadingPost
                                  //                                         .value = false;
                                  //                                     Get.back();
                                  //                                   },
                                  //                                   child: controller
                                  //                                           .isUploadingPost
                                  //                                           .value
                                  //                                       ? CircularProgressIndicator(
                                  //                                           color:
                                  //                                               Colors.white,
                                  //                                         )
                                  //                                       : Text(
                                  //                                           'Edit Post')),
                                  //                             ],
                                  //                           ),
                                  //                         ),
                                  //                       );
                                  //                     });
                                  //                   });
                                  //             },
                                  //             iconSize: 20,
                                  //             icon: Icon(Icons.edit),
                                  //           ),
                                  //           IconButton(
                                  //             onPressed: () {
                                  //               showDialog<String>(
                                  //                 context: context,
                                  //                 builder:
                                  //                     (BuildContext context) =>
                                  //                         AlertDialog(
                                  //                   title: const Text('Alert'),
                                  //                   content: Text(
                                  //                       'Are you sure you want to delete this post?'),
                                  //                   actions: <Widget>[
                                  //                     TextButton(
                                  //                       onPressed: () async {
                                  //                         controller
                                  //                             .isDeletingPost
                                  //                             .value = true;
                                  //                         await controller
                                  //                             .deletePost(
                                  //                           dataList[index].id,
                                  //                           dataList[index]
                                  //                               .personId,
                                  //                         );
                                  //                         controller.onInit();
                                  //                         controller
                                  //                             .isDeletingPost
                                  //                             .value = false;
                                  //                         Get.back();
                                  //                       },
                                  //                       child: controller
                                  //                               .isDeletingPost
                                  //                               .value
                                  //                           ? CircularProgressIndicator()
                                  //                           : Text(
                                  //                               'Yes, Delete'),
                                  //                     ),
                                  //                     TextButton(
                                  //                       onPressed: () =>
                                  //                           Get.back(),
                                  //                       child: const Text(
                                  //                         'Cancel',
                                  //                         style: TextStyle(
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .bold),
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               );
                                  //             },
                                  //             iconSize: 20,
                                  //             icon: Icon(Icons.delete),
                                  //           ),
                                  //         ],
                                  //       )
                                  //     : SizedBox(),

                                  IconButton(
                                      onPressed: () {
                                        CustomWidgets().showOptions(
                                            context: context,
                                            controller: controller,
                                            dataList: dataList,
                                            index: index,
                                            widget: widget);
                                      },
                                      icon: Icon(Icons.more_vert))
                                ],
                              ),
                              Row(
                                children: [
                                  Text(DateTime.now()
                                              .difference(dataList[index].date)
                                              .inMinutes <
                                          2
                                      ? '1 minute ago'
                                      : DateTime.now()
                                                  .difference(
                                                      dataList[index].date)
                                                  .inMinutes <
                                              60
                                          ? '${DateTime.now().difference(dataList[index].date).inMinutes} minutes ago'
                                          : DateTime.now()
                                                      .difference(
                                                          dataList[index].date)
                                                      .inHours <
                                                  2
                                              ? '1 hour ago'
                                              : DateTime.now()
                                                          .difference(dataList[index]
                                                              .date)
                                                          .inHours <
                                                      24
                                                  ? '${DateTime.now().difference(dataList[index].date).inHours} hours ago'
                                                  : DateTime.now()
                                                              .difference(
                                                                  dataList[index]
                                                                      .date)
                                                              .inDays <
                                                          2
                                                      ? '1 day ago'
                                                      : DateTime.now()
                                                                  .difference(dataList[index].date)
                                                                  .inDays <
                                                              7
                                                          ? '${DateTime.now().difference(dataList[index].date).inHours} days ago'
                                                          : '${dataList[index].date.day.toString()} - ${dataList[index].date.month.toString()} - ${dataList[index].date.year.toString()}'),
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
