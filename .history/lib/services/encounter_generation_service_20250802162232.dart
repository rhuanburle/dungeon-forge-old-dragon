// services/encounter_generation_service.dart

import '../enums/table_enums.dart';
import '../enums/dice_enums.dart';
import '../models/encounter_generation.dart';
import '../tables/table_manager.dart';
import 'dice_roller_service.dart';

/// Serviço para geração de encontros baseado nas tabelas A13
class EncounterGenerationService {
  final TableManager _tableManager;
  final DiceRollerService _diceRoller;

  EncounterGenerationService({
    TableManager? tableManager,
    DiceRollerService? diceRoller,
  }) : _tableManager = tableManager ?? TableManager(),
       _diceRoller = diceRoller ?? DiceRollerService();

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
    final roll = _diceRoller.rollForTable(diceSides);

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
      case TerrainType.hills:
        return _tableManager.hillsEncounterTable;
      case TerrainType.mountains:
        return _tableManager.mountainsEncounterTable;
      case TerrainType.swamps:
        return _tableManager.swampsEncounterTable;
      case TerrainType.glaciers:
        return _tableManager.glaciersEncounterTable;
      case TerrainType.deserts:
        return _tableManager.desertsEncounterTable;
      case TerrainType.forests:
        // Use animals table for forests (no specific forest encounter table)
        return _tableManager.animalsTable;
      case TerrainType.any:
        return _tableManager.anyHabitatTable;
      case TerrainType.extraplanar:
        return _tableManager.extraplanarTable;
      default:
        throw ArgumentError('Terreno não suportado: $terrain');
    }
  }

  /// Obtém o resultado da tabela baseado no nível do grupo
  dynamic _getResultFromTable(dynamic table, PartyLevel partyLevel, int roll) {
    // Handle animals table which uses terrain-based methods
    if (table.runtimeType.toString().contains('AnimalsTable')) {
      // For animals table, we need to adjust roll to 1-6 range
      final adjustedRoll = ((roll - 1) % 6) + 1;
      // For animals table, we need terrain context - use subterranean as default
      return table.getSubterranean(adjustedRoll);
    }

    // Handle extraplanar table which uses 1D8 (implemented as 1D10 with adjustment)
    if (table.runtimeType.toString().contains('ExtraplanarTable')) {
      // For extraplanar table, we need to adjust roll to 1-8 range
      final adjustedRoll = ((roll - 1) % 8) + 1;
      return table.getByPartyLevel(partyLevel, adjustedRoll);
    }

    // Try to use getByPartyLevel method first (for tables like AnyHabitatTable)
    if (table.runtimeType.toString().contains('AnyHabitatTable')) {
      return table.getByPartyLevel(partyLevel, roll);
    }

    // Fallback to individual methods for tables that don't have getByPartyLevel
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
    // Lista de monstros que são naturalmente solitários baseada nas tabelas A13
    const solitaryMonsters = {
      // Subterrâneo - Tabela A13.1
      MonsterType.otyugh,
      MonsterType.roper,
      MonsterType.beholder,
      MonsterType.oldBoneDragon,
      MonsterType.ochreJelly,
      MonsterType.rustMonster,
      MonsterType.maceTail,
      MonsterType.grayOoze,
      MonsterType.carrionWorm,
      MonsterType.gelatinousCube,
      MonsterType.boneDragon,
      MonsterType.shriekerFungus,
      MonsterType.drider,
      MonsterType.brainDevourer,

      // Planícies - Tabela A13.2
      MonsterType.insectSwarm,
      MonsterType.basilisk,
      MonsterType.chimera,
      MonsterType.bulette,
      MonsterType.sphinx,
      MonsterType.cyclops,
      MonsterType.oldBlueDragon,
      MonsterType.treant,
      MonsterType.gorgon,

      // Colinas - Tabela A13.3
      MonsterType.werewolf,
      MonsterType.cockatrice,
      MonsterType.ettin,
      MonsterType.oldGoldenDragon,
      MonsterType.boneGolem,
      MonsterType.deathKnight,
      MonsterType.hillGiant,

      // Montanhas - Tabela A13.4
      MonsterType.fireGiant2,
      MonsterType.oldRedDragon,
      MonsterType.harpy,
      MonsterType.giantEagle,
      MonsterType.wyvern,

      // Pântanos - Tabela A13.5
      MonsterType.medusa,
      MonsterType.fleshGolem,
      MonsterType.witch,
      MonsterType.blackNaga,
      MonsterType.willOWisp,
      MonsterType.oldBlackDragon,
      MonsterType.giantViper,
      MonsterType.lizardGiant,
      MonsterType.hydra,

      // Geleiras - Tabela A13.6
      MonsterType.werebear,
      MonsterType.iceGiant,
      MonsterType.remorhaz,
      MonsterType.oldWhiteDragon,
      MonsterType.iceGolem,

      // Desertos - Tabela A13.7
      MonsterType.camouflagedSpiderGiant,
      MonsterType.stoneGolem,
      MonsterType.scarletWorm,
      MonsterType.scorpionGiantDesert,

      // Florestas - Tabela A13.8
      MonsterType.hunterSpiderGiant,
      MonsterType.antGiantForest,
      MonsterType.deadlyVine,
      MonsterType.oldGreenDragon,
      MonsterType.cursedTree,
      MonsterType.owlbear,
      MonsterType.blackSpiderGiant,

      // Qualquer Habitat - Tabela A13.9
      MonsterType.deathKnight2,
      MonsterType.fleshGolem2,
      MonsterType.ghost,
      MonsterType.stoneGolem2,
      MonsterType.ironGolem,
      MonsterType.lich,
      MonsterType.annihilationSphere,
      MonsterType.oldShadowDragon,

      // Extraplanar - Tabela A13.10 (todos são solitários)
      MonsterType.imp,
      MonsterType.traag,
      MonsterType.waterElementalLesser,
      MonsterType.earthElementalLesser,
      MonsterType.airElementalLesser,
      MonsterType.fireElementalLesser,
      MonsterType.doppelganger,
      MonsterType.slenderMan,
      MonsterType.flyingPolyp,
      MonsterType.waterElemental,
      MonsterType.earthElemental,
      MonsterType.airElemental,
      MonsterType.fireElemental,
      MonsterType.genie,
      MonsterType.invisibleHunter,
      MonsterType.efreeti,
      MonsterType.waterElementalGreater,
      MonsterType.earthElementalGreater,
      MonsterType.airElementalGreater,
      MonsterType.fireElementalGreater,
      MonsterType.shoggoth,
      MonsterType.cerberus,
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
      default:
        return DiceRoller.roll(1, 4); // Fallback para casos não mapeados
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
        return DiceRoller.roll(1, 6); // 1d6 (pode variar conforme a tabela)
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

      // Colinas - Tabela A13.3
      case MonsterType.drakold:
        return DiceRoller.roll(4, 4); // 4d4
      case MonsterType.hobgoblin:
        return DiceRoller.roll(1, 6); // 1d6
      case MonsterType.werewolf:
        return 1; // Solitário
      case MonsterType.cockatrice:
        return 1; // Solitário
      case MonsterType.ettin:
        return 1; // Solitário
      case MonsterType.hillGiant:
        return DiceRoller.roll(1, 4); // 1d4

      // Montanhas - Tabela A13.4
      case MonsterType.fireGiant:
        return DiceRoller.roll(1, 4); // 1d4
      case MonsterType.harpy:
        return DiceRoller.roll(1, 6); // 1d6
      case MonsterType.manticore:
        return DiceRoller.roll(1, 2); // 1d2
      case MonsterType.wyvern:
        return DiceRoller.roll(1, 2); // 1d2
      case MonsterType.iceGiant:
        return DiceRoller.roll(1, 4); // 1d4
      case MonsterType.fireGiant2:
        return 1; // Solitário

      // Pântanos - Tabela A13.5
      case MonsterType.stirge:
        return DiceRoller.roll(1, 10); // 1d10
      case MonsterType.sibilant:
        return DiceRoller.roll(4, 4); // 4d4
      case MonsterType.giantViper:
        return DiceRoller.roll(1, 2); // 1d2
      case MonsterType.medusa:
        return 1; // Solitário
      case MonsterType.fleshGolem:
        return 1; // Solitário
      case MonsterType.witch:
        return 1; // Solitário
      case MonsterType.blackNaga:
        return 1; // Solitário
      case MonsterType.willOWisp:
        return 1; // Solitário

      // Geleiras - Tabela A13.6
      case MonsterType.werebear:
        return 1; // Solitário
      case MonsterType.iceGiant:
        return 1; // Solitário
      case MonsterType.remorhaz:
        return 1; // Solitário

      // Desertos - Tabela A13.7
      case MonsterType.camouflagedSpiderGiant:
        return 1; // Solitário
      case MonsterType.scarletWorm:
        return DiceRoller.roll(1, 3); // 1d3
      case MonsterType.stoneGolem:
        return 1; // Solitário

      // Florestas - Tabela A13.8
      case MonsterType.hunterSpiderGiant:
        return 1; // Solitário
      case MonsterType.blackSpiderGiantForest:
        return DiceRoller.roll(3, 6); // 3d6
      case MonsterType.antGiantForest:
        return 1; // Solitário
      case MonsterType.owlbear:
        return DiceRoller.roll(1, 4); // 1d4
      case MonsterType.cursedTree:
        return DiceRoller.roll(1, 3); // 1d3
      case MonsterType.deadlyVine:
        return 1; // Solitário
      case MonsterType.werebearForest:
        return DiceRoller.roll(1, 3); // 1d3
      case MonsterType.worg:
        return DiceRoller.roll(1, 3); // 1d3

      // Monstros solitários (sem quantidade especificada)
      case MonsterType.otyugh:
      case MonsterType.roper:
      case MonsterType.beholder:
      case MonsterType.oldBoneDragon:
      case MonsterType.oldBlueDragon:
      case MonsterType.youngBlueDragon:
      case MonsterType.blueDragon:
      case MonsterType.youngGoldenDragon:
      case MonsterType.oldGoldenDragon:
      case MonsterType.goldenDragon:
      case MonsterType.youngRedDragon:
      case MonsterType.oldRedDragon:
      case MonsterType.redDragon:
      case MonsterType.youngBlackDragon:
      case MonsterType.oldBlackDragon:
      case MonsterType.blackDragon:
      case MonsterType.youngWhiteDragon:
      case MonsterType.oldWhiteDragon:
      case MonsterType.whiteDragon:
      case MonsterType.youngGreenDragon:
      case MonsterType.oldGreenDragon:
      case MonsterType.greenDragon:
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
    TableReference reference,
    TerrainType terrain,
  ) {
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
      case TerrainType.hills:
        return MonsterType.boar;
      case TerrainType.mountains:
        return MonsterType.eagle;
      case TerrainType.swamps:
        return MonsterType.crocodile;
      case TerrainType.glaciers:
        return MonsterType.bearPolar;
      case TerrainType.deserts:
        return MonsterType.camel;
      case TerrainType.forests:
        return MonsterType.wolf;
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
