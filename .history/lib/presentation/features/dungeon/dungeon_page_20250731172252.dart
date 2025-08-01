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
        title: Row(
          children: [
            Icon(
              room.isEntry
                  ? Icons.input
                  : room.isBoss
                      ? Icons.warning
                      : Icons.room,
              color: room.isEntry
                  ? Colors.amber
                  : room.isBoss
                      ? Colors.red
                      : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text(room.displayName),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRoomInfo('Tipo', room.room.type),
                _buildRoomInfo('Ar', room.room.air),
                _buildRoomInfo('Cheiro', room.room.smell),
                _buildRoomInfo('Som', room.room.sound),
                _buildRoomInfo('Item', room.room.item),
                _buildRoomInfo('Item Especial', room.room.specialItem),
                _buildRoomInfo('Monstro', room.room.monster),
                _buildRoomInfo('Armadilha', room.room.trap),
                _buildRoomInfo('Armadilha Especial', room.room.specialTrap),
                _buildRoomInfo('Tesouro', room.room.treasure),
                _buildRoomInfo('Tesouro Especial', room.room.specialTreasure),
                _buildRoomInfo('Item Mágico', room.room.magicItem),
              ],
            ),
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

  Widget _buildRoomInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
      backgroundColor: Colors.grey.shade50,
      body: Row(
        children: [
          // Mapa ocupa 80% da largura
          Expanded(
            flex: 8,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: DungeonGridWidget(
                  grid: _grid,
                  roomPositions: _roomPositions,
                  onRoomTap: _showRoomDetails,
                  cellSize: 10,
                ),
              ),
            ),
          ),
          // Painel lateral ocupa 20%
          Expanded(
            flex: 2,
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
                          _buildInfoSection(
                              'Construtor', _dungeon.builderOrInhabitant),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
