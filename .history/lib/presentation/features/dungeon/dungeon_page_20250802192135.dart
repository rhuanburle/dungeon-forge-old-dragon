// presentation/features/dungeon/dungeon_page.dart

import 'package:flutter/material.dart';
import '../../../enums/table_enums.dart';
import '../../../services/dungeon_generator_refactored.dart';
import '../../../models/dungeon.dart';
import '../../../models/room.dart';
import '../../../theme/app_colors.dart';
import '../../shared/widgets/responsive_layout.dart';

class DungeonPage extends StatefulWidget {
  const DungeonPage({super.key});

  @override
  State<DungeonPage> createState() => _DungeonPageState();
}

class _DungeonPageState extends State<DungeonPage> {
  final _formKey = GlobalKey<FormState>();
  final _levelController = TextEditingController(text: '1');
  final _themeController = TextEditingController(text: 'Fantasia');
  
  // Configurações de encontros
  TerrainType _selectedTerrain = TerrainType.subterranean;
  DifficultyLevel _selectedDifficulty = DifficultyLevel.medium;
  PartyLevel _selectedPartyLevel = PartyLevel.beginners;
  bool _useEncounterTables = false;
  
  Dungeon? _generatedDungeon;
  bool _isGenerating = false;

  @override
  void dispose() {
    _levelController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  Future<void> _generateDungeon() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final level = int.parse(_levelController.text);
      final theme = _themeController.text;

      final generator = DungeonGeneratorRefactored();
      final dungeon = generator.generate(
        level: level,
        theme: theme,
        terrainType: _useEncounterTables ? _selectedTerrain : null,
        difficultyLevel: _useEncounterTables ? _selectedDifficulty : null,
        partyLevel: _useEncounterTables ? _selectedPartyLevel : null,
        useEncounterTables: _useEncounterTables,
      );

      setState(() {
        _generatedDungeon = dungeon;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar masmorra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Gerador de Masmorras'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildConfigurationForm(),
              const SizedBox(height: 24),
              _buildEncounterOptions(),
              const SizedBox(height: 24),
              _buildGenerateButton(),
              if (_generatedDungeon != null) ...[
                const SizedBox(height: 24),
                _buildDungeonInfo(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigurationForm() {
    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configuração Básica',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _levelController,
                decoration: const InputDecoration(
                  labelText: 'Nível da Masmorra',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o nível da masmorra';
                  }
                  final level = int.tryParse(value);
                  if (level == null || level < 1) {
                    return 'Nível deve ser um número maior que 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _themeController,
                decoration: const InputDecoration(
                  labelText: 'Tema da Masmorra',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o tema da masmorra';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEncounterOptions() {
    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Configurações de Encontros (Opcional)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                                 Switch(
                   value: _useEncounterTables,
                   onChanged: (value) {
                     setState(() {
                       _useEncounterTables = value;
                     });
                   },
                   activeColor: AppColors.primary,
                 ),
              ],
            ),
            if (_useEncounterTables) ...[
              const SizedBox(height: 16),
              _buildTerrainDropdown(),
              const SizedBox(height: 16),
              _buildDifficultyDropdown(),
              const SizedBox(height: 16),
              _buildPartyLevelDropdown(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTerrainDropdown() {
    return DropdownButtonFormField<TerrainType>(
      value: _selectedTerrain,
      decoration: const InputDecoration(
        labelText: 'Tipo de Terreno',
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
      ),
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: Colors.white),
      items: TerrainType.values.map((terrain) {
        return DropdownMenuItem(
          value: terrain,
          child: Text(terrain.description),
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
        labelText: 'Nível de Dificuldade',
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
      ),
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: Colors.white),
      items: DifficultyLevel.values
          .where((difficulty) => !difficulty.name.startsWith('custom'))
          .map((difficulty) {
        return DropdownMenuItem(
          value: difficulty,
          child: Text(
            '${difficulty.description} (1d${difficulty.diceSides})',
          ),
        );
      }).toList(),
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
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
      ),
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: Colors.white),
      items: PartyLevel.values.map((level) {
        return DropdownMenuItem(
          value: level,
          child: Text('${level.description} (${level.levelRange})'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPartyLevel = value!;
        });
      },
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton(
      onPressed: _isGenerating ? null : _generateDungeon,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isGenerating
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Gerar Masmorra',
              style: TextStyle(fontSize: 18),
            ),
    );
  }

  Widget _buildDungeonInfo() {
    final dungeon = _generatedDungeon!;
    
    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masmorra Gerada',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Tipo', dungeon.type.description),
            _buildInfoRow('Construtor', dungeon.builderOrInhabitant.description),
            _buildInfoRow('Status', dungeon.status.description),
            _buildInfoRow('Objetivo', dungeon.fullObjective),
            _buildInfoRow('Localização', dungeon.location.description),
            _buildInfoRow('Entrada', dungeon.entry.description),
            _buildInfoRow('Tamanho', '${dungeon.rooms.length} salas'),
            _buildInfoRow('Ocupante I', dungeon.occupantI),
            _buildInfoRow('Ocupante II', dungeon.occupantII),
            _buildInfoRow('Líder', dungeon.leader),
            _buildInfoRow('Rumor', dungeon.fullRumor),
            const SizedBox(height: 16),
            const Text(
              'Salas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ...dungeon.rooms.take(5).map((room) => _buildRoomInfo(room)),
            if (dungeon.rooms.length > 5)
              Text(
                '... e mais ${dungeon.rooms.length - 5} salas',
                style: const TextStyle(color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomInfo(Room room) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        'Sala ${room.number}: ${room.typeDescription}',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
