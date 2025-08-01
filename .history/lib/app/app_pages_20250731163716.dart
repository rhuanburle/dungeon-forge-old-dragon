// app/app_pages.dart

import 'package:get/get.dart';

import '../presentation/features/dungeon/dungeon_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const DungeonPage(),
    ),
  ];
}

