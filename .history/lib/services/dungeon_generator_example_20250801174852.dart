// services/dungeon_generator_example.dart

import 'dungeon_generator_refactored.dart';

/// Exemplo de uso do gerador de masmorras refatorado
class DungeonGeneratorExample {
  static void demonstrateUsage() {
    final generator = DungeonGeneratorRefactored();

    // Exemplo 1: Geração básica
    print('=== Exemplo 1: Geração Básica ===');
    final dungeon1 = generator.generate(
      level: 3,
      theme: 'Recuperar artefato',
    );
    print(dungeon1);

    // Exemplo 2: Com número customizado de salas
    print('\n=== Exemplo 2: Com Número Customizado de Salas ===');
    final dungeon2 = generator.generate(
      level: 5,
      theme: 'Explorar ruínas',
      customRoomCount: 8,
    );
    print(dungeon2);

    // Exemplo 3: Com intervalo de salas
    print('\n=== Exemplo 3: Com Intervalo de Salas ===');
    final dungeon3 = generator.generate(
      level: 7,
      theme: 'Caçar tesouro',
      minRooms: 6,
      maxRooms: 12,
    );
    print(dungeon3);

    // Exemplo 4: Com mínimo de salas
    print('\n=== Exemplo 4: Com Mínimo de Salas ===');
    final dungeon4 = generator.generate(
      level: 4,
      theme: 'Investigar culto',
      minRooms: 10,
    );
    print(dungeon4);

    // Exemplo 5: Com máximo de salas
    print('\n=== Exemplo 5: Com Máximo de Salas ===');
    final dungeon5 = generator.generate(
      level: 6,
      theme: 'Resgatar prisioneiro',
      maxRooms: 8,
    );
    print(dungeon5);
  }

  /// Demonstra a estrutura de dados gerada
  static void demonstrateDataStructure() {
    final generator = DungeonGeneratorRefactored();
    final dungeon = generator.generate(level: 3, theme: 'Teste');

    print('=== Estrutura de Dados Gerada ===');
    print('Tipo: ${dungeon.type}');
    print('Construtor/Habitante: ${dungeon.builderOrInhabitant}');
    print('Status: ${dungeon.status}');
    print('Objetivo: ${dungeon.objective}');
    print('Localização: ${dungeon.location}');
    print('Entrada: ${dungeon.entry}');
    print('Número de Salas: ${dungeon.roomsCount}');
    print('Ocupante I: ${dungeon.occupant1}');
    print('Ocupante II: ${dungeon.occupant2}');
    print('Líder: ${dungeon.leader}');
    print('Rumor: ${dungeon.rumor1}');

    print('\n=== Salas ===');
    for (final room in dungeon.rooms) {
      print('Sala ${room.index}:');
      print('  Tipo: ${room.type}');
      print('  Ar: ${room.air}');
      print('  Cheiro: ${room.smell}');
      print('  Som: ${room.sound}');
      print('  Item: ${room.item}');
      if (room.specialItem.isNotEmpty) {
        print('  Item Especial: ${room.specialItem}');
      }
      if (room.monster1.isNotEmpty) {
        print('  Monstro 1: ${room.monster1}');
      }
      if (room.monster2.isNotEmpty) {
        print('  Monstro 2: ${room.monster2}');
      }
      if (room.trap.isNotEmpty) {
        print('  Armadilha: ${room.trap}');
      }
      if (room.specialTrap.isNotEmpty) {
        print('  Armadilha Especial: ${room.specialTrap}');
      }
      if (room.roomCommon.isNotEmpty) {
        print('  Sala Comum: ${room.roomCommon}');
      }
      if (room.roomSpecial.isNotEmpty) {
        print('  Sala Especial: ${room.roomSpecial}');
      }
      if (room.roomSpecial2.isNotEmpty) {
        print('  Sala Especial 2: ${room.roomSpecial2}');
      }
      if (room.treasure.isNotEmpty) {
        print('  Tesouro: ${room.treasure}');
      }
      if (room.specialTreasure.isNotEmpty) {
        print('  Tesouro Especial: ${room.specialTreasure}');
      }
      if (room.magicItem.isNotEmpty) {
        print('  Item Mágico: ${room.magicItem}');
      }
      print('');
    }
  }
}
