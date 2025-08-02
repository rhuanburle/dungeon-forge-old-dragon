import 'lib/services/dungeon_data_service.dart';
import 'lib/services/room_generation_service.dart';
import 'lib/utils/dice_roller.dart';

void main() {
  print('=== TESTE DE ROLAGENS DE MASMORRA ===');
  
  // Teste de 2d6 para verificar range
  print('\n--- Teste de 2d6 ---');
  for (int i = 0; i < 20; i++) {
    final roll = DiceRoller.rollStatic(2, 6);
    print('Roll $i: $roll (deve estar entre 2-12)');
    if (roll < 2 || roll > 12) {
      print('❌ ERRO: Roll fora do range 2-12!');
    }
  }
  
  // Teste de geração de dados da masmorra
  print('\n--- Teste de Geração de Dados da Masmorra ---');
  final dungeonService = DungeonDataService();
  final dungeonData = dungeonService.generateDungeonData();
  
  print('Tipo: ${dungeonData.type.description}');
  print('Construtor: ${dungeonData.builderOrInhabitant.description}');
  print('Status: ${dungeonData.status.description}');
  print('Objetivo: ${dungeonData.objective.description}');
  print('Alvo: ${dungeonData.target.description}');
  print('Status do Alvo: ${dungeonData.targetStatus.description}');
  print('Localização: ${dungeonData.location.description}');
  print('Entrada: ${dungeonData.entry.description}');
  print('Fórmula de Tamanho: ${dungeonData.sizeFormula}');
  print('Ocupante I: ${dungeonData.occupantI}');
  print('Ocupante II: ${dungeonData.occupantII}');
  print('Líder: ${dungeonData.leader}');
  
  // Teste de geração de salas
  print('\n--- Teste de Geração de Salas ---');
  final roomService = RoomGenerationService();
  final room = roomService.generateRoom(dungeonData, 0);
  
  print('Tipo de Sala: ${room.type.description}');
  print('Corrente de Ar: ${room.airCurrent.description}');
  print('Odor: ${room.smell.description}');
  print('Som: ${room.sound.description}');
  print('Item Encontrado: ${room.foundItem.description}');
  if (room.specialItem != null) {
    print('Item Especial: ${room.specialItem!.description}');
  }
  
  print('\n=== FIM DO TESTE ===');
} 