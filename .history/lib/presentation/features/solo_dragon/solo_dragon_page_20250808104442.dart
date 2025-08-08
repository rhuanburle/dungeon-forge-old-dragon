import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/solo_dragon/solo_dragon_service.dart';
import '../../shared/widgets/action_button.dart';

class SoloDragonPage extends StatefulWidget {
  const SoloDragonPage({super.key});

  @override
  State<SoloDragonPage> createState() => _SoloDragonPageState();
}

class _SoloDragonPageState extends State<SoloDragonPage> {
  final SoloDragonService _service = SoloDragonService();

  // Estado persistente
  DungeonSetup? _setup;
  String? _lastOracle;
  List<SoloRoom> _rooms = [];
  int _currentRoomIndex = 0;
  bool _isFinalRoom = false;

  @override
  void initState() {
    super.initState();
    _startNewAdventure();
  }

  void _startNewAdventure() {
    setState(() {
      _setup = _service.generateDungeonSetupWithRumors();
      _rooms = [];
      _currentRoomIndex = 0;
      _isFinalRoom = false;
      _lastOracle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.casino, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Solo Dragon',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ActionButton(
                    text: 'Nova Aventura',
                    icon: Icons.refresh,
                    onPressed: _startNewAdventure,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_setup != null) ...[
                // Informações da Masmorra
                _buildDungeonInfo(),
                const SizedBox(height: 16),

                // Oráculo
                _buildOracleSection(),
                const SizedBox(height: 16),

                // Quadro de Rumores
                _buildRumorBoard(),
                const SizedBox(height: 16),

                // Salas
                _buildRoomsSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDungeonInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masmorra',
            style: TextStyle(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildInfoItem('Tipo', _setup!.type)),
              Expanded(child: _buildInfoItem('Entrada', _setup!.entrance)),
              Expanded(
                child: _buildInfoItem('Rolagem', '${_setup!.typeRoll} (2d6)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOracleSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Oráculo (1d6)',
            style: TextStyle(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ActionButton(
                text: 'Consultar Oráculo',
                icon: Icons.casino,
                onPressed: _rollOracle,
              ),
              const SizedBox(width: 16),
              if (_lastOracle != null)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryDark),
                    ),
                    child: Text(
                      _lastOracle!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRumorBoard() {
    final board = _setup!.rumorBoard;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Quadro de Rumores (A5.2)',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              ActionButton(
                text: 'Investigar',
                icon: Icons.search,
                onPressed: _investigate,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Cabeçalho
          Row(
            children: [
              const SizedBox(width: 80),
              Expanded(
                child: Text(
                  'A (Criado por...)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'B (Para...)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'C (Um(a)...)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Linhas do quadro
          for (int i = 0; i < 3; i++) ...[
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Rumor ${i + 1}:',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    board.getRumorAt(i).createdBy,
                    style: _getCellStyle(board.isEliminated(ColumnId.a, i)),
                  ),
                ),
                Expanded(
                  child: Text(
                    board.getRumorAt(i).purpose,
                    style: _getCellStyle(board.isEliminated(ColumnId.b, i)),
                  ),
                ),
                Expanded(
                  child: Text(
                    board.getRumorAt(i).target,
                    style: _getCellStyle(board.isEliminated(ColumnId.c, i)),
                  ),
                ),
              ],
            ),
            if (i < 2) Divider(color: AppColors.border, height: 16),
          ],
          const SizedBox(height: 12),
          // Descobertas
          if (board.hasDiscoveryA) _buildDiscovery('A', board.remainingA!),
          if (board.hasDiscoveryB) _buildDiscovery('B', board.remainingB!),
          if (board.hasDiscoveryC) _buildDiscovery('C', board.remainingC!),
          if (board.isFinalMysteryRevealed)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mistério desvendado! Vá para a Câmara Final.',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDiscovery(String column, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green),
      ),
      child: Text(
        'Descoberta $column: $value',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
      ),
    );
  }

  TextStyle _getCellStyle(bool eliminated) {
    return TextStyle(
      color: eliminated ? AppColors.textSecondary : Colors.white,
      decoration: eliminated ? TextDecoration.lineThrough : TextDecoration.none,
    );
  }

  Widget _buildRoomsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Exploração',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (_rooms.isNotEmpty)
                Text(
                  'Sala ${_currentRoomIndex + 1}/${_rooms.length}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_rooms.isEmpty)
            ActionButton(
              text: 'Gerar Primeira Sala',
              icon: Icons.add,
              onPressed: _generateNextRoom,
            )
          else if (_currentRoomIndex < _rooms.length)
            _buildCurrentRoom()
          else if (_isFinalRoom)
            _buildFinalRoom()
          else
            ActionButton(
              text: 'Próxima Sala',
              icon: Icons.arrow_forward,
              onPressed: () {
                _generateNextRoom();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentRoom() {
    final room = _rooms[_currentRoomIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primaryDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sala ${_currentRoomIndex + 1}',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildRoomDetail(
                'Tipo',
                '${room.roomTypeRoll} (2d6) — ${room.type}',
              ),
              _buildRoomDetail(
                'Portas',
                '${room.doorsRoll} (d6+d6) — ${room.doors}',
              ),
              if (room.contentTriggeredFromDoors) ...[
                _buildRoomDetail(
                  'Conteúdo',
                  '${room.contentRoll} (d6+d6) — ${room.content}',
                ),
                if (room.treasureTriggeredFromContent)
                  _buildRoomDetail(
                    'Tesouro',
                    '${room.treasureRoll} (2d6) — ${room.treasure}',
                  ),
                if (room.trapTriggeredFromContent) ...[
                  _buildRoomDetail(
                    'Armadilha',
                    '${room.trapRoll} (d6+d6) — ${room.trap}',
                  ),
                  if (room.encounterTriggeredFromTrap)
                    _buildRoomDetail(
                      'Encontro',
                      '${room.encounterRoll} (d6+d6) — ${room.encounter}',
                    ),
                ],
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (_currentRoomIndex > 0)
              ActionButton(
                text: 'Sala Anterior',
                icon: Icons.arrow_back,
                onPressed: () {
                  setState(() {
                    _currentRoomIndex--;
                  });
                },
              ),
            const Spacer(),
            ActionButton(
              text: 'Próxima Sala',
              icon: Icons.arrow_forward,
              onPressed: () {
                setState(() {
                  _currentRoomIndex++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalRoom() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Câmara Final',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Você chegou ao clímax da aventura! Use o oráculo para determinar o que acontece.',
            style: TextStyle(color: Colors.amber),
          ),
        ],
      ),
    );
  }

  void _rollOracle() {
    final roll = _service.rollD6();
    setState(() {
      _lastOracle = SoloDragonService.oracleAnswerFor(roll);
    });
  }

  void _investigate() {
    if (_setup == null) return;

    if (_service.rollInvestigationFound()) {
      final colRoll = _service.rollD6();
      final rowRoll = _service.rollD6();
      final column = colRoll <= 2
          ? ColumnId.a
          : colRoll <= 4
          ? ColumnId.b
          : ColumnId.c;
      final rowIdx = rowRoll <= 2
          ? 0
          : rowRoll <= 4
          ? 1
          : 2;

      setState(() {
        _setup!.rumorBoard.eliminate(column, rowIdx);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pista encontrada! Rumo eliminado.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nada encontrado.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _generateNextRoom() {
    // Determina o contexto da sala
    RoomContext context;
    if (_rooms.isEmpty) {
      context = RoomContext.enteringDungeon;
    } else {
      final lastRoom = _rooms.last;
      if (lastRoom.type.contains('Câmara')) {
        context = RoomContext.leavingChamber;
      } else if (lastRoom.type.contains('Corredor')) {
        context = RoomContext.leavingCorridor;
      } else if (lastRoom.type.contains('Escada')) {
        context = RoomContext.leavingStairs;
      } else {
        context = RoomContext.leavingChamber; // fallback
      }
    }

    // Gera a sala usando as tabelas A5.4, A5.5, A5.6
    final newRoom = _service.generateRoom(context);

    setState(() {
      _rooms.add(newRoom);
      _currentRoomIndex = _rooms.length - 1;
    });
  }
}
