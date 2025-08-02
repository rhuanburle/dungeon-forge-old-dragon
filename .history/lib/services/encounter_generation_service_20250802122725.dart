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
  })  : _tableManager = tableManager ?? TableManager(),
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
    final roll = DiceRoller.roll(1, diceSides);

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
        return DiceRoller.roll(1, 6); // 1d6 para animais
      case TableReference.anyTableI:
      case TableReference.anyTableII:
      case TableReference.anyTableIII:
        return DiceRoller.roll(1, 4); // 1d4 para tabelas qualquer
      case TableReference.humansTable:
        return DiceRoller.roll(1, 6); // 1d6 para humanos
      case TableReference.extraplanarTableI:
      case TableReference.extraplanarTableII:
      case TableReference.extraplanarTableIII:
        return DiceRoller.roll(1, 4); // 1d4 para extraplanar
    }
  }

  /// Obtém a quantidade padrão para um monstro específico
  int _getDefaultQuantityForMonster(MonsterType monsterType) {
    // Mapeamento de monstros para suas quantidades baseado nas tabelas A13
    switch (monsterType) {
      // Subterrâneo - Tabela A13.1
      case MonsterType.giantRat:
        return DiceRoller.roll(3, 6); // 3d6
      case MonsterType.kobold:
        return DiceRoller.roll(4, 4); // 4d4
      case MonsterType.troglodyte:
        return DiceRoller.roll(1, 8); // 1d8
      case MonsterType.thoul:
        return DiceRoller.roll(1, 6); // 1d6
      case MonsterType.pygmyFungus:
        return DiceRoller.roll(2, 6); // 2d6
      case MonsterType.violetFungus:
        return DiceRoller.roll(1, 4); // 1d4
      case MonsterType.drowElf:
        return DiceRoller.roll(2, 4); // 2d4
      case MonsterType.bugbear:
        return DiceRoller.roll(2, 4); // 2d4
      case MonsterType.derro:
        return DiceRoller.roll(2, 4); // 2d4
      case MonsterType.shriekerFungus:
        return DiceRoller.roll(2, 4); // 2d4
      case MonsterType.drider:
        return DiceRoller.roll(1, 3); // 1d3
      case MonsterType.brainDevourer:
        return DiceRoller.roll(1, 4); // 1d4

      // Planícies - Tabela A13.2
      case MonsterType.gnoll:
        return DiceRoller.roll(1, 6); // 1d6
      case MonsterType.goblin:
        return DiceRoller.roll(1, 6); // 1d6
      case MonsterType.lizardMan:
        return DiceRoller.roll(2, 4); // 2d4
      case MonsterType.orc:
        return DiceRoller.roll(2, 4); // 2d4
      case MonsterType.hellhound:
        return DiceRoller.roll(2, 4); // 2d4
      case MonsterType.ogre:
        return DiceRoller.roll(1, 6); // 1d6
      case MonsterType.insectSwarm:
        return 1; // Enxame (solitário)
      case MonsterType.oniMage:
        return DiceRoller.roll(1, 4); // 1d4
      case MonsterType.troll:
        return DiceRoller.roll(1, 6); // 1d6
      case MonsterType.basilisk:
        return 1; // Solitário
      case MonsterType.gorgon:
        return DiceRoller.roll(1, 2); // 1d2
      case MonsterType.treant:
        return DiceRoller.roll(1, 4); // 1d4
      case MonsterType.chimera:
        return 1; // Solitário
      case MonsterType.bulette:
        return 1; // Solitário
      case MonsterType.sphinx:
        return 1; // Solitário
      case MonsterType.cyclops:
        return 1; // Solitário

      // Monstros solitários (sem quantidade especificada)
      case MonsterType.otyugh:
      case MonsterType.roper:
      case MonsterType.beholder:
      case MonsterType.oldBoneDragon:
      case MonsterType.oldBlueDragon:
      case MonsterType.youngBlueDragon:
      case MonsterType.blueDragon:
        return 1; // Solitário

      // Fallback para outros monstros
      default:
        return DiceRoller.roll(1, 4); // 1d4 como fallback
    }
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
  MonsterType _getMonsterFromTableReference(
      TableReference reference, TerrainType terrain) {
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
