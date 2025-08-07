// presentation/features/turn_monitor/turn_monitor_page.dart

import 'package:flutter/material.dart';
import '../../../models/turn_monitor.dart';
import '../../../services/turn_monitor_service.dart';
import '../../../theme/app_colors.dart';
import '../../../constants/image_path.dart';
import '../../shared/widgets/action_button.dart';
import '../../shared/widgets/custom_text_field.dart';

class TurnMonitorPage extends StatefulWidget {
  const TurnMonitorPage({super.key});

  @override
  State<TurnMonitorPage> createState() => _TurnMonitorPageState();
}

class _TurnMonitorPageState extends State<TurnMonitorPage> {
  late TurnMonitorService _service;

  // Controllers para dados do grupo
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupMovementController =
      TextEditingController();
  final TextEditingController _movementPerTurnController =
      TextEditingController();
  final TextEditingController _maxMovementController = TextEditingController();
  final TextEditingController _masterNotesController = TextEditingController();

  // Controllers para encontros
  final TextEditingController _creatureController = TextEditingController();
  final TextEditingController _maxHpController = TextEditingController();
  final TextEditingController _currentHpController = TextEditingController();
  final TextEditingController _encounterNotesController =
      TextEditingController();

  // Estado da interface
  bool _showGroupDataForm = false;
  bool _showEncounterForm = false;
  bool _showDoorForm = false;
  bool _showTrapForm = false;
  bool _showReactionForm = false;
  int _selectedTurnForEdit = -1;
  int _selectedEncounterForEdit = -1;

  // Estado dos recursos
  bool _hasTorch = false;
  bool _hasLantern = false;
  int _torchTurns = 6;
  int _lanternTurns = 24;

  @override
  void initState() {
    super.initState();
    _service = TurnMonitorService();
    _loadInitialData();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupMovementController.dispose();
    _movementPerTurnController.dispose();
    _maxMovementController.dispose();
    _masterNotesController.dispose();
    _creatureController.dispose();
    _maxHpController.dispose();
    _currentHpController.dispose();
    _encounterNotesController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final groupData = _service.groupData;
    _groupNameController.text = groupData.groupName;
    _groupMovementController.text = groupData.groupMovement.toString();
    _movementPerTurnController.text = groupData.movementPerTurn.toString();
    _maxMovementController.text = groupData.maxMovement.toString();
    _masterNotesController.text = groupData.masterNotes;
    _hasTorch = groupData.hasTorch;
    _hasLantern = groupData.hasLantern;
    _torchTurns = groupData.torchTurns;
    _lanternTurns = groupData.lanternTurns;
  }

  void _saveGroupData() {
    final groupData = GroupData(
      groupName: _groupNameController.text,
      groupMovement: int.tryParse(_groupMovementController.text) ?? 0,
      movementPerTurn: int.tryParse(_movementPerTurnController.text) ?? 0,
      maxMovement: int.tryParse(_maxMovementController.text) ?? 0,
      masterNotes: _masterNotesController.text,
      hasTorch: _hasTorch,
      hasLantern: _hasLantern,
      torchTurns: _torchTurns,
      lanternTurns: _lanternTurns,
    );

    _service.updateGroupData(groupData);
    setState(() {
      _showGroupDataForm = false;
    });
  }

  void _addTurnWithAction(ActionType action) {
    bool isExploration = false;
    bool isResting = false;
    bool isSearching = false;
    bool isMoving = false;
    bool isDoorAction = false;
    bool isTrapAction = false;
    int? movementDistance;

    switch (action) {
      case ActionType.move:
        isMoving = true;
        movementDistance = _service.calculateMovement(MovementType.normal);
        break;
      case ActionType.moveExploration:
        isMoving = true;
        isExploration = true;
        movementDistance = _service.calculateMovement(MovementType.exploration);
        break;
      case ActionType.rest:
        isResting = true;
        break;
      case ActionType.search:
      case ActionType.searchSecret:
        isSearching = true;
        break;
      case ActionType.searchTraps:
        isSearching = true;
        isTrapAction = true;
        break;
      case ActionType.openDoor:
      case ActionType.breakDoor:
      case ActionType.forceDoor:
        isDoorAction = true;
        break;
      case ActionType.disarmTrap:
        isTrapAction = true;
        break;
      case ActionType.combat:
        // Combate não é exploração
        break;
      default:
        break;
    }

    final turnAction = TurnAction(
      type: action,
      description: action.description,
      movementDistance: movementDistance,
      isExploration: isExploration,
      isResting: isResting,
      isSearching: isSearching,
    );

    _service.addTurn(
      isExploration: isExploration,
      isResting: isResting,
      isSearching: isSearching,
      isMoving: isMoving,
      isDoorAction: isDoorAction,
      isTrapAction: isTrapAction,
      notes: action.description,
      action: turnAction,
    );
    setState(() {});
  }

