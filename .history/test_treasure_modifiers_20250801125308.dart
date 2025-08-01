import 'lib/services/dungeon_generator.dart';
import 'lib/utils/dice_roller.dart';

void main() {
  print('Testando modificadores de tesouro...\n');
  
  final generator = DungeonGenerator();
  
  // Testa várias gerações para ver se os modificadores estão sendo aplicados
  for (int i = 1; i <= 5; i++) {
    print('=== Teste $i ===');
    final dungeon = generator.generate(level: 3, theme: "Teste", customRoomCount: 3);
    
    for (final room in dungeon.rooms) {
      print('Sala ${room.index}: ${room.type}');
      print('  Tesouro: ${room.treasure}');
      print('  Tesouro Especial: ${room.specialTreasure}');
      print('  Item Mágico: ${room.magicItem}');
      print('');
    }
  }
} 