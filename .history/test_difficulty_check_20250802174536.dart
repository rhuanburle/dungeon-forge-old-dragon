import 'lib/services/encounter_generation_service.dart';
import 'lib/enums/table_enums.dart';
import 'lib/models/encounter_generation.dart';

void main() {
  final service = EncounterGenerationService();
  
  print('=== TESTE DE DIFICULDADES ===');
  
  // Teste com Fácil (1d6)
  final easyRequest = EncounterGenerationRequest(
    terrainType: TerrainType.subterranean,
    difficultyLevel: DifficultyLevel.easy,
    partyLevel: PartyLevel.beginners,
  );
  
  final easyEncounter = service.generateEncounter(easyRequest);
  print('Fácil (1d6): Roll = ${easyEncounter.roll} (deve estar entre 1-6)');
  
  // Teste com Médio (1d10)
  final mediumRequest = EncounterGenerationRequest(
    terrainType: TerrainType.subterranean,
    difficultyLevel: DifficultyLevel.medium,
    partyLevel: PartyLevel.beginners,
  );
  
  final mediumEncounter = service.generateEncounter(mediumRequest);
  print('Médio (1d10): Roll = ${mediumEncounter.roll} (deve estar entre 1-10)');
  
  // Teste com Desafiador (1d12)
  final challengingRequest = EncounterGenerationRequest(
    terrainType: TerrainType.subterranean,
    difficultyLevel: DifficultyLevel.challenging,
    partyLevel: PartyLevel.beginners,
  );
  
  final challengingEncounter = service.generateEncounter(challengingRequest);
  print('Desafiador (1d12): Roll = ${challengingEncounter.roll} (deve estar entre 1-12)');
  
  // Teste com Extraplanar (deve usar 1d8 automaticamente)
  final extraplanarRequest = EncounterGenerationRequest(
    terrainType: TerrainType.extraplanar,
    difficultyLevel: DifficultyLevel.easy, // Deve ser ignorado
    partyLevel: PartyLevel.beginners,
  );
  
  final extraplanarEncounter = service.generateEncounter(extraplanarRequest);
  print('Extraplanar (1d8): Roll = ${extraplanarEncounter.roll} (deve estar entre 1-8)');
  
  print('=== FIM DO TESTE ===');
} 