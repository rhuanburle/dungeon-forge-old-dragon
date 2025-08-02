import 'lib/services/dungeon_data_service.dart';
import 'lib/enums/table_enums.dart';

void main() {
  print('=== TESTE DE INTEGRAÇÃO MASMORRA + ENCONTROS ===');
  
  final service = DungeonDataService();
  
  // Teste 1: Geração padrão (sem tabelas de encontro)
  print('\n--- Teste 1: Geração Padrão ---');
  final dungeonData1 = service.generateDungeonData();
  print('Ocupante I: ${dungeonData1.occupantI}');
  print('Ocupante II: ${dungeonData1.occupantII}');
  print('Líder: ${dungeonData1.leader}');
  
  // Teste 2: Geração com tabelas de encontro
  print('\n--- Teste 2: Geração com Tabelas A13 ---');
  final dungeonData2 = service.generateDungeonData(
    level: 3,
    terrainType: TerrainType.subterranean,
    difficultyLevel: DifficultyLevel.medium,
    partyLevel: PartyLevel.beginners,
    useEncounterTables: true,
  );
  print('Ocupante I: ${dungeonData2.occupantI}');
  print('Ocupante II: ${dungeonData2.occupantII}');
  print('Líder: ${dungeonData2.leader}');
  
  // Teste 3: Geração com diferentes terrenos
  print('\n--- Teste 3: Diferentes Terrenos ---');
  final terrains = [
    TerrainType.subterranean,
    TerrainType.plains,
    TerrainType.forests,
    TerrainType.mountains,
  ];
  
  for (final terrain in terrains) {
    final data = service.generateDungeonData(
      level: 5,
      terrainType: terrain,
      difficultyLevel: DifficultyLevel.challenging,
      partyLevel: PartyLevel.advanced,
      useEncounterTables: true,
    );
    print('${terrain.description}: ${data.occupantI}');
  }
  
  print('\n=== FIM DO TESTE ===');
} 