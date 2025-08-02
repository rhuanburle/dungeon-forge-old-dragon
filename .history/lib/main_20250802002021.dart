import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app_pages.dart';
import 'app/app_routes.dart';
import 'theme/app_colors.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'services/old_dragon_api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await OldDragonApiService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dungeon Forge',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.amber.shade700,
          surface: const Color(0xFF2a2a2a),
          onSurface: Colors.white,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
        ),
        useMaterial3: true,
        fontFamily: 'monospace',
        dialogTheme: DialogTheme(
          backgroundColor: const Color(0xFF2a2a2a),
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1a1a1a),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.amber.shade700),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.amber.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade700,
            foregroundColor: Colors.black,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.amber,
          ),
        ),
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,
    );
  }
}
