import 'package:get/get.dart';
import '../pages/home.dart';
import 'app_pages.dart';

class AppRoutes {

  static final routes = [

    GetPage(
        name: AppPages.home,
        page: () => HomePage(),
        ),

  ];
}
