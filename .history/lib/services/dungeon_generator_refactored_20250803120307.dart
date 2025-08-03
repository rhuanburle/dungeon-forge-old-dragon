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

/// Gerador de masmorras refatorado com estrutura mais profissional
/// Utiliza serviços especializados para cada responsabilidade
class DungeonGeneratorRefactored {
  final DungeonDataService _dungeonDataService;
  final RoomGenerationService _roomGenerationService;
  final RoomSizeCalculator _roomSizeCalculator;

  DungeonGeneratorRefactored({
    DungeonDataService? dungeonDataService,
    RoomGenerationService? roomGenerationService,
    RoomSizeCalculator? roomSizeCalculator,
  }) : _dungeonDataService = dungeonDataService ?? DungeonDataService(),
       _roomGenerationService =
           roomGenerationService ?? RoomGenerationService(),
       _roomSizeCalculator = roomSizeCalculator ?? RoomSizeCalculator();

  /// Gera uma masmorra completa
  Dungeon generate({
    required int level,
    required String theme,
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
    // Gera os dados da masmorra usando a Tabela 9.1
    final dungeonData = _dungeonDataService.generateDungeonData(
      level: level,
      terrainType: terrainType,
      difficultyLevel: difficultyLevel,
      partyLevel: partyLevel,
      useEncounterTables: useEncounterTables,
    );

    // Determina o número de salas
    final roomsCount = _roomSizeCalculator.calculateRoomCount(
      dungeonData.sizeFormula,
      customRoomCount: customRoomCount,
      minRooms: minRooms,
      maxRooms: maxRooms,
    );

    // Gera as salas
    final rooms = _generateRooms(
      roomsCount,
      level,
      dungeonData,
      treasureLevel,
      useTreasureByLevel,
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
}
