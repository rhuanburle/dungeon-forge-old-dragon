// models/encounter_generation.dart

import '../enums/table_enums.dart';

/// Modelo para representar uma geração de encontro
class EncounterGeneration {
  final TerrainType terrainType;
  final DifficultyLevel difficultyLevel;
  final PartyLevel partyLevel;
  final int roll;
  final MonsterType monsterType;
  final int quantity;
  final bool isSolitary;

  const EncounterGeneration({
    required this.terrainType,
    required this.difficultyLevel,
    required this.partyLevel,
    required this.roll,
    required this.monsterType,
    required this.quantity,
    required this.isSolitary,
  });

  /// Calcula a quantidade ajustada baseada no ajuste fornecido
  /// 
  /// [adjustment] - Ajuste em porcentagem (ex: 0.5 para 50% de aumento)
  /// Retorna a quantidade original se for um encontro solitário
  int getAdjustedQuantity(double adjustment) {
    if (isSolitary) {
      return quantity; // Encontros solitários não são ajustados
    }

    final adjusted = quantity + (quantity * adjustment);
    return adjusted.round();
  }

  /// Gera uma descrição do encontro
  String generateDescription() {
    final monsterName = monsterType.description;
    final terrainName = terrainType.description;
    final partyLevelName = partyLevel.description;
    final difficultyName = difficultyLevel.description;

    if (isSolitary) {
      return '''
🎲 **Encontro Gerado**
📍 **Terreno:** $terrainName
⚔️ **Monstro:** $monsterName (Solitário)
👥 **Nível do Grupo:** $partyLevelName
🎯 **Dificuldade:** $difficultyName
📊 **Roll:** $roll
''';
    }

    return '''
🎲 **Encontro Gerado**
📍 **Terreno:** $terrainName
⚔️ **Monstro:** $monsterName ($quantity)
👥 **Nível do Grupo:** $partyLevelName
🎯 **Dificuldade:** $difficultyName
📊 **Roll:** $roll
''';
  }

  /// Gera uma descrição com quantidade ajustada
  String generateDescriptionWithAdjustment(double adjustment) {
    final adjustedQuantity = getAdjustedQuantity(adjustment);
    final monsterName = monsterType.description;
    final terrainName = terrainType.description;
    final partyLevelName = partyLevel.description;
    final difficultyName = difficultyLevel.description;

    if (isSolitary) {
      return '''
🎲 **Encontro Gerado**
📍 **Terreno:** $terrainName
⚔️ **Monstro:** $monsterName (Solitário)
👥 **Nível do Grupo:** $partyLevelName
🎯 **Dificuldade:** $difficultyName
📊 **Roll:** $roll
''';
    }

    final adjustmentText = adjustment > 0 
        ? '+${(adjustment * 100).round()}%' 
        : '${(adjustment * 100).round()}%';

    return '''
🎲 **Encontro Gerado**
📍 **Terreno:** $terrainName
⚔️ **Monstro:** $monsterName ($adjustedQuantity) $adjustmentText
👥 **Nível do Grupo:** $partyLevelName
🎯 **Dificuldade:** $difficultyName
📊 **Roll:** $roll
''';
  }
}

/// Modelo para representar uma requisição de geração de encontro
class EncounterGenerationRequest {
  final TerrainType terrainType;
  final DifficultyLevel difficultyLevel;
  final PartyLevel partyLevel;
  final double quantityAdjustment; // -1.0 a 1.0 (-100% a +100%)

  const EncounterGenerationRequest({
    required this.terrainType,
    required this.difficultyLevel,
    required this.partyLevel,
    this.quantityAdjustment = 0.0,
  }) : assert(
         quantityAdjustment >= -1.0 && quantityAdjustment <= 1.0,
         'Ajuste de quantidade deve estar entre -100% e +100%',
       );

  /// Cria uma cópia com novos valores
  EncounterGenerationRequest copyWith({
    TerrainType? terrainType,
    DifficultyLevel? difficultyLevel,
    PartyLevel? partyLevel,
    double? quantityAdjustment,
  }) {
    return EncounterGenerationRequest(
      terrainType: terrainType ?? this.terrainType,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      partyLevel: partyLevel ?? this.partyLevel,
      quantityAdjustment: quantityAdjustment ?? this.quantityAdjustment,
    );
  }

  /// Converte para string para debug
  @override
  String toString() {
    return 'EncounterGenerationRequest('
        'terrainType: $terrainType, '
        'difficultyLevel: $difficultyLevel, '
        'partyLevel: $partyLevel, '
        'quantityAdjustment: $quantityAdjustment)';
  }
} 