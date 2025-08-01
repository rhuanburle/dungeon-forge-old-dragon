// presentation/features/dungeon/dungeon_page.dart

import 'package:flutter/material.dart';
import '../../../models/dungeon.dart';
import '../../../models/room.dart';
import '../../../services/dungeon_generator.dart';

class DungeonPage extends StatefulWidget {
  const DungeonPage({super.key});

  @override
  State<DungeonPage> createState() => _DungeonPageState();
}

class _DungeonPageState extends State<DungeonPage> {
  late Dungeon _dungeon;
  int _customRoomCount = 0; // 0 = usar valor da tabela
  int _minRooms = 0;
  int _maxRooms = 0;
  bool _autoRefresh = false;
  final TextEditingController _roomCountController = TextEditingController();
  final TextEditingController _minRoomsController = TextEditingController();
  final TextEditingController _maxRoomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  void dispose() {
    _roomCountController.dispose();
    _minRoomsController.dispose();
    _maxRoomsController.dispose();
    super.dispose();
  }

  void _generate() {
    final generator = DungeonGenerator();
    _dungeon = generator.generate(
      level: 3,
      theme: 'Recuperar artefato',
      customRoomCount: _customRoomCount > 0 ? _customRoomCount : null,
      minRooms: _minRooms > 0 ? _minRooms : null,
      maxRooms: _maxRooms > 0 ? _maxRooms : null,
    );
    setState(() {});
  }

  void _startAutoRefresh() {
    if (_autoRefresh) {
      Future.delayed(const Duration(seconds: 3), () {
        if (_autoRefresh) {
          _generate();
          _startAutoRefresh(); // Continua o loop
        }
      });
    }
  }

  void _showGenerationDialog() {
    // Limpar controllers
    _roomCountController.clear();
    _minRoomsController.clear();
    _maxRoomsController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.castle, color: Colors.amber.shade700),
            const SizedBox(width: 8),
            const Text('Gerar Nova Masmorra'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quantidade específica
              const Text(
                'Quantidade de salas (opcional):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _roomCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ex: 5 (deixe vazio para usar tabela)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 16),

              // Mínimo e máximo
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mínimo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _minRoomsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Ex: 3',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.trending_down),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Máximo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _maxRoomsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Ex: 8',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.trending_up),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dicas
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Dicas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '• Deixe todos vazios para usar valor da Tabela 9-1\n'
                      '• Digite apenas quantidade para valor fixo\n'
                      '• Use min/max para intervalo de salas\n'
                      '• Mínimo e máximo aplicam-se ao valor da tabela',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.cancel),
            label: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              final roomCount = _roomCountController.text.trim();
              final minRooms = _minRoomsController.text.trim();
              final maxRooms = _maxRoomsController.text.trim();

              _customRoomCount =
                  roomCount.isEmpty ? 0 : int.tryParse(roomCount) ?? 0;
              _minRooms = minRooms.isEmpty ? 0 : int.tryParse(minRooms) ?? 0;
              _maxRooms = maxRooms.isEmpty ? 0 : int.tryParse(maxRooms) ?? 0;

              Navigator.of(context).pop();
              _generate();
            },
            icon: const Icon(Icons.castle),
            label: const Text('Gerar Masmorra'),
          ),
        ],
      ),
    );
  }

  void _showRoomDetails(Room room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              room.index == 1
                  ? Icons.input
                  : room.index == _dungeon.roomsCount
                      ? Icons.warning
                      : Icons.room,
              color: room.index == 1
                  ? Colors.amber
                  : room.index == _dungeon.roomsCount
                      ? Colors.red
                      : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text('Sala ${room.index}' + (room.index == 1 ? ' (Entrada)' : room.index == _dungeon.roomsCount ? ' (Boss)' : '')),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRoomInfo('Tipo', room.type),
                _buildRoomInfo('Ar', room.air),
                _buildRoomInfo('Cheiro', room.smell),
                _buildRoomInfo('Som', room.sound),
                _buildRoomInfo('Item', room.item),
                _buildRoomInfo('Item Especial', room.specialItem),
                _buildRoomInfo('Monstro', room.monster),
                _buildRoomInfo('Armadilha', room.trap),
                _buildRoomInfo('Armadilha Especial', room.specialTrap),
                _buildRoomInfo('Tesouro', room.treasure),
                _buildRoomInfo('Tesouro Especial', room.specialTreasure),
                _buildRoomInfo('Item Mágico', room.magicItem),
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
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.castle, color: Colors.amber),
            SizedBox(width: 8),
            Text('Dungeon Forge'),
          ],
        ),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(_autoRefresh ? Icons.pause : Icons.play_arrow),
            tooltip: _autoRefresh ? 'Parar Auto-Refresh' : 'Iniciar Auto-Refresh',
            onPressed: () {
              setState(() {
                _autoRefresh = !_autoRefresh;
              });
              if (_autoRefresh) {
                _startAutoRefresh();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Gerar Nova Masmorra',
            onPressed: _showGenerationDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerar Atual',
            onPressed: _generate,
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações da Masmorra - 30%
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Informações da Masmorra',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoCard('Tipo', _dungeon.type, Icons.business),
                            _buildInfoCard('Construtor', _dungeon.builderOrInhabitant, Icons.build),
                            _buildInfoCard('Status', _dungeon.status, Icons.circle),
                            _buildInfoCard('Objetivo', _dungeon.objective, Icons.flag),
                            _buildInfoCard('Localização', _dungeon.location, Icons.place),
                            _buildInfoCard('Entrada', _dungeon.entry, Icons.input),
                            _buildInfoCard('Número de Salas', '${_dungeon.roomsCount}', Icons.grid_3x3),
                            _buildInfoCard('Ocupante I', _dungeon.occupant1, Icons.person),
                            _buildInfoCard('Ocupante II', _dungeon.occupant2, Icons.people),
                            _buildInfoCard('Líder', _dungeon.leader, Icons.star),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.record_voice_over, color: Colors.amber.shade700),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Rumores',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber.shade700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildRumorItem('1', _dungeon.rumor1),
                                  _buildRumorItem('2', _dungeon.rumor2),
                                  _buildRumorItem('3', _dungeon.rumor3),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Lista de Salas - 70%
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.room_preferences, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Salas da Masmorra',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_dungeon.rooms.length} salas',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _dungeon.rooms.length,
                        itemBuilder: (context, index) {
                          final room = _dungeon.rooms[index];
                          return _buildRoomCard(room);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
