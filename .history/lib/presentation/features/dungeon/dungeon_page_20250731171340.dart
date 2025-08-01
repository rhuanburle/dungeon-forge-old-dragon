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
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generate,
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          // Mapa ocupa 70% da largura
          Expanded(
            flex: 7,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DungeonGridWidget(
                  grid: _grid,
                  roomPositions: _roomPositions,
                  onRoomTap: _showRoomDetails,
                  cellSize: 4,
                ),
              ),
            ),
          ),
          // Painel lateral ocupa 30%
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dungeon Info',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection('Tipo', _dungeon.type),
                          _buildInfoSection('Construtor', _dungeon.builderOrInhabitant),
                          _buildInfoSection('Status', _dungeon.status),
                          _buildInfoSection('Objetivo', _dungeon.objective),
                          _buildInfoSection('Localização', _dungeon.location),
                          _buildInfoSection('Entrada', _dungeon.entry),
                          _buildInfoSection('Salas', '${_dungeon.roomsCount}'),
                          _buildInfoSection('Ocupante I', _dungeon.occupant1),
                          _buildInfoSection('Ocupante II', _dungeon.occupant2),
                          _buildInfoSection('Líder', _dungeon.leader),
                          const SizedBox(height: 16),
                          Text(
                            'Rumores',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('1. ${_dungeon.rumor1}'),
                          Text('2. ${_dungeon.rumor2}'),
                          Text('3. ${_dungeon.rumor3}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
