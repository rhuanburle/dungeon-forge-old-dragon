// presentation/features/dungeon/dungeon_page.dart

import 'package:flutter/material.dart';
import '../../../enums/table_enums.dart';
import '../../../services/dungeon_generator_refactored.dart';
import '../../../models/dungeon.dart';
import '../../../models/room.dart';
import '../../../theme/app_colors.dart';
import '../../../constants/image_path.dart';
import '../../shared/widgets/dungeon_info_card.dart';
import '../../shared/widgets/action_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../../utils/treasure_resolver.dart';

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

  // Configurações de encontros para ocupantes
  TerrainType _selectedTerrain = TerrainType.subterranean;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.medium;
  PartyLevel _selectedPartyLevel = PartyLevel.beginners;
  bool _useEncounterTables = false;

  // Configurações de tesouros por nível
  TreasureLevel _selectedTreasureLevel = TreasureLevel.level1;
  bool _useTreasureByLevel = false;

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
    final generator = DungeonGeneratorRefactored();
    _dungeon = generator.generate(
      level: 3,
      theme: 'Recuperar artefato',
      customRoomCount: _customRoomCount > 0 ? _customRoomCount : null,
      minRooms: _minRooms > 0 ? _minRooms : null,
      maxRooms: _maxRooms > 0 ? _maxRooms : null,
      terrainType: _useEncounterTables ? _selectedTerrain : null,
      difficultyLevel: _useEncounterTables ? _selectedDifficulty : null,
      partyLevel: _useEncounterTables ? _selectedPartyLevel : null,
      useEncounterTables: _useEncounterTables,
      treasureLevel: _useTreasureByLevel ? _selectedTreasureLevel : null,
      useTreasureByLevel: _useTreasureByLevel,
    );
    setState(() {});
  }

  void _regenerateOccupants() {
    if (!_useEncounterTables) return;

    final generator = DungeonGeneratorRefactored();
    generator.regenerateOccupants(
      terrainType: _selectedTerrain,
      difficultyLevel: _selectedDifficulty,
      partyLevel: _selectedPartyLevel,
    );

    // Regenera a masmorra para aplicar os novos ocupantes
    _generate();
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
            Icon(Icons.add_circle_outline, color: AppColors.primaryDark),
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
              NumberTextField(
                label: 'Quantidade fixa de salas (opcional)',
                hint: 'Ex: 5 (deixe vazio para usar tabela)',
                controller: _roomCountController,
                min: 1,
                max: 50,
              ),
              const SizedBox(height: 16),

              // Mínimo e máximo
              Row(
                children: [
                  Expanded(
                    child: NumberTextField(
                      label: 'Mínimo de salas',
                      hint: 'Ex: 3',
                      controller: _minRoomsController,
                      min: 1,
                      max: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NumberTextField(
                      label: 'Máximo de salas',
                      hint: 'Ex: 8',
                      controller: _maxRoomsController,
                      min: 1,
                      max: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dicas
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
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: AppColors.primaryLight,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Dicas:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Deixe todos vazios → Usar valor da Tabela 9-1 (aleatório)\n'
                      '• Digite apenas quantidade → Valor fixo de salas\n'
                      '• Use min/max → Intervalo de salas (ex: 3-8 salas)\n'
                      '• Mínimo e máximo → Aplicam-se ao valor da tabela\n'
                      '• Tabelas A13 → Usar encontros específicos por terreno',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          SecondaryActionButton(
            text: 'Cancelar',
            icon: Icons.cancel,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ActionButton(
            text: 'Gerar Nova Masmorra',
            icon: Icons.add_circle_outline,
            onPressed: () {
              final roomCount = _roomCountController.text.trim();
              final minRooms = _minRoomsController.text.trim();
              final maxRooms = _maxRoomsController.text.trim();

              _customRoomCount = roomCount.isEmpty
                  ? 0
                  : int.tryParse(roomCount) ?? 0;
              _minRooms = minRooms.isEmpty ? 0 : int.tryParse(minRooms) ?? 0;
              _maxRooms = maxRooms.isEmpty ? 0 : int.tryParse(maxRooms) ?? 0;

              Navigator.of(context).pop();
              _generate();
            },
          ),
        ],
      ),
    );
  }

  void _showTreasureExample() {
    final treasure = TreasureResolver.resolveByLevel(_selectedTreasureLevel);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.diamond, color: AppColors.primaryDark),
            const SizedBox(width: 8),
            Text('Exemplo de Tesouro - ${_selectedTreasureLevel.description}'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tesouro Gerado:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryDark),
                ),
                child: SelectableText(
                  treasure,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Fórmulas do ${_selectedTreasureLevel.description}:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PO: ${_selectedTreasureLevel.goldFormula}\n'
                'PP: ${_selectedTreasureLevel.silverFormula}\n'
                'Gemas: ${_selectedTreasureLevel.gemsFormula}\n'
                'Objetos: ${_selectedTreasureLevel.valuableObjectsFormula}\n'
                'Mágicos: ${_selectedTreasureLevel.magicItemsFormula}',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showTreasureExample();
            },
            child: const Text('Novo Exemplo'),
          ),
        ],
      ),
    );
  }

  Widget _buildTerrainDropdown() {
    return DropdownButtonFormField<TerrainType>(
      value: _selectedTerrain,
      decoration: const InputDecoration(
        labelText: 'Terreno',
        labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      items: TerrainType.values.map((terrain) {
        return DropdownMenuItem(
          value: terrain,
          child: Text(terrain.description, style: TextStyle(fontSize: 12)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTerrain = value!;
        });
      },
    );
  }

  Widget _buildDifficultyDropdown() {
    return DropdownButtonFormField<DifficultyLevel>(
      value: _selectedDifficulty,
      decoration: const InputDecoration(
        labelText: 'Dificuldade',
        labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      items: DifficultyLevel.values
          .where((difficulty) => !difficulty.name.startsWith('custom'))
          .map((difficulty) {
            return DropdownMenuItem(
              value: difficulty,
              child: Text(
                '${difficulty.description} (1d${difficulty.diceSides})',
                style: TextStyle(fontSize: 12),
              ),
            );
          })
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedDifficulty = value!;
        });
      },
    );
  }

  Widget _buildPartyLevelDropdown() {
    return DropdownButtonFormField<PartyLevel>(
      value: _selectedPartyLevel,
      decoration: const InputDecoration(
        labelText: 'Nível do Grupo',
        labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      items: PartyLevel.values.map((level) {
        return DropdownMenuItem(
          value: level,
          child: Text(
            '${level.description} (${level.levelRange})',
            style: TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPartyLevel = value!;

          // Auto-configuração de tesouro por nível baseada no nível do grupo
          if (_useEncounterTables) {
            _useTreasureByLevel = true;

            // Mapeia o nível do grupo para o nível de tesouro
            switch (value) {
              case PartyLevel.beginners:
                _selectedTreasureLevel = TreasureLevel.level1;
                break;
              case PartyLevel.heroic:
                _selectedTreasureLevel = TreasureLevel.level2to3;
                break;
              case PartyLevel.advanced:
                _selectedTreasureLevel = TreasureLevel.level6to7;
                break;
            }
          }
        });
      },
    );
  }

  Widget _buildTreasureLevelDropdown() {
    return DropdownButtonFormField<TreasureLevel>(
      value: _selectedTreasureLevel,
      decoration: const InputDecoration(
        labelText: 'Nível de Tesouro',
        labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      items: TreasureLevel.values.map((level) {
        return DropdownMenuItem(
          value: level,
          child: Text(level.description, style: TextStyle(fontSize: 12)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTreasureLevel = value!;
        });
      },
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
                  ? AppColors.primary
                  : room.index == _dungeon.roomsCount
                  ? AppColors.error
                  : AppColors.primary,
            ),
            const SizedBox(width: 8),
            SelectableText(
              'Sala ${room.index}${room.index == 1
                  ? ' (Entrada da Masmorra)'
                  : room.index == _dungeon.roomsCount
                  ? ' (Sala do Boss)'
                  : ' (Sala Normal)'}',
            ),
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
            child: const Text('Fechar Detalhes'),
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
          SelectableText(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
              fontSize: 12,
            ),
          ),
          SelectableText(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            SelectableText(
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

    return Container(
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 16),
        child: Column(
          children: [
            // Botões de ação
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.castle, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Gerador de Masmorras',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                    ),
                    tooltip: 'Gerar Nova Masmorra (Configurar parâmetros)',
                    onPressed: _showGenerationDialog,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: AppColors.primary),
                    tooltip: 'Regenerar Masmorra Atual (Manter configurações)',
                    onPressed: _generate,
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
        // Informações da Masmorra - 30%
        Expanded(flex: 3, child: _buildDungeonInfoCard()),
        const SizedBox(width: 16),
        // Lista de Salas - 70%
        Expanded(flex: 7, child: _buildRoomsGrid()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Informações da Masmorra
        Expanded(flex: 1, child: _buildDungeonInfoCard()),
        const SizedBox(height: 16),
        // Lista de Salas
        Expanded(flex: 2, child: _buildRoomsGrid()),
      ],
    );
  }

  Widget _buildDungeonInfoCard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Card principal da masmorra
          DungeonInfoCard(dungeon: _dungeon, showDetails: true),

          // Configurações de encontros na lateral
          const SizedBox(height: 16),
          _buildEncounterSettingsCard(),

          // Configurações de tesouros na lateral
          const SizedBox(height: 16),
          _buildTreasureSettingsCard(),
        ],
      ),
    );
  }

  Widget _buildEncounterSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.pets, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Configurações de Encontros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Switch para ativar/desativar
          Row(
            children: [
              Expanded(
                child: Text(
                  'Usar Tabelas A13 para Ocupantes:',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Switch(
                value: _useEncounterTables,
                onChanged: (value) {
                  setState(() {
                    _useEncounterTables = value;

                    // Auto-configuração de tesouro por nível quando ativar tabelas de encontro
                    if (value) {
                      _useTreasureByLevel = true;

                      // Mapeia o nível do grupo atual para o nível de tesouro
                      switch (_selectedPartyLevel) {
                        case PartyLevel.beginners:
                          _selectedTreasureLevel = TreasureLevel.level1;
                          break;
                        case PartyLevel.heroic:
                          _selectedTreasureLevel = TreasureLevel.level2to3;
                          break;
                        case PartyLevel.advanced:
                          _selectedTreasureLevel = TreasureLevel.level6to7;
                          break;
                      }
                    }
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),

          if (_useEncounterTables) ...[
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTerrainDropdown(),
                    const SizedBox(height: 12),
                    _buildDifficultyDropdown(),
                    const SizedBox(height: 12),
                    _buildPartyLevelDropdown(),
                    const SizedBox(height: 12),

                    // Botão para regenerar com novas configurações
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _regenerateOccupants,
                        icon: Icon(Icons.refresh, size: 16),
                        label: const Text('Regenerar Ocupantes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTreasureSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.diamond, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Configurações de Tesouros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Switch para ativar/desativar
          Row(
            children: [
              Expanded(
                child: Text(
                  'Usar Tabela 9.3 para Tesouros:',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Switch(
                value: _useTreasureByLevel,
                onChanged: (value) {
                  setState(() {
                    _useTreasureByLevel = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),

          if (_useTreasureByLevel) ...[
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTreasureLevelDropdown(),
                    const SizedBox(height: 12),

                    // Informações sobre o nível selecionado
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
                          Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: AppColors.primaryLight,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Fórmulas do ${_selectedTreasureLevel.description}:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryLight,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PO: ${_selectedTreasureLevel.goldFormula}\n'
                            'PP: ${_selectedTreasureLevel.silverFormula}\n'
                            'Gemas: ${_selectedTreasureLevel.gemsFormula}\n'
                            'Objetos: ${_selectedTreasureLevel.valuableObjectsFormula}\n'
                            'Mágicos: ${_selectedTreasureLevel.magicItemsFormula}',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botão para testar tesouro
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showTreasureExample,
                        icon: Icon(Icons.casino, size: 16),
                        label: const Text('Testar Tesouro'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoomsGrid() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 2),
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
              Image.asset(
                ImagePath.treasure,
                width: 24,
                height: 24,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 8),
              SelectableText(
                'Salas da Masmorra',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                ),
              ),
              const Spacer(),
              SelectableText(
                '${_dungeon.rooms.length} salas',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.primary),
          Expanded(
            child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width < 768
                      ? 1
                      : 2,
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
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryLight),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
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
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryLight),
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
            child: SelectableText(
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
    Color borderColor = AppColors.primaryLight;
    Color headerColor = AppColors.primaryLight;
    IconData roomIcon = Icons.room;

    if (isEntrance) {
      cardColor = const Color(0xFF4a3a2a);
      borderColor = AppColors.primary;
      headerColor = AppColors.primary;
      roomIcon = Icons.input;
    } else if (isBoss) {
      cardColor = const Color(0xFF3a2a2a);
      borderColor = AppColors.error;
      headerColor = AppColors.error;
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.primary),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.error),
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
                        'Item Especial',
                        room.specialItem,
                        Icons.star,
                      ),
                    if (room.monster1.isNotEmpty && room.monster1 != '—')
                      _buildRoomProperty(
                        'Monstro',
                        _buildMonsterText(room),
                        Icons.pets,
                      ),
                    if (room.trap.isNotEmpty && room.trap != '—')
                      _buildRoomProperty(
                        'Armadilha',
                        room.trap,
                        Icons.dangerous,
                      ),
                    if (room.specialTrap.isNotEmpty && room.specialTrap != '—')
                      _buildRoomProperty(
                        'Armadilha Especial',
                        room.specialTrap,
                        Icons.dangerous,
                      ),
                    if (room.roomCommon.isNotEmpty && room.roomCommon != '—')
                      _buildRoomProperty(
                        'Sala Comum',
                        room.roomCommon,
                        Icons.room,
                      ),
                    if (room.roomSpecial.isNotEmpty && room.roomSpecial != '—')
                      _buildRoomProperty(
                        'Sala Especial',
                        room.roomSpecial,
                        Icons.architecture,
                      ),
                    if (room.roomSpecial2.isNotEmpty &&
                        room.roomSpecial2 != '—')
                      _buildRoomProperty(
                        'Sala Especial 2',
                        room.roomSpecial2,
                        Icons.castle,
                      ),
                    if (room.treasure.isNotEmpty &&
                        room.treasure != 'Nenhum' &&
                        room.treasure != 'Nenhum Tesouro')
                      _buildRoomProperty(
                        'Tesouro',
                        room.treasure,
                        Icons.diamond,
                      ),
                    if (room.specialTreasure.isNotEmpty &&
                        room.specialTreasure != '—')
                      _buildRoomProperty(
                        'Tesouro Especial',
                        room.specialTreasure,
                        Icons.diamond,
                      ),
                    if (room.magicItem.isNotEmpty && room.magicItem != '—')
                      _buildRoomProperty(
                        'Item Mágico',
                        room.magicItem,
                        Icons.psychology,
                      ),
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
          Icon(icon, size: 14, color: AppColors.primaryLight),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
                SelectableText(
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
