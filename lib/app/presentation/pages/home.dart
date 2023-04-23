import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../injecter.dart';
import '../manager/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  // final controller = Get.put(HomeController(sl()));
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Text(
          _user.displayName ?? 'No name'
        ),
      ),
    );
  }
}
