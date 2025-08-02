// presentation/features/encounters/encounters_page.dart

import 'package:flutter/material.dart';
import '../../../enums/table_enums.dart';
import '../../../models/encounter_generation.dart';
import '../../../services/encounter_generation_service.dart';
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
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield, color: AppColors.primaryLight, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Gerador de Encontros',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isMobile ? 15 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh, color: AppColors.primaryLight),
                    tooltip: 'Gerar Novo Encontro',
                    onPressed: _isGenerating ? null : _generateEncounter,
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 10 : 16),
            // Conteúdo principal
            Expanded(
              child: isMobile
                  ? _buildMobileLayout(isMobile)
                  : _buildDesktopLayout(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Painel de Configuração - 40%
        Expanded(
          flex: 4,
          child: _buildConfigurationPanel(isMobile),
        ),
        const SizedBox(width: 16),
        // Painel de Resultado - 60%
        Expanded(
          flex: 6,
          child: _buildResultPanel(isMobile),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return Column(
      children: [
        // Painel de Configuração
        Expanded(
          flex: 1,
          child: _buildConfigurationPanel(isMobile),
        ),
        const SizedBox(height: 16),
        // Painel de Resultado
        Expanded(
          flex: 1,
          child: _buildResultPanel(isMobile),
        ),
      ],
    );
  }

  Widget _buildConfigurationPanel(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
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
              Icon(Icons.settings, color: AppColors.primaryLight, size: 24),
              SizedBox(width: isMobile ? 6 : 8),
              Text(
                'Configuração do Encontro',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
                      fontSize: isMobile ? 15 : null,
                    ),
              ),
            ],
          ),
          Divider(height: isMobile ? 16 : 24, color: AppColors.primary),
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
                    isMobile,
                  ),
                  const SizedBox(height: 20),
                  _buildConfigurationSection(
                    'Nível do Grupo',
                    Icons.group,
                    'Selecione o nível médio dos personagens',
                    _buildPartyLevelDropdown(),
                    isMobile,
                  ),
                  const SizedBox(height: 20),
                  _buildConfigurationSection(
                    'Tipo de Terreno',
                    Icons.landscape,
                    'Selecione o ambiente do encontro',
                    _buildTerrainDropdown(),
                    isMobile,
                  ),
                  const SizedBox(height: 20),
                  _buildConfigurationSection(
                    'Ajuste de Quantidade',
                    Icons.tune,
                    'Ajuste a quantidade de inimigos (±50%)',
                    _buildQuantityAdjustment(isMobile),
                    isMobile,
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
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryLight, size: 20),
            SizedBox(width: isMobile ? 6 : 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryLight,
                fontSize: isMobile ? 13 : 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isMobile ? 11 : 12,
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
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DifficultyLevel>(
          value: _selectedDifficulty,
          dropdownColor: AppColors.surfaceLight,
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
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PartyLevel>(
          value: _selectedPartyLevel,
          dropdownColor: AppColors.surfaceLight,
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
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TerrainType>(
          value: _selectedTerrain,
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
        ),
      ),
    );
  }

  Widget _buildQuantityAdjustment(bool isMobile) {
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
                activeColor: AppColors.primaryLight,
                inactiveColor: AppColors.primaryDark,
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
                    ? AppColors.primaryDark
                    : _quantityAdjustment > 0
                        ? AppColors.success
                        : AppColors.warning,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
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
            Text('-50%', style: TextStyle(color: AppColors.warning)),
            Text('0%', style: TextStyle(color: AppColors.primaryLight)),
            Text('+50%', style: TextStyle(color: AppColors.success)),
          ],
        ),
      ],
    );
  }

  Widget _buildResultPanel(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
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
              Icon(Icons.person, color: AppColors.primaryLight, size: 24),
              SizedBox(width: isMobile ? 6 : 8),
              Text(
                'Encontro Gerado',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
                      fontSize: isMobile ? 15 : null,
                    ),
              ),
            ],
          ),
          Divider(height: isMobile ? 16 : 24, color: AppColors.primary),
          Expanded(
            child: _currentEncounter == null
                ? _buildEmptyState(isMobile)
                : _buildEncounterResult(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.casino,
            size: 64,
            color: AppColors.primaryLight,
          ),
          const SizedBox(height: 16),
                      Text(
              'Configure os parâmetros e gere um encontro',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'O resultado aparecerá aqui',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEncounterResult(bool isMobile) {
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
              _buildResultRow(
                  'Terreno', encounter.terrainType.description, isMobile),
              _buildResultRow('Dificuldade',
                  encounter.difficultyLevel.description, isMobile),
              _buildResultRow(
                  'Nível do Grupo', encounter.partyLevel.description, isMobile),
              _buildResultRow(
                  'Monstro', encounter.monsterType.description, isMobile),
              _buildResultRow('Quantidade Original',
                  encounter.quantity.toString(), isMobile),
              _buildResultRow(
                  'Quantidade Ajustada', adjustedQuantity.toString(), isMobile),
              _buildResultRow('Tipo',
                  encounter.isSolitary ? 'Solitário' : 'Grupo', isMobile),
            ],
            isMobile,
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
                  border: Border.all(color: AppColors.border),
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
            isMobile,
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

  Widget _buildResultCard(
      String title, IconData icon, List<Widget> children, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 20),
              SizedBox(width: isMobile ? 6 : 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  fontSize: isMobile ? 13 : 16,
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

  Widget _buildResultRow(String label, String value, bool isMobile) {
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
                color: AppColors.textSecondary,
                fontSize: isMobile ? 12 : 14,
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
