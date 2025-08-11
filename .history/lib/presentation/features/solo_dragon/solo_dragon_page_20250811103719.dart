import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/solo_dragon/solo_dragon_service.dart';
import '../../shared/widgets/action_button.dart';
import '../../shared/widgets/responsive_layout.dart';

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
  bool _entranceInvestigated = false;
  List<String> _foundClues = []; // Pistas encontradas para mostrar no quadro

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
      _lastOracle = null;
      _entranceInvestigated = false;
      _foundClues = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ResponsiveBuilder(
          builder: (context, isMobile, isTablet, isDesktop) {
            if (isDesktop || isTablet) {
              return _buildDesktopLayout();
            }
            // Mobile fallback: previous stacked scroll layout
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  if (_setup != null) ...[
                    _buildDungeonInfo(),
                    const SizedBox(height: 16),
                    _buildOracleSection(),
                    const SizedBox(height: 16),
                    _buildRumorBoard(),
                    const SizedBox(height: 16),
                    _buildRoomsSection(),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column: Info, Oracle, Rumors
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                if (_setup != null) ...[
                  _buildDungeonInfo(),
                  const SizedBox(height: 16),
                  _buildOracleSection(),
                  const SizedBox(height: 16),
                  _buildRumorBoard(),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Right column: Rooms grid/list with controls
        Expanded(flex: 7, child: _buildRoomsRightPanel()),
      ],
    );
  }

  Widget _buildRoomsRightPanel() {
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
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              const SizedBox(width: 12),
              ActionButton(
                text: _rooms.isEmpty ? 'Gerar Primeira Sala' : 'Próxima Sala',
                icon: Icons.arrow_forward,
                onPressed: _generateNextRoom,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _rooms.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma sala gerada ainda.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _rooms.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: AppColors.border),
                    itemBuilder: (context, index) =>
                        _buildRoomCard(_rooms.length - 1 - index),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(int index) {
    final room = _rooms[index];
    final bool isCurrent = index == _currentRoomIndex;
    return InkWell(
      onTap: () {
        setState(() {
          _currentRoomIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrent
              ? AppColors.primaryDark.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrent ? AppColors.primaryLight : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.door_front_door, color: AppColors.primaryLight),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sala ${index + 1} — ${room.type}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${room.roomTypeRoll} (2d6)',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _buildRoomSummaryRow(
              'Portas',
              '${room.doorsRoll} — ${_dashIfEmpty(room.doors)}',
            ),
            _buildRoomSummaryRow(
              'Conteúdo',
              room.contentTriggeredFromDoors
                  ? '${room.contentRoll} — ${_dashIfEmpty(room.content)}'
                  : '—',
            ),
            _buildRoomSummaryRow(
              'Tesouro',
              room.treasureTriggeredFromContent
                  ? '${room.treasureRoll} — ${_dashIfEmpty(room.treasure)}'
                  : '—',
            ),
            _buildRoomSummaryRow(
              'Armadilha',
              room.trapTriggeredFromContent
                  ? '${room.trapRoll} — ${_dashIfEmpty(room.trap)}'
                  : '—',
            ),
            if (room.trapTriggeredFromContent && room.trap.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  getTrapDetail(room.trap),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            _buildRoomSummaryRow(
              'Encontro',
              room.encounterTriggeredFromTrap
                  ? '${room.encounterRoll} — ${_dashIfEmpty(room.encounter)}'
                  : '—',
            ),
            if (room.encounterTriggeredFromTrap)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _rollEncounterAndShowTable,
                  icon: const Icon(Icons.casino, size: 16, color: Colors.white),
                  label: const Text(
                    'Rolar Encontro',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            // Status de investigação
            if (room.investigation != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: room.investigation!.found
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: room.investigation!.found
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      room.investigation!.found
                          ? Icons.search
                          : Icons.search_off,
                      size: 16,
                      color: room.investigation!.found
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      room.investigation!.found
                          ? 'Pista encontrada'
                          : 'Nada encontrado',
                      style: TextStyle(
                        color: room.investigation!.found
                            ? Colors.green
                            : Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else if (room.type.contains('Câmara'))
              Row(
                children: [
                  Expanded(child: Container()),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: () => _investigateRoom(index),
                      icon: Icon(Icons.search, size: 16),
                      label: Text('Investigar', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
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
          Row(
            children: [
              Text(
                'Masmorra',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (!_entranceInvestigated)
                ActionButton(
                  text: 'Investigar Entrada',
                  icon: Icons.search,
                  onPressed: _investigateEntrance,
                ),
            ],
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
          if (_entranceInvestigated)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    'Entrada investigada',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
          Text(
            'Quadro de Rumores (A5.2)',
            style: TextStyle(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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
          // Linhas
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
          // Pistas encontradas
          if (_foundClues.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.search, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Pistas Encontradas',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._foundClues.map(
                    (clue) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_right, color: Colors.blue, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              clue,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (board.isFinalMysteryRevealed)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mistério desvendado! Role 1d6 na Subtabela A e combine com B/C/D (A5.7) para a Câmara Final.',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _rollFinalChamberAndShow,
                    icon: const Icon(
                      Icons.casino,
                      size: 16,
                      color: Colors.amber,
                    ),
                    label: const Text(
                      'Rolar Câmara Final',
                      style: TextStyle(color: Colors.amber),
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
    final hasRooms = _rooms.isNotEmpty;
    final int safeIndex = hasRooms
        ? (_currentRoomIndex >= _rooms.length
              ? _rooms.length - 1
              : _currentRoomIndex)
        : 0;

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
              if (hasRooms)
                Text(
                  'Sala ${safeIndex + 1}/${_rooms.length}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (!hasRooms)
            ActionButton(
              text: 'Gerar Primeira Sala',
              icon: Icons.add,
              onPressed: _generateNextRoom,
            )
          else if (safeIndex < _rooms.length)
            _buildCurrentRoom(safeIndex)
          else
            ActionButton(
              text: 'Próxima Sala',
              icon: Icons.arrow_forward,
              onPressed: _generateNextRoom,
            ),
        ],
      ),
    );
  }

  String _dashIfEmpty(String? value) =>
      (value == null || value.isEmpty) ? '—' : value;

  Widget _buildCurrentRoom([int? index]) {
    final idx = index ?? _currentRoomIndex;
    final room = _rooms[idx];
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
                'Sala ${idx + 1}',
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
                '${room.doorsRoll} (d6+d6) — ${_dashIfEmpty(room.doors)}',
              ),
              // Conteúdo/Tesouro/Armadilha/Encontro com placeholder
              _buildRoomDetail(
                'Conteúdo',
                room.contentTriggeredFromDoors
                    ? '${room.contentRoll} (d6+d6) — ${_dashIfEmpty(room.content)}'
                    : '—',
              ),
              _buildRoomDetail(
                'Tesouro',
                room.treasureTriggeredFromContent
                    ? '${room.treasureRoll} (2d6) — ${_dashIfEmpty(room.treasure)}'
                    : '—',
              ),
              _buildRoomDetail(
                'Armadilha',
                room.trapTriggeredFromContent
                    ? '${room.trapRoll} (d6+d6) — ${_dashIfEmpty(room.trap)}'
                    : '—',
              ),
              if (room.trapTriggeredFromContent && room.trap.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    getTrapDetail(room.trap),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              _buildRoomDetail(
                'Encontro',
                room.encounterTriggeredFromTrap
                    ? '${room.encounterRoll} (d6+d6) — ${_dashIfEmpty(room.encounter)}'
                    : '—',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (idx > 0)
              ActionButton(
                text: 'Sala Anterior',
                icon: Icons.arrow_back,
                onPressed: () {
                  setState(() {
                    _currentRoomIndex = idx - 1;
                  });
                },
              ),
            const Spacer(),
            ActionButton(
              text: 'Próxima Sala',
              icon: Icons.arrow_forward,
              onPressed: () {
                _generateNextRoom();
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

  void _rollOracle() {
    final roll = _service.rollD6();
    setState(() {
      _lastOracle = SoloDragonService.oracleAnswerFor(roll);
    });
  }

  void _rollEncounterAndShowTable() {
    // Rola primeiro e mostra um resumo rápido
    final roll = _service.rollD6D6();
    final text = _service.getEventTextForRoll(roll, EventColumn.encounter);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Encontro $roll: $text'),
        backgroundColor: AppColors.primaryDark,
      ),
    );

    // Abre o pop-up já com o resultado engatilhado
    showDialog(
      context: context,
      builder: (context) {
        final all = _service.allEventRolls();
        return AlertDialog(
          backgroundColor: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              const Icon(Icons.visibility, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Tabela A5.5 - Encontros',
                style: TextStyle(color: Colors.white),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.casino, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    'Rolado: $roll — $text',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Use 1d6 para dezena e 1d6 para unidade (11..66).',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  for (final r in all)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '$r — ${_service.getEventTextForRoll(r, EventColumn.encounter)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
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
        );
      },
    );
  }

  // Removido: versão antiga do diálogo manual da Câmara Final substituída por _rollFinalChamberAndShow

  void _rollFinalChamberAndShow() {
    // Rola primeiro e mostra um resumo rápido
    final result = _service.rollFinalChamber();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Câmara Final: A=${result.aRoll} (${result.aText}) | ${result.subTable}=${result.subRoll} (${result.subText})',
        ),
        backgroundColor: AppColors.primaryDark,
      ),
    );

    // Abre o diálogo já com o resultado
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: const [
            Icon(Icons.account_tree, color: Colors.white),
            SizedBox(width: 8),
            Text('Câmara Final (A5.7)', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SizedBox(
          width: 620,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resultado rolado automaticamente:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
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
                      'Subtabela A: ${result.aRoll} — ${result.aText}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Subtabela ${result.subTable}: ${result.subRoll} — ${result.subText}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
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

  void _investigateEntrance() {
    if (_entranceInvestigated) return;

    final found = _service.rollInvestigationFound();

    setState(() {
      _entranceInvestigated = true;
    });

    if (found) {
      // Aplicar a lógica de investigação no quadro de rumores
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

      final eliminatedRumor = _setup!.rumorBoard.getRumorAt(rowIdx);
      String clueDescription = '';

      switch (column) {
        case ColumnId.a:
          clueDescription = eliminatedRumor.createdBy;
          break;
        case ColumnId.b:
          clueDescription = eliminatedRumor.purpose;
          break;
        case ColumnId.c:
          clueDescription = eliminatedRumor.target;
          break;
      }

      setState(() {
        _setup!.rumorBoard.eliminate(column, rowIdx);
        _foundClues.add('Entrada: $clueDescription');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pista encontrada na entrada! Rumo eliminado.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nada encontrado na entrada.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _investigateRoom(int roomIndex) {
    if (roomIndex >= _rooms.length) return;

    // Verificar se a sala já foi investigada
    if (_rooms[roomIndex].investigation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Esta sala já foi investigada.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Verificar se é uma Câmara (investigação só acontece em Câmaras)
    final room = _rooms[roomIndex];
    if (!room.type.contains('Câmara')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Investigação só é possível em Câmaras.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final found = _service.rollInvestigationFound();
    final result = InvestigationResult(
      found: found,
      description: found
          ? 'Pista encontrada na sala'
          : 'Nada encontrado na sala',
    );

    setState(() {
      _rooms[roomIndex] = _rooms[roomIndex].withInvestigation(result);
      if (found) {
        // Aplicar a lógica de investigação no quadro de rumores
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

        final eliminatedRumor = _setup!.rumorBoard.getRumorAt(rowIdx);
        String clueDescription = '';

        switch (column) {
          case ColumnId.a:
            clueDescription = eliminatedRumor.createdBy;
            break;
          case ColumnId.b:
            clueDescription = eliminatedRumor.purpose;
            break;
          case ColumnId.c:
            clueDescription = eliminatedRumor.target;
            break;
        }

        _setup!.rumorBoard.eliminate(column, rowIdx);
        _foundClues.add('Sala ${roomIndex + 1}: $clueDescription');
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          found
              ? 'Pista encontrada na sala ${roomIndex + 1}!'
              : 'Nada encontrado na sala ${roomIndex + 1}.',
        ),
        backgroundColor: found ? Colors.green : Colors.orange,
      ),
    );
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
