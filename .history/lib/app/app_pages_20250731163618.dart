// app/app_pages.dart

import 'package:get/get.dart';

import '../main.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const DungeonPage(),
    ),
  ];
}

