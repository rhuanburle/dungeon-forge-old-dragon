// app/app_pages.dart

import 'package:get/get.dart';

import '../presentation/features/main/main_page.dart';
import '../presentation/features/dungeon/dungeon_page.dart';
import '../presentation/features/encounters/encounters_page.dart';
import '../presentation/features/turn_monitor/turn_monitor_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const MainPage(),
    ),
    GetPage(
      name: AppRoutes.dungeon,
      page: () => const DungeonPage(),
    ),
    GetPage(
      name: AppRoutes.encounters,
      page: () => const EncountersPage(),
    ),
    GetPage(
      name: AppRoutes.turnMonitor,
      page: () => const TurnMonitorPage(),
    ),
  ];
}
