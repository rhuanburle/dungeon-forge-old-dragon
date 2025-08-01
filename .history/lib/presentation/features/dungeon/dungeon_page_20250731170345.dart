// presentation/features/dungeon/dungeon_page.dart

import 'package:flutter/material.dart';
import '../../../models/dungeon.dart';
import '../../../services/dungeon_generator.dart';
import '../../../services/dungeon_map_renderer.dart';
import '../../shared/widgets/dungeon_grid_widget.dart';

class DungeonPage extends StatefulWidget {
  const DungeonPage({super.key});

  @override
  State<DungeonPage> createState() => _DungeonPageState();
}

class _DungeonPageState extends State<DungeonPage> {
  late Dungeon _dungeon;
  late List<List<String>> _grid;
  late String _ascii;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    final generator = DungeonGenerator();
    _dungeon = generator.generate(level: 3, theme: 'Recuperar artefato');
    final renderer = DungeonMapRenderer();
    _grid = renderer.buildGrid(_dungeon);
    _ascii = renderer.gridToAscii(_grid);
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
            DungeonGridWidget(grid: _grid),
            const SizedBox(height: 16),
            Text(
              _ascii,
              style: monoStyle,
            ),
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
