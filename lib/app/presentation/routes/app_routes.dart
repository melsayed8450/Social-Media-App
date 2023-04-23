import 'package:get/get.dart';
import 'package:social_media_app/app/presentation/pages/login.dart';
import 'app_pages.dart';

class AppRoutes {

  static final routes = [

    GetPage(
        name: AppPages.login,
        page: () => LoginPage(),
        ),

  ];
}