  void _addRandomEncounter() {
    final hasLight =
        _service.groupData.hasTorch || _service.groupData.hasLantern;
    final hasNoise = false; // Pode ser implementado baseado em ações anteriores

    if (_service.checkForEncounter(hasLight: hasLight, hasNoise: hasNoise)) {
      final encounter = _service.generateRandomEncounter();
      _service.addEncounter(encounter);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Encontro gerado: ${encounter.creature} (Roll: ${encounter.roll}) - Distância: ${encounter.distance}m',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum encontro neste turno'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _openEncounterForm() {
    setState(() {
      _showEncounterForm = true;
      _selectedEncounterForEdit = -1;
      _creatureController.clear();
      _maxHpController.clear();
      _currentHpController.clear();
      _encounterNotesController.clear();
    });
  }

  void _saveEncounter() {
    final encounter = Encounter(
      roll: int.tryParse(_creatureController.text) ?? 1,
      creature: _creatureController.text,
      maxHp: int.tryParse(_maxHpController.text) ?? 10,
      currentHp: int.tryParse(_currentHpController.text) ?? 10,
      notes: _encounterNotesController.text,
    );

    if (_selectedEncounterForEdit >= 0) {
      _service.updateEncounter(_selectedEncounterForEdit, encounter);
    } else {
      _service.addEncounter(encounter);
    }

    setState(() {
      _showEncounterForm = false;
      _selectedEncounterForEdit = -1;
    });
  }

  void _editEncounter(int index) {
    final encounter = _service.encounters[index];
    _creatureController.text = encounter.creature;
    _maxHpController.text = encounter.maxHp.toString();
    _currentHpController.text = encounter.currentHp.toString();
    _encounterNotesController.text = encounter.notes;

    setState(() {
      _showEncounterForm = true;
      _selectedEncounterForEdit = index;
    });
  }

  void _removeEncounter(int index) {
    _service.removeEncounter(index);
    setState(() {});
  }

  void _testDoorAction(DoorType doorType) {
    TurnResult result;
    String description = '';

    switch (doorType) {
      case DoorType.locked:
        result = _service.testLockedDoor(hasThiefTools: true, isThief: false);
        description = 'Testando porta trancada';
        break;
      case DoorType.stuck:
        result = _service.testStuckDoor(strengthModifier: 2);
        description = 'Testando porta emperrada';
        break;
      case DoorType.secret:
        result = _service.testSecretDoor(isElf: false, isSearching: true);
        description = 'Procurando porta secreta';
        break;
      default:
        result = const TurnResult(
          success: true,
          description: 'Porta aberta normalmente',
        );
        break;
    }

    _service.addTurn(isDoorAction: true, notes: description, result: result);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.description),
        backgroundColor: result.success ? AppColors.primary : Colors.red,
      ),
    );
  }

  void _testTrapAction(TrapType trapType, bool isSearching) {
    TurnResult result;
    String description = '';

    if (isSearching) {
      result = _service.testSearchTraps(isThief: false, isElf: false);
      description = 'Procurando armadilhas';
    } else {
      result = _service.testDisarmTrap(isThief: false);
      description = 'Desarmando armadilha';
    }

    _service.addTurn(isTrapAction: true, notes: description, result: result);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.description),
        backgroundColor: result.success ? AppColors.primary : Colors.red,
      ),
    );
  }

  void _testReaction() {
    final result = _service.testReaction(charismaModifier: 1);

    _service.addTurn(notes: 'Teste de Reação', result: result);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reação: ${result.description}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 16),
        child: Column(
          children: [
            // Header com botões de ação
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Monitor de Turnos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.clear_all, color: AppColors.primary),
                    tooltip: 'Limpar Todos os Dados',
                    onPressed: () {
                      _service.clear();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dados limpos!'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.download, color: AppColors.primary),
                    tooltip: 'Exportar Dados',
                    onPressed: () {
                      final data = _service.exportToText();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dados exportados!'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Conteúdo principal
            Expanded(
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Controles e Ações - 40%
        Expanded(flex: 4, child: _buildControlsSection()),
        const SizedBox(width: 16),
        // Resultados e Listas - 60%
        Expanded(flex: 6, child: _buildResultsSection()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Controles e Ações
        Expanded(flex: 1, child: _buildControlsSection()),
        const SizedBox(height: 16),
        // Resultados e Listas
        Expanded(flex: 2, child: _buildResultsSection()),
      ],
    );
  }

  Widget _buildControlsSection() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildGroupDataSection(),
          const SizedBox(height: 16),
          _buildResourcesSection(),
          const SizedBox(height: 16),
          _buildTurnActionsSection(),
          const SizedBox(height: 16),
          _buildSpecialActionsSection(),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTurnsSection(),
          const SizedBox(height: 16),
          _buildEncountersSection(),
        ],
      ),
    );
  }

  Widget _buildGroupDataSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Dados Críticos do Grupo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_showGroupDataForm) ...[
            CustomTextField(
              controller: _groupNameController,
              label: 'Nome do Grupo',
              hint: 'Digite o nome do grupo',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _groupMovementController,
                    label: 'Mov. do Grupo',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _movementPerTurnController,
                    label: 'Mov. por Turno',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _maxMovementController,
                    label: 'Mov. Máximo',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _masterNotesController,
              label: 'Anotações do Mestre',
              hint: 'Digite suas anotações...',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ActionButton(
              onPressed: _saveGroupData,
              text: 'Salvar Dados',
              icon: Icons.save,
            ),
          ] else ...[
            _buildGroupDataDisplay(),
            const SizedBox(height: 12),
            ActionButton(
              onPressed: () {
                setState(() {
                  _showGroupDataForm = !_showGroupDataForm;
                });
              },
              text: 'Editar Dados',
              icon: Icons.edit,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGroupDataDisplay() {
    final groupData = _service.groupData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome: ${groupData.groupName.isEmpty ? "Não definido" : groupData.groupName}',
        ),
        Text('Movimento do Grupo: ${groupData.groupMovement}'),
        Text('Movimento por Turno: ${groupData.movementPerTurn}'),
        Text('Movimento Máximo: ${groupData.maxMovement}'),
        if (groupData.masterNotes.isNotEmpty)
          Text('Anotações: ${groupData.masterNotes}'),
      ],
    );
  }

  Widget _buildResourcesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Recursos e Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Iluminação:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _hasTorch,
                                    onChanged: (value) {
                                      setState(() {
                                        _hasTorch = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text('Tocha (6 turnos)'),
                                ],
                              ),
                              if (_hasTorch)
                                Text('Turnos restantes: $_torchTurns'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _hasLantern,
                                    onChanged: (value) {
                                      setState(() {
                                        _hasLantern = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text('Lanterna (24 turnos)'),
                                ],
                              ),
                              if (_hasLantern)
                                Text('Turnos restantes: $_lanternTurns'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contadores:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Exploração: ${_service.explorationTurns} turnos'),
                    Text('Descanso: ${_service.restTurns} turnos'),
                    if (_service.groupData.isExhausted)
                      const Text(
                        '⚠️ GRUPO EXAUSTO',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTurnActionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.play_arrow, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Ações Básicas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Movimento:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionButton(
                          onPressed: () => _addTurnWithAction(ActionType.move),
                          text: 'Movimento Normal',
                          icon: Icons.directions_walk,
                        ),
                        ActionButton(
                          onPressed: () =>
                              _addTurnWithAction(ActionType.moveExploration),
                          text: 'Movimento Exploração',
                          icon: Icons.explore,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ações:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionButton(
                          onPressed: () => _addTurnWithAction(ActionType.rest),
                          text: 'Descansar',
                          icon: Icons.bedtime,
                        ),
                        ActionButton(
                          onPressed: () =>
                              _addTurnWithAction(ActionType.search),
                          text: 'Procurar',
                          icon: Icons.search,
                        ),
                        ActionButton(
                          onPressed: () =>
                              _addTurnWithAction(ActionType.combat),
                          text: 'Combater',
                          icon: Icons.gps_fixed,
                        ),
                        ActionButton(
                          onPressed: () =>
                              _addTurnWithAction(ActionType.castSpell),
                          text: 'Conjurar Magia',
                          icon: Icons.auto_fix_high,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Procuras Específicas:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionButton(
                          onPressed: () =>
                              _addTurnWithAction(ActionType.searchTraps),
                          text: 'Procurar Armadilhas',
                          icon: Icons.warning,
                        ),
                        ActionButton(
                          onPressed: () =>
                              _addTurnWithAction(ActionType.searchSecret),
                          text: 'Procurar Secreta',
                          icon: Icons.hide_source,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialActionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Ações Especiais',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Portas:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionButton(
                          onPressed: () => _testDoorAction(DoorType.locked),
                          text: 'Porta Trancada',
                          icon: Icons.lock,
                        ),
                        ActionButton(
                          onPressed: () => _testDoorAction(DoorType.stuck),
                          text: 'Porta Emperrada',
                          icon: Icons.block,
                        ),
                        ActionButton(
                          onPressed: () => _testDoorAction(DoorType.secret),
                          text: 'Porta Secreta',
                          icon: Icons.hide_source,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Armadilhas:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionButton(
                          onPressed: () => _testTrapAction(TrapType.dart, true),
                          text: 'Procurar Armadilha',
                          icon: Icons.search,
                        ),
                        ActionButton(
                          onPressed: () =>
                              _testTrapAction(TrapType.dart, false),
                          text: 'Desarmar Armadilha',
                          icon: Icons.build,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  onPressed: _testReaction,
                  text: 'Teste de Reação',
                  icon: Icons.psychology,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  onPressed: _addRandomEncounter,
                  text: 'Verificar Encontro',
                  icon: Icons.casino,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTurnsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Turnos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${_service.turns.length} turnos',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_service.turns.isEmpty)
            const Center(
              child: Text(
                'Nenhum turno registrado',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _service.turns.length,
                itemBuilder: (context, index) {
                  final turn = _service.turns[index];
                  return _buildTurnCard(turn);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEncountersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.casino, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Encontros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              ActionButton(
                onPressed: () => _openEncounterForm(),
                text: 'Adicionar',
                icon: Icons.add,
              ),
            ],
          ),
          if (_showEncounterForm) ...[
            const SizedBox(height: 16),
            _buildEncounterForm(),
          ],
          const SizedBox(height: 16),
          if (_service.encounters.isEmpty)
            const Center(
              child: Text(
                'Nenhum encontro registrado',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _service.encounters.length,
                itemBuilder: (context, index) {
                  final encounter = _service.encounters[index];
                  return _buildEncounterCard(encounter, index);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEncounterForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _creatureController,
                label: 'Criatura',
                hint: 'Nome da criatura',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                controller: _maxHpController,
                label: 'PV Máximo',
                hint: '10',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                controller: _currentHpController,
                label: 'PV Atual',
                hint: '10',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _encounterNotesController,
          label: 'Notas',
          hint: 'Observações sobre o encontro...',
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ActionButton(
              onPressed: _saveEncounter,
              text: _selectedEncounterForEdit >= 0 ? 'Atualizar' : 'Salvar',
              icon: Icons.save,
            ),
            const SizedBox(width: 12),
            ActionButton(
              onPressed: () {
                setState(() {
                  _showEncounterForm = false;
                  _selectedEncounterForEdit = -1;
                });
              },
              text: 'Cancelar',
              icon: Icons.cancel,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEncounterCard(Encounter encounter, int index) {
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${encounter.creature} (Roll: ${encounter.roll})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    ActionButton(
                      onPressed: () => _editEncounter(index),
                      text: 'Editar',
                      icon: Icons.edit,
                    ),
                    const SizedBox(width: 8),
                    ActionButton(
                      onPressed: () => _removeEncounter(index),
                      text: 'Remover',
                      icon: Icons.delete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('PV: ${encounter.currentHp}/${encounter.maxHp}'),
            if (encounter.reaction.isNotEmpty)
              Text('Reação: ${encounter.reaction}'),
            if (encounter.distance > 0)
              Text('Distância: ${encounter.distance}m'),
            if (encounter.isSurprise)
              const Text('Surpresa: Sim', style: TextStyle(color: Colors.red)),
            if (encounter.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                encounter.notes,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTurnCard(Turn turn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Turno ${turn.number}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  if (turn.isExploration)
                    const Icon(Icons.explore, color: Colors.blue, size: 16),
                  if (turn.isEncounter)
                    const Icon(Icons.casino, color: Colors.orange, size: 16),
                  if (turn.isFighting)
                    const Icon(Icons.gps_fixed, color: Colors.red, size: 16),
                  if (turn.isResting)
                    const Icon(Icons.bedtime, color: Colors.green, size: 16),
                  if (turn.isSearching)
                    const Icon(Icons.search, color: Colors.yellow, size: 16),
                  if (turn.isMoving)
                    const Icon(
                      Icons.directions_walk,
                      color: Colors.cyan,
                      size: 16,
                    ),
                  if (turn.isDoorAction)
                    const Icon(
                      Icons.door_front_door,
                      color: Colors.purple,
                      size: 16,
                    ),
                  if (turn.isTrapAction)
                    const Icon(Icons.warning, color: Colors.red, size: 16),
                ],
              ),
            ],
          ),
          if (turn.action != null) ...[
            const SizedBox(height: 8),
            Text(
              'Ação: ${turn.action!.description}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (turn.action!.movementDistance != null)
              Text('Distância: ${turn.action!.movementDistance}m'),
          ],
          if (turn.result != null) ...[
            const SizedBox(height: 8),
            Text(
              'Resultado: ${turn.result!.description}',
              style: TextStyle(
                color: turn.result!.success ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (turn.result!.damage != null)
              Text('Dano: ${turn.result!.damage}'),
          ],
          if (turn.notes != null && turn.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(turn.notes!, style: const TextStyle(color: Colors.white70)),
          ],
          if (turn.timestamp != null) ...[
            const SizedBox(height: 8),
            Text(
              '${turn.timestamp!.hour.toString().padLeft(2, '0')}:${turn.timestamp!.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
