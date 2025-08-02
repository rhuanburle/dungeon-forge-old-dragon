// services/encounter_generation_service.dart

import '../enums/table_enums.dart';
import '../models/encounter_generation.dart';
import '../tables/table_manager.dart';
import '../utils/dice_roller.dart';

/// Serviço para geração de encontros baseado nas tabelas A13
class EncounterGenerationService {
  final TableManager _tableManager;
  final DiceRoller _diceRoller;

  EncounterGenerationService({
    TableManager? tableManager,
    DiceRoller? diceRoller,
  }) : _tableManager = tableManager ?? TableManager(),
       _diceRoller = diceRoller ?? DiceRoller();

  /// Gera um encontro baseado na requisição fornecida
  EncounterGeneration generateEncounter(EncounterGenerationRequest request) {
    // Determina o roll baseado na dificuldade
    final roll = _rollForDifficulty(request.difficultyLevel);
    
    // Obtém a tabela apropriada para o terreno
    final table = _getTableForTerrain(request.terrainType);
    
    // Obtém o resultado da tabela baseado no nível do grupo
    final result = _getResultFromTable(table, request.partyLevel, roll);
    
    // Determina se é um encontro solitário
    final isSolitary = _isSolitaryEncounter(result);
    
    // Calcula a quantidade de monstros
    final quantity = _calculateQuantity(result, isSolitary);
    
    // Determina o tipo de monstro
    final monsterType = _determineMonsterType(result, request.terrainType);
    
    return EncounterGeneration(
      terrainType: request.terrainType,
      difficultyLevel: request.difficultyLevel,
      partyLevel: request.partyLevel,
      roll: roll,
      monsterType: monsterType,
      quantity: quantity,
      isSolitary: isSolitary,
    );
  }

  /// Rola o dado apropriado para o nível de dificuldade
  int _rollForDifficulty(DifficultyLevel difficulty) {
    final diceSides = difficulty.diceSides;
    final roll = _diceRoller.rollDice(diceSides);
    
    if (roll < 1 || roll > diceSides) {
      throw ArgumentError('Roll deve estar entre 1 e $diceSides');
    }
    
    return roll;
  }

  /// Obtém a tabela apropriada para o terreno
  dynamic _getTableForTerrain(TerrainType terrain) {
    switch (terrain) {
      case TerrainType.subterranean:
        return _tableManager.subterraneanEncounterTable;
      case TerrainType.plains:
        return _tableManager.plainsEncounterTable;
      // TODO: Adicionar outras tabelas conforme implementadas
      default:
        throw ArgumentError('Terreno não suportado: $terrain');
    }
  }

  /// Obtém o resultado da tabela baseado no nível do grupo
  dynamic _getResultFromTable(dynamic table, PartyLevel partyLevel, int roll) {
    switch (partyLevel) {
      case PartyLevel.beginners:
        return table.getBeginners(roll);
      case PartyLevel.heroic:
        return table.getHeroic(roll);
      case PartyLevel.advanced:
        return table.getAdvanced(roll);
    }
  }

  /// Determina se o encontro é solitário
  bool _isSolitaryEncounter(dynamic result) {
    // Encontros solitários não têm quantidade especificada
    // Por enquanto, vamos usar uma lógica simples baseada no tipo
    if (result is MonsterType) {
      // Alguns monstros são naturalmente solitários
      return _isSolitaryMonster(result);
    }
    return false;
  }

  /// Verifica se um monstro é naturalmente solitário
  bool _isSolitaryMonster(MonsterType monsterType) {
    // Lista de monstros que são naturalmente solitários
    const solitaryMonsters = {
      MonsterType.otyugh,
      MonsterType.roper,
      MonsterType.beholder,
      MonsterType.oldBoneDragon,
      MonsterType.oldBlueDragon,
      // TODO: Adicionar mais monstros solitários
    };
    
    return solitaryMonsters.contains(monsterType);
  }

  /// Calcula a quantidade de monstros
  int _calculateQuantity(dynamic result, bool isSolitary) {
    if (isSolitary) {
      return 1;
    }

    // Se for uma referência a outra tabela, rola para determinar
    if (result is TableReference) {
      return _rollForTableReference(result);
    }

    // Se for um monstro específico, usa a quantidade padrão da tabela
    if (result is MonsterType) {
      return _getDefaultQuantityForMonster(result);
    }

    return 1; // Fallback
  }

  /// Rola para determinar quantidade baseada em referência de tabela
  int _rollForTableReference(TableReference reference) {
    switch (reference) {
      case TableReference.animalsTable:
        return _diceRoller.rollDice(6); // 1d6 para animais
      case TableReference.anyTableI:
      case TableReference.anyTableII:
      case TableReference.anyTableIII:
        return _diceRoller.rollDice(4); // 1d4 para tabelas qualquer
      case TableReference.humansTable:
        return _diceRoller.rollDice(6); // 1d6 para humanos
      case TableReference.extraplanarTableI:
      case TableReference.extraplanarTableII:
      case TableReference.extraplanarTableIII:
        return _diceRoller.rollDice(4); // 1d4 para extraplanar
    }
  }

  /// Obtém a quantidade padrão para um monstro específico
  int _getDefaultQuantityForMonster(MonsterType monsterType) {
    // Mapeamento de monstros para suas quantidades padrão
    const monsterQuantities = {
      MonsterType.giantRat: 3, // 3d6
      MonsterType.kobold: 4, // 4d4
      MonsterType.troglodyte: 1, // 1d8
      MonsterType.thoul: 1, // 1d6
      MonsterType.hellhound: 2, // 2d4
      MonsterType.insectSwarm: 1, // Enxame
      MonsterType.troll: 1, // 1d6
      MonsterType.gorgon: 1, // 1d2
      // TODO: Adicionar mais mapeamentos conforme necessário
    };
    
    return monsterQuantities[monsterType] ?? 1;
  }

  /// Determina o tipo de monstro baseado no resultado
  MonsterType _determineMonsterType(dynamic result, TerrainType terrain) {
    if (result is MonsterType) {
      return result;
    }
    
    if (result is TableReference) {
      return _getMonsterFromTableReference(result, terrain);
    }
    
    // Fallback para um monstro genérico
    return MonsterType.goblin;
  }

  /// Obtém um monstro de uma referência de tabela
  MonsterType _getMonsterFromTableReference(TableReference reference, TerrainType terrain) {
    switch (reference) {
      case TableReference.animalsTable:
        return _getRandomAnimal(terrain);
      case TableReference.humansTable:
        return _getRandomHuman();
      case TableReference.anyTableI:
      case TableReference.anyTableII:
      case TableReference.anyTableIII:
        return _getRandomAnyMonster();
      case TableReference.extraplanarTableI:
      case TableReference.extraplanarTableII:
      case TableReference.extraplanarTableIII:
        return _getRandomExtraplanar();
    }
  }

  /// Obtém um animal aleatório baseado no terreno
  MonsterType _getRandomAnimal(TerrainType terrain) {
    switch (terrain) {
      case TerrainType.subterranean:
        return MonsterType.rat;
      case TerrainType.plains:
        return MonsterType.buffalo;
      default:
        return MonsterType.rat;
    }
  }

  /// Obtém um humano aleatório
  MonsterType _getRandomHuman() {
    return MonsterType.cultists;
  }

  /// Obtém um monstro aleatório da tabela qualquer
  MonsterType _getRandomAnyMonster() {
    return MonsterType.goblin;
  }

  /// Obtém um monstro extraplanar aleatório
  MonsterType _getRandomExtraplanar() {
    return MonsterType.imp;
  }
} 