import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/dungeon.dart';
import 'services/dungeon_generator.dart';
import 'services/dungeon_map_renderer.dart';
import 'app/app_pages.dart';
import 'app/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dungeon Forge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'monospace',
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,
    );
  }
}

class DungeonPage extends StatefulWidget {
  const DungeonPage({super.key});

  @override
  State<DungeonPage> createState() => _DungeonPageState();
}

class _DungeonPageState extends State<DungeonPage> {
  late Dungeon _dungeon;
  late String _map;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    final generator = DungeonGenerator();
    _dungeon = generator.generate(level: 3, theme: 'Recuperar artefato');
    _map = DungeonMapRenderer().render(_dungeon);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final monoStyle = const TextStyle(fontFamily: 'monospace', fontSize: 11);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dungeon Forge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generate,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_map, style: monoStyle),
            const SizedBox(height: 8),
            Text(
              _dungeon.toString(),
              style: monoStyle,
            ),
          ],
        ),
      ),
    );
  }
}
