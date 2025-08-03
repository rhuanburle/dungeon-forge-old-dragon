// services/dungeon_generator_refactored.dart

import '../models/dungeon.dart';
import '../models/room.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../mappers/dungeon_mapper.dart';
import '../enums/table_enums.dart';
import 'dungeon_data_service.dart';
import 'room_generation_service.dart';
import 'room_size_calculator.dart';
import '../utils/treasure_resolver.dart';
import '../utils/dice_roller.dart';

/// Gerador de masmorras refatorado com estrutura mais profissional
/// Utiliza serviços especializados para cada responsabilidade
class DungeonGeneratorRefactored {
  static final DungeonDataService _dungeonDataService = DungeonDataService();
  final RoomGenerationService _roomGenerationService;
  final RoomSizeCalculator _roomSizeCalculator;

  DungeonGeneratorRefactored({
    RoomGenerationService? roomGenerationService,
    RoomSizeCalculator? roomSizeCalculator,
  }) : _roomGenerationService =
           roomGenerationService ?? RoomGenerationService(),
       _roomSizeCalculator = roomSizeCalculator ?? RoomSizeCalculator();

  /// Gera uma masmorra completa
  Dungeon generate({
    int level = 1,
    String theme = 'Masmorra Padrão',
    int? customRoomCount,
    int? minRooms,
    int? maxRooms,
    TerrainType? terrainType,
    DifficultyLevel? difficultyLevel,
    PartyLevel? partyLevel,
    bool useEncounterTables = false,
    TreasureLevel? treasureLevel,
    bool useTreasureByLevel = false,
  }) {
    // Sincronização automática entre PartyLevel e TreasureLevel
    TreasureLevel? autoTreasureLevel;
    bool autoUseTreasureByLevel = false;

    if (useEncounterTables && partyLevel != null) {
      // Mapeia PartyLevel para TreasureLevel automaticamente
      switch (partyLevel) {
        case PartyLevel.beginners:
          autoTreasureLevel = TreasureLevel.level1;
          autoUseTreasureByLevel = true;
          break;
        case PartyLevel.heroic:
          autoTreasureLevel = TreasureLevel.level2to3;
          autoUseTreasureByLevel = true;
          break;
        case PartyLevel.advanced:
          autoTreasureLevel = TreasureLevel.level6to7;
          autoUseTreasureByLevel = true;
          break;
      }
    }

    // Usa os valores automáticos se não foram fornecidos manualmente
    final finalTreasureLevel = treasureLevel ?? autoTreasureLevel;
    final finalUseTreasureByLevel =
        useTreasureByLevel || autoUseTreasureByLevel;

    // Gera dados da masmorra
    final dungeonData = _dungeonDataService.generateDungeonData(
      level: level,
      terrainType: terrainType,
      difficultyLevel: difficultyLevel,
      partyLevel: partyLevel,
      useEncounterTables: useEncounterTables,
    );

    // Calcula número de salas
    final roomsCount = _roomSizeCalculator.calculateRoomCount(
      dungeonData.sizeFormula,
      customRoomCount: customRoomCount,
      minRooms: minRooms,
      maxRooms: maxRooms,
    );

    // Gera salas
    final rooms = _generateRooms(
      roomsCount,
      level,
      dungeonData,
      finalTreasureLevel,
      finalUseTreasureByLevel,
    );

    // Converte para o modelo final
    return DungeonMapper.fromDto(dungeonData, rooms);
  }

  /// Gera as salas da masmorra
  List<Room> _generateRooms(
    int roomsCount,
    int level,
    DungeonGenerationDto dungeonData,
    TreasureLevel? treasureLevel,
    bool useTreasureByLevel,
  ) {
    final rooms = <Room>[];

    for (int i = 0; i < roomsCount; i++) {
      final roomDto = _roomGenerationService.generateRoom(dungeonData, i);
      final room = DungeonMapper.fromRoomDto(
        roomDto,
        i + 1,
        dungeonData,
        treasureLevel: treasureLevel,
        useTreasureByLevel: useTreasureByLevel,
      );
      rooms.add(room);
    }

    return rooms;
  }

  /// Regenera apenas os ocupantes da masmorra usando tabelas A13
  void regenerateOccupants({
    required TerrainType terrainType,
    required DifficultyLevel difficultyLevel,
    required PartyLevel partyLevel,
  }) {
    _dungeonDataService.regenerateOccupants(
      terrainType: terrainType,
      difficultyLevel: difficultyLevel,
      partyLevel: partyLevel,
    );
  }

  /// Atualiza apenas os ocupantes das salas existentes
  void updateRoomOccupants(Dungeon dungeon) {
    final dungeonData = _dungeonDataService.currentDungeonData;
    if (dungeonData == null) return;

    for (int i = 0; i < dungeon.rooms.length; i++) {
      final room = dungeon.rooms[i];

      // Apenas atualiza os ocupantes se a sala original tinha monstros
      if (room.monster1.isNotEmpty || room.monster2.isNotEmpty) {
        // Gera novos ocupantes usando as tabelas A13
        final col10Roll = DiceRoller.rollStatic(2, 6);
        final col11Roll = DiceRoller.rollStatic(2, 6);
        final col12Roll = DiceRoller.rollStatic(2, 6);

        // Obtém novos ocupantes
        final occupantI = _dungeonDataService._getOccupant(
          col10Roll,
          dungeonData.terrainType,
          dungeonData.difficultyLevel,
          dungeonData.partyLevel,
          true, // useEncounterTables = true
        );
        final occupantII = _dungeonDataService._getOccupant(
          col11Roll,
          dungeonData.terrainType,
          dungeonData.difficultyLevel,
          dungeonData.partyLevel,
          true, // useEncounterTables = true
        );
        final leader = _dungeonDataService._getOccupant(
          col12Roll,
          dungeonData.terrainType,
          dungeonData.difficultyLevel,
          dungeonData.partyLevel,
          true, // useEncounterTables = true
        );

        // Atualiza apenas os campos de monstros na sala existente
        dungeon.rooms[i] = room.copyWith(
          monster1: occupantI,
          monster2: occupantII,
        );
      }
    }
  }
}
