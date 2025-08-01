// presentation/features/dungeon/dungeon_page.dart

import 'package:flutter/material.dart';
import '../../../models/dungeon.dart';
import '../../../models/room.dart';
import '../../../services/dungeon_generator.dart';
import '../../../constants/image_path.dart';

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
  final TextEditingController _roomCountController = TextEditingController();
  final TextEditingController _minRoomsController = TextEditingController();
  final TextEditingController _maxRoomsController = TextEditingController();

  // Mapa com descrições das armadilhas
  static const Map<String, String> _trapDescriptions = {
    'Alarme':
        'Dispara sinetas escondidas e amarradas com cordões por toda a extensão da sala, alertando a todos num raio de 50 metros e impedindo que todos nesta área sejam surpreendidos pelos personagens.',
    'Bloco que Cai': 'Do teto da masmorra. Causa 1d10 de dano aos atingidos.',
    'Dardos Envenenados':
        '1d6 dardos são expelidos por buracos nas paredes e causam 1d4 pontos de dano cada. Você determina o efeito do veneno.',
    'Desmoronamento':
        'De pedras soltas causou a interrupção do caminho atual. Ou os jogadores decidem remover todas as pedras do caminho (levando 3d6+10 turnos) ou simplesmente dão meia volta e tentam outro caminho para explorar.',
    'Fosso':
        'É um buraco no chão que se abre revelando a armadilha, formada por estacas afiadas causando 2d6 de dano aos personagens que caírem dentro do fosso. Há 1-2 chances em 1d6 de não haver estacas, e sim uma passagem levando aqueles que caíram a um nível inferior da masmorra.',
    'Guilhotina Oculta':
        'Corta com uma rápida lâmina escondida. Causa 1d8 pontos de dano.',
    'Poço de Água':
        'Suspeita no centro da sala, jorrando inexplicavelmente. Pode ser desde uma fonte inofensiva de água potável a até mesmo água profana, benta ou envenenada.',
    'Porta Secreta':
        'Escondida em algum ponto da sala. Só revele este resultado caso algum personagem descubra a existência da porta. Caso contrário, haja como se a sala estivesse vazia.',
    'Portal Dimensional':
        'Pode levar os personagens para outras salas aleatórias da mesma masmorra, acabando de vez com os planos de mapear corretamente o ambiente.',
    'Spray Ácido':
        'Atinge todos até 6 metros da armadilha. Causa 1d4 de dano ácido aos atingidos.',
    'Teto Retrátil':
        'Faz o teto da sala descer até esmagar todos dentro da mesma. Um Desarmar Armadilhas precisa ser realizado por um Ladrão ou todos morrerão em até 1d8 turnos.',
  };

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
            Image.asset(
              ImagePath.dragon,
              width: 24,
              height: 24,
              color: Colors.amber.shade700,
            ),
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
                'Quantidade fixa de salas (opcional):',
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
                          'Mínimo de salas:',
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
                          'Máximo de salas:',
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
                  color: Colors.amber.shade900.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info,
                            color: Colors.amber.shade400, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Dicas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Deixe todos vazios → Usar valor da Tabela 9-1 (aleatório)\n'
                      '• Digite apenas quantidade → Valor fixo de salas\n'
                      '• Use min/max → Intervalo de salas (ex: 3-8 salas)\n'
                      '• Mínimo e máximo → Aplicam-se ao valor da tabela',
                      style: TextStyle(fontSize: 12, color: Colors.white),
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
            icon: Image.asset(
              ImagePath.dragon,
              width: 20,
              height: 20,
              color: Colors.black,
            ),
            label: const Text('Gerar Nova Masmorra'),
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
            Image.asset(
              room.index == 1
                  ? ImagePath.dragon
                  : room.index == _dungeon.roomsCount
                      ? ImagePath.dragon
                      : ImagePath.treasure,
              width: 24,
              height: 24,
              color: room.index == 1
                  ? Colors.amber
                  : room.index == _dungeon.roomsCount
                      ? Colors.red
                      : Colors.blue,
            ),
            const SizedBox(width: 8),
            Text(
                'Sala ${room.index}${room.index == 1 ? ' (Entrada da Masmorra)' : room.index == _dungeon.roomsCount ? ' (Sala do Boss)' : ' (Sala Normal)'}'),
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
                _buildRoomInfo('Monstro', _buildMonsterText(room)),
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
    // Verifica se é uma armadilha e tem descrição
    String? description;
    if ((label == 'Armadilha' || label == 'Armadilha Especial') &&
        value.isNotEmpty &&
        _trapDescriptions.containsKey(value)) {
      description = _trapDescriptions[value];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade400,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildMonsterText(Room room) {
    if (room.monster2.isEmpty) {
      return room.monster1;
    } else {
      return '${room.monster1}, ${room.monster2}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              ImagePath.package,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text('Dungeon Forge - Old Dragon 2'),
          ],
        ),
        backgroundColor: const Color(0xFF1a1a1a),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            icon: Image.asset(
              ImagePath.dragon,
              width: 24,
              height: 24,
              color: Colors.amber,
            ),
            tooltip: 'Gerar Nova Masmorra (Configurar parâmetros)',
            onPressed: _showGenerationDialog,
          ),
          IconButton(
            icon: Image.asset(
              ImagePath.d20,
              width: 24,
              height: 24,
              color: Colors.amber,
            ),
            tooltip: 'Regenerar Masmorra Atual (Manter configurações)',
            onPressed: _generate,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0d0d0d),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Informações da Masmorra - 30%
        Expanded(
          flex: 3,
          child: _buildDungeonInfoCard(),
        ),
        const SizedBox(width: 16),
        // Lista de Salas - 70%
        Expanded(
          flex: 7,
          child: _buildRoomsGrid(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Informações da Masmorra
        _buildDungeonInfoCard(),
        const SizedBox(height: 16),
        // Lista de Salas
        Expanded(child: _buildRoomsGrid()),
      ],
    );
  }

  Widget _buildDungeonInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade700, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
              Icon(Icons.info, color: Colors.amber.shade400),
              const SizedBox(width: 8),
              Text(
                'Informações da Masmorra',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade400,
                    ),
              ),
            ],
          ),
          const Divider(height: 24, color: Colors.amber),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard('Tipo', _dungeon.type, Icons.business),
                  _buildInfoCard(
                      'Construtor', _dungeon.builderOrInhabitant, Icons.build),
                  _buildInfoCard('Status', _dungeon.status, Icons.circle),
                  _buildInfoCard('Objetivo', _dungeon.objective, Icons.flag),
                  _buildInfoCard('Localização', _dungeon.location, Icons.place),
                  _buildInfoCard('Entrada', _dungeon.entry, Icons.input),
                  _buildInfoCard('Número de Salas', '${_dungeon.roomsCount}',
                      Icons.grid_3x3),
                  _buildInfoCard(
                      'Ocupante I', _dungeon.occupant1, Icons.person),
                  _buildInfoCard(
                      'Ocupante II', _dungeon.occupant2, Icons.people),
                  _buildInfoCard('Líder', _dungeon.leader, Icons.star),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3a3a3a),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade600),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.record_voice_over,
                                color: Colors.amber.shade400),
                            const SizedBox(width: 8),
                            Text(
                              'Rumores',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildRumorItem('1', _dungeon.rumor1),
                      ],
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

  Widget _buildRoomsGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade700, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
              Icon(Icons.room_preferences, color: Colors.amber.shade400),
              const SizedBox(width: 8),
              Text(
                'Salas da Masmorra',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade400,
                    ),
              ),
              const Spacer(),
              Text(
                '${_dungeon.rooms.length} salas',
                style: TextStyle(
                  color: Colors.amber.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Colors.amber),
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
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade600),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.amber.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade300,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRumorItem(String number, String rumor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.amber.shade600,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade400),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              rumor,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    final isEntrance = room.index == 1;
    final isBoss = room.index == _dungeon.roomsCount;

    Color cardColor = const Color(0xFF3a3a3a);
    Color borderColor = Colors.amber.shade600;
    Color headerColor = Colors.amber.shade400;
    IconData roomIcon = Icons.room;

    if (isEntrance) {
      cardColor = const Color(0xFF4a3a2a);
      borderColor = Colors.amber.shade500;
      headerColor = Colors.amber.shade300;
      roomIcon = Icons.input;
    } else if (isBoss) {
      cardColor = const Color(0xFF3a2a2a);
      borderColor = Colors.red.shade600;
      headerColor = Colors.red.shade400;
      roomIcon = Icons.warning;
    }

    return GestureDetector(
      onTap: () => _showRoomDetails(room),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
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
                Icon(roomIcon, color: headerColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sala ${room.index}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: headerColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isEntrance)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade600,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.amber.shade400),
                    ),
                    child: const Text(
                      'ENTRADA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isBoss)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.shade400),
                    ),
                    child: const Text(
                      'BOSS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRoomProperty('Tipo', room.type, Icons.category),
                    _buildRoomProperty('Ar', room.air, Icons.air),
                    _buildRoomProperty('Cheiro', room.smell, Icons.air),
                    _buildRoomProperty('Som', room.sound, Icons.volume_up),
                    _buildRoomProperty('Item', room.item, Icons.inventory),
                    if (room.specialItem.isNotEmpty && room.specialItem != '—')
                      _buildRoomProperty(
                          'Item Especial', room.specialItem, Icons.star),
                    if (room.monster1.isNotEmpty && room.monster1 != '—')
                      _buildRoomProperty(
                          'Monstro', _buildMonsterText(room), Icons.pets),
                    if (room.trap.isNotEmpty && room.trap != '—')
                      _buildRoomProperty('Armadilha', room.trap, Icons.warning),
                    if (room.specialTrap.isNotEmpty && room.specialTrap != '—')
                      _buildRoomProperty('Armadilha Especial', room.specialTrap,
                          Icons.dangerous),
                    if (room.roomCommon.isNotEmpty && room.roomCommon != '—')
                      _buildRoomProperty(
                          'Sala Comum', room.roomCommon, Icons.room),
                    if (room.roomSpecial.isNotEmpty && room.roomSpecial != '—')
                      _buildRoomProperty('Sala Especial', room.roomSpecial,
                          Icons.architecture),
                    if (room.roomSpecial2.isNotEmpty &&
                        room.roomSpecial2 != '—')
                      _buildRoomProperty(
                          'Sala Especial 2', room.roomSpecial2, Icons.castle),
                    if (room.treasure.isNotEmpty &&
                        room.treasure != 'Nenhum' &&
                        room.treasure != 'Nenhum Tesouro')
                      _buildRoomProperty(
                          'Tesouro', room.treasure, Icons.diamond),
                    if (room.specialTreasure.isNotEmpty &&
                        room.specialTreasure != '—')
                      _buildRoomProperty('Tesouro Especial',
                          room.specialTreasure, Icons.diamond),
                    if (room.magicItem.isNotEmpty && room.magicItem != '—')
                      _buildRoomProperty(
                          'Item Mágico', room.magicItem, Icons.auto_awesome),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: headerColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: headerColor.withOpacity(0.3)),
              ),
              child: Text(
                'Clique para mais detalhes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: headerColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomProperty(String label, String value, IconData icon) {
    if (value.isEmpty ||
        value == 'Nenhum som especial' ||
        value == 'Sem cheiro especial') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: Colors.amber.shade400),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade300,
                  ),
                ),
                Text(
                  value.length > 40 ? '${value.substring(0, 40)}...' : value,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
