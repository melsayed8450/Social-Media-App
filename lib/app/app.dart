import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/app/presentation/routes/app_pages.dart';
import 'package:social_media_app/app/presentation/routes/app_routes.dart';


class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      smartManagement: SmartManagement.keepFactory,
      getPages: AppRoutes.routes,
      initialRoute: AppPages.home,
    );
  }
}
