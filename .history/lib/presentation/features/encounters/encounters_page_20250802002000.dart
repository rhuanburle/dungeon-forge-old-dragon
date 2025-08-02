// presentation/features/encounters/encounters_page.dart

import 'package:flutter/material.dart';
import '../../../enums/table_enums.dart';
import '../../../models/encounter_generation.dart';
import '../../../services/encounter_generation_service.dart';
import '../../../constants/image_path.dart';
import '../../shared/widgets/action_button.dart';
import '../../../theme/app_colors.dart';

class EncountersPage extends StatefulWidget {
  const EncountersPage({super.key});

  @override
  State<EncountersPage> createState() => _EncountersPageState();
}

class _EncountersPageState extends State<EncountersPage> {
  final EncounterGenerationService _service = EncounterGenerationService();

  DifficultyLevel _selectedDifficulty = DifficultyLevel.challenging;
  PartyLevel _selectedPartyLevel = PartyLevel.beginners;
  TerrainType _selectedTerrain = TerrainType.subterranean;
  double _quantityAdjustment = 0.0;

  EncounterGeneration? _currentEncounter;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 16),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Image.asset(
                    ImagePath.swords,
                    width: 24,
                    height: 24,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Gerador de Encontros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh, color: AppColors.textSecondary),
                    tooltip: 'Gerar Novo Encontro',
                    onPressed: _isGenerating ? null : _generateEncounter,
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
        // Painel de Configuração - 40%
        Expanded(
          flex: 4,
          child: _buildConfigurationPanel(),
        ),
        const SizedBox(width: 16),
        // Painel de Resultado - 60%
        Expanded(
          flex: 6,
          child: _buildResultPanel(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Painel de Configuração
        Expanded(
          flex: 1,
          child: _buildConfigurationPanel(),
        ),
        const SizedBox(height: 16),
        // Painel de Resultado
        Expanded(
          flex: 1,
          child: _buildResultPanel(),
        ),
      ],
    );
  }

  Widget _buildConfigurationPanel() {
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
              Icon(Icons.settings, color: Colors.amber.shade400, size: 24),
              const SizedBox(width: 8),
              Text(
                'Configuração do Encontro',
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
                  _buildConfigurationSection(
                    'Dificuldade',
                    Icons.trending_up,
                    'Selecione o nível de perigo do encontro',
                    _buildDifficultyDropdown(),
                  ),
                  const SizedBox(height: 20),
                  _buildConfigurationSection(
                    'Nível do Grupo',
                    Icons.group,
                    'Selecione o nível médio dos personagens',
                    _buildPartyLevelDropdown(),
                  ),
                  const SizedBox(height: 20),
                  _buildConfigurationSection(
                    'Tipo de Terreno',
                    Icons.landscape,
                    'Selecione o ambiente do encontro',
                    _buildTerrainDropdown(),
                  ),
                  const SizedBox(height: 20),
                  _buildConfigurationSection(
                    'Ajuste de Quantidade',
                    Icons.tune,
                    'Ajuste a quantidade de inimigos (±50%)',
                    _buildQuantityAdjustment(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ActionButton(
                      text: _isGenerating ? 'Gerando...' : 'Gerar Encontro',
                      icon:
                          _isGenerating ? Icons.hourglass_empty : Icons.casino,
                      onPressed: _isGenerating ? null : _generateEncounter,
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

  Widget _buildConfigurationSection(
    String title,
    IconData icon,
    String description,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.amber.shade400, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade300,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildDifficultyDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade600),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DifficultyLevel>(
          value: _selectedDifficulty,
          dropdownColor: const Color(0xFF3a3a3a),
          style: const TextStyle(color: Colors.white),
          items: DifficultyLevel.values.map((difficulty) {
            return DropdownMenuItem(
              value: difficulty,
              child:
                  Text('${difficulty.description} (1d${difficulty.diceSides})'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDifficulty = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPartyLevelDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade600),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PartyLevel>(
          value: _selectedPartyLevel,
          dropdownColor: const Color(0xFF3a3a3a),
          style: const TextStyle(color: Colors.white),
          items: PartyLevel.values.map((level) {
            return DropdownMenuItem(
              value: level,
              child: Text('${level.description} - ${level.levelRange}'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPartyLevel = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTerrainDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade600),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TerrainType>(
          value: _selectedTerrain,
          dropdownColor: const Color(0xFF3a3a3a),
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
        ),
      ),
    );
  }

  Widget _buildQuantityAdjustment() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _quantityAdjustment,
                min: -0.5,
                max: 0.5,
                divisions: 10,
                activeColor: Colors.amber.shade400,
                inactiveColor: Colors.amber.shade800,
                onChanged: (value) {
                  setState(() {
                    _quantityAdjustment = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _quantityAdjustment == 0
                    ? Colors.amber.shade800
                    : _quantityAdjustment > 0
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade600),
              ),
              child: Text(
                '${(_quantityAdjustment * 100).round()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('-50%', style: TextStyle(color: Colors.red.shade400)),
            Text('0%', style: TextStyle(color: Colors.amber.shade400)),
            Text('+50%', style: TextStyle(color: Colors.green.shade400)),
          ],
        ),
      ],
    );
  }

  Widget _buildResultPanel() {
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
              Icon(Icons.person, color: Colors.amber.shade400, size: 24),
              const SizedBox(width: 8),
              Text(
                'Encontro Gerado',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade400,
                    ),
              ),
            ],
          ),
          const Divider(height: 24, color: Colors.amber),
          Expanded(
            child: _currentEncounter == null
                ? _buildEmptyState()
                : _buildEncounterResult(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.casino,
            size: 64,
            color: Colors.amber.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            'Configure os parâmetros e gere um encontro',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'O resultado aparecerá aqui',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncounterResult() {
    final encounter = _currentEncounter!;
    final adjustedQuantity = encounter.getAdjustedQuantity(_quantityAdjustment);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultCard(
            'Informações do Encontro',
            Icons.info,
            [
              _buildResultRow('Terreno', encounter.terrainType.description),
              _buildResultRow(
                  'Dificuldade', encounter.difficultyLevel.description),
              _buildResultRow(
                  'Nível do Grupo', encounter.partyLevel.description),
              _buildResultRow('Monstro', encounter.monsterType.description),
              _buildResultRow(
                  'Quantidade Original', encounter.quantity.toString()),
              _buildResultRow(
                  'Quantidade Ajustada', adjustedQuantity.toString()),
              _buildResultRow(
                  'Tipo', encounter.isSolitary ? 'Solitário' : 'Grupo'),
            ],
          ),
          const SizedBox(height: 16),
          _buildResultCard(
            'Descrição do Encontro',
            Icons.description,
            [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3a3a3a),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade600),
                ),
                child: Text(
                  encounter
                      .generateDescriptionWithAdjustment(_quantityAdjustment),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  text: 'Gerar Novamente',
                  icon: Icons.refresh,
                  onPressed: _generateEncounter,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  text: 'Compartilhar',
                  icon: Icons.share,
                  onPressed: () => _shareEncounter(encounter),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String title, IconData icon, List<Widget> children) {
    return Container(
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
              Icon(icon, color: Colors.amber.shade400, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade300,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.amber.shade300,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _generateEncounter() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final request = EncounterGenerationRequest(
        terrainType: _selectedTerrain,
        difficultyLevel: _selectedDifficulty,
        partyLevel: _selectedPartyLevel,
        quantityAdjustment: _quantityAdjustment,
      );

      final encounter = _service.generateEncounter(request);

      setState(() {
        _currentEncounter = encounter;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar encontro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _shareEncounter(EncounterGeneration encounter) {
    // Implementar compartilhamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de compartilhamento em desenvolvimento'),
      ),
    );
  }
}
