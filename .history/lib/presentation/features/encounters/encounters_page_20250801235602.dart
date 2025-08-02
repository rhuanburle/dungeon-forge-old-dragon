// presentation/features/encounters/encounters_page.dart

import 'package:flutter/material.dart';
import '../../../enums/table_enums.dart';
import '../../../models/encounter_generation.dart';
import '../../../services/encounter_generation_service.dart';


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
    return Container(
      color: const Color(0xFF0d0d0d),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade700, width: 2),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.amber,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Gerar Encontros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildConfigurationCard(),
            const SizedBox(height: 24),
            _buildQuantityAdjustmentCard(),
            const SizedBox(height: 24),
            _buildGenerateButton(),
            const SizedBox(height: 24),
            if (_currentEncounter != null) _buildEncounterResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuração do Encontro',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Dificuldade
            _buildDropdownField(
              label: 'Dificuldade',
              value: _selectedDifficulty,
              items: DifficultyLevel.values,
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
              itemBuilder: (item) => '${item.description} (1d${item.diceSides})',
            ),
            
            const SizedBox(height: 16),
            
            // Nível do Grupo
            _buildDropdownField(
              label: 'Nível do Grupo',
              value: _selectedPartyLevel,
              items: PartyLevel.values,
              onChanged: (value) {
                setState(() {
                  _selectedPartyLevel = value!;
                });
              },
              itemBuilder: (item) => '${item.description} - ${item.levelRange}',
            ),
            
            const SizedBox(height: 16),
            
            // Tipo de Terreno
            _buildDropdownField(
              label: 'Tipo de Terreno',
              value: _selectedTerrain,
              items: TerrainType.values,
              onChanged: (value) {
                setState(() {
                  _selectedTerrain = value!;
                });
              },
              itemBuilder: (item) => item.description,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityAdjustmentCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajuste de Quantidade',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajuste a quantidade de inimigos (±50%)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _quantityAdjustment,
                    min: -0.5,
                    max: 0.5,
                    divisions: 10,
                    activeColor: Theme.of(context).colorScheme.primary,
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
                        ? Colors.grey[200] 
                        : _quantityAdjustment > 0 
                            ? Colors.green[100] 
                            : Colors.red[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${(_quantityAdjustment * 100).round()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _quantityAdjustment == 0 
                          ? Colors.grey[600] 
                          : _quantityAdjustment > 0 
                              ? Colors.green[700] 
                              : Colors.red[700],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('-50%', style: TextStyle(color: Colors.red[600])),
                Text('0%', style: TextStyle(color: Colors.grey[600])),
                Text('+50%', style: TextStyle(color: Colors.green[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton(
      onPressed: _isGenerating ? null : _generateEncounter,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isGenerating
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Gerando...'),
              ],
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.casino),
                SizedBox(width: 8),
                Text(
                  'Gerar Encontro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }

  Widget _buildEncounterResultCard() {
    if (_currentEncounter == null) return const SizedBox.shrink();
    
    final encounter = _currentEncounter!;
    final adjustedQuantity = encounter.getAdjustedQuantity(_quantityAdjustment);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Encontro Gerado',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildResultRow('Terreno', encounter.terrainType.description),
            _buildResultRow('Dificuldade', encounter.difficultyLevel.description),
            _buildResultRow('Nível do Grupo', encounter.partyLevel.description),
            _buildResultRow('Monstro', encounter.monsterType.description),
            _buildResultRow('Quantidade Original', encounter.quantity.toString()),
            _buildResultRow('Quantidade Ajustada', adjustedQuantity.toString()),
            _buildResultRow('Tipo', encounter.isSolitary ? 'Solitário' : 'Grupo'),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                encounter.generateDescriptionWithAdjustment(_quantityAdjustment),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _generateEncounter,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Gerar Novamente'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareEncounter(encounter),
                    icon: const Icon(Icons.share),
                    label: const Text('Compartilhar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(itemBuilder(item)),
          )).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
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
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
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