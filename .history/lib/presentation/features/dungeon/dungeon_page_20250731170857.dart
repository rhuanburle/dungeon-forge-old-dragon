// presentation/features/dungeon/dungeon_page.dart

import 'package:flutter/material.dart';
import '../../../models/dungeon.dart';
import '../../../services/dungeon_generator.dart';
import '../../../services/dungeon_map_renderer.dart';
import '../../shared/widgets/dungeon_grid_widget.dart';
import '../../../models/room_position.dart';

class DungeonPage extends StatefulWidget {
  const DungeonPage({super.key});

  @override
  State<DungeonPage> createState() => _DungeonPageState();
}

class _DungeonPageState extends State<DungeonPage> {
  late Dungeon _dungeon;
  late List<List<String>> _grid;
  late String _ascii;
  late List<RoomPosition> _roomPositions;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    final generator = DungeonGenerator();
    _dungeon = generator.generate(level: 3, theme: 'Recuperar artefato');
    final renderer = DungeonMapRenderer();
    final result = renderer.buildGridWithPositions(_dungeon);
    _grid = result['grid'] as List<List<String>>;
    _roomPositions = result['roomPositions'] as List<RoomPosition>;
    _ascii = renderer.gridToAscii(_grid);
    setState(() {});
  }

  void _showRoomDetails(RoomPosition room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(room.displayName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tipo: ${room.room.type}'),
              Text('Ar: ${room.room.air}'),
              Text('Cheiro: ${room.room.smell}'),
              Text('Som: ${room.room.sound}'),
              Text('Item: ${room.room.item}'),
              Text('Item Especial: ${room.room.specialItem}'),
              Text('Monstro: ${room.room.monster}'),
              Text('Armadilha: ${room.room.trap}'),
              Text('Armadilha Especial: ${room.room.specialTrap}'),
              Text('Tesouro: ${room.room.treasure}'),
              Text('Tesouro Especial: ${room.room.specialTreasure}'),
              Text('Item Mágico: ${room.room.magicItem}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
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
            DungeonGridWidget(
              grid: _grid,
              roomPositions: _roomPositions,
              onRoomTap: _showRoomDetails,
            ),
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
