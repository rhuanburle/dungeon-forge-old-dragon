// services/dungeon_generator_test.dart

import 'dart:math';
import 'dungeon_generator.dart';
import 'dungeon_generator_refactored.dart';
import '../utils/dice_roller.dart';

/// Teste para verificar se as regras de negócio estão idênticas
class DungeonGeneratorTest {
  static void runCompatibilityTest() {
    print('=== Teste de Compatibilidade ===');

    // Testa com seed fixo para garantir resultados idênticos
    final random = Random(42);

    final originalGenerator = DungeonGenerator();
    final refactoredGenerator = DungeonGeneratorRefactored();

    // Teste 1: Geração básica
    print('\n--- Teste 1: Geração Básica ---');
    final original1 = originalGenerator.generate(
      level: 3,
      theme: 'Teste',
    );

    final refactored1 = refactoredGenerator.generate(
      level: 3,
      theme: 'Teste',
    );

    _compareDungeons(original1, refactored1, 'Geração Básica');

    // Teste 2: Com número customizado
    print('\n--- Teste 2: Com Número Customizado ---');
    final original2 = originalGenerator.generate(
      level: 5,
      theme: 'Teste',
      customRoomCount: 8,
    );

    final refactored2 = refactoredGenerator.generate(
      level: 5,
      theme: 'Teste',
      customRoomCount: 8,
    );

    _compareDungeons(original2, refactored2, 'Com Número Customizado');

    // Teste 3: Com intervalo
    print('\n--- Teste 3: Com Intervalo ---');
    final original3 = originalGenerator.generate(
      level: 7,
      theme: 'Teste',
      minRooms: 6,
      maxRooms: 12,
    );

    final refactored3 = refactoredGenerator.generate(
      level: 7,
      theme: 'Teste',
      minRooms: 6,
      maxRooms: 12,
    );

    _compareDungeons(original3, refactored3, 'Com Intervalo');

    print('\n=== Teste Concluído ===');
  }

  static void _compareDungeons(
    dynamic original,
    dynamic refactored,
    String testName,
  ) {
    print('Testando: $testName');

    // Compara propriedades básicas
    bool propertiesMatch = true;

    if (original.type != refactored.type) {
      print('❌ Tipo diferente: ${original.type} vs ${refactored.type}');
      propertiesMatch = false;
    }

    if (original.builderOrInhabitant != refactored.builderOrInhabitant) {
      print(
          '❌ Construtor diferente: ${original.builderOrInhabitant} vs ${refactored.builderOrInhabitant}');
      propertiesMatch = false;
    }

    if (original.status != refactored.status) {
      print('❌ Status diferente: ${original.status} vs ${refactored.status}');
      propertiesMatch = false;
    }

    if (original.objective != refactored.objective) {
      print(
          '❌ Objetivo diferente: ${original.objective} vs ${refactored.objective}');
      propertiesMatch = false;
    }

    if (original.location != refactored.location) {
      print(
          '❌ Localização diferente: ${original.location} vs ${refactored.location}');
      propertiesMatch = false;
    }

    if (original.entry != refactored.entry) {
      print('❌ Entrada diferente: ${original.entry} vs ${refactored.entry}');
      propertiesMatch = false;
    }

    if (original.roomsCount != refactored.roomsCount) {
      print(
          '❌ Número de salas diferente: ${original.roomsCount} vs ${refactored.roomsCount}');
      propertiesMatch = false;
    }

    if (original.occupant1 != refactored.occupant1) {
      print(
          '❌ Ocupante 1 diferente: ${original.occupant1} vs ${refactored.occupant1}');
      propertiesMatch = false;
    }

    if (original.occupant2 != refactored.occupant2) {
      print(
          '❌ Ocupante 2 diferente: ${original.occupant2} vs ${refactored.occupant2}');
      propertiesMatch = false;
    }

    if (original.leader != refactored.leader) {
      print('❌ Líder diferente: ${original.leader} vs ${refactored.leader}');
      propertiesMatch = false;
    }

    if (original.rumor1 != refactored.rumor1) {
      print('❌ Rumor diferente: ${original.rumor1} vs ${refactored.rumor1}');
      propertiesMatch = false;
    }

    // Compara salas
    if (original.rooms.length != refactored.rooms.length) {
      print(
          '❌ Número de salas diferente: ${original.rooms.length} vs ${refactored.rooms.length}');
      propertiesMatch = false;
    } else {
      for (int i = 0; i < original.rooms.length; i++) {
        final originalRoom = original.rooms[i];
        final refactoredRoom = refactored.rooms[i];

        if (originalRoom.type != refactoredRoom.type) {
          print(
              '❌ Tipo da sala ${i + 1} diferente: ${originalRoom.type} vs ${refactoredRoom.type}');
          propertiesMatch = false;
        }

        if (originalRoom.air != refactoredRoom.air) {
          print(
              '❌ Ar da sala ${i + 1} diferente: ${originalRoom.air} vs ${refactoredRoom.air}');
          propertiesMatch = false;
        }

        if (originalRoom.smell != refactoredRoom.smell) {
          print(
              '❌ Cheiro da sala ${i + 1} diferente: ${originalRoom.smell} vs ${refactoredRoom.smell}');
          propertiesMatch = false;
        }

        if (originalRoom.sound != refactoredRoom.sound) {
          print(
              '❌ Som da sala ${i + 1} diferente: ${originalRoom.sound} vs ${refactoredRoom.sound}');
          propertiesMatch = false;
        }

        if (originalRoom.item != refactoredRoom.item) {
          print(
              '❌ Item da sala ${i + 1} diferente: ${originalRoom.item} vs ${refactoredRoom.item}');
          propertiesMatch = false;
        }

        if (originalRoom.specialItem != refactoredRoom.specialItem) {
          print(
              '❌ Item especial da sala ${i + 1} diferente: ${originalRoom.specialItem} vs ${refactoredRoom.specialItem}');
          propertiesMatch = false;
        }

        if (originalRoom.monster1 != refactoredRoom.monster1) {
          print(
              '❌ Monstro 1 da sala ${i + 1} diferente: ${originalRoom.monster1} vs ${refactoredRoom.monster1}');
          propertiesMatch = false;
        }

        if (originalRoom.monster2 != refactoredRoom.monster2) {
          print(
              '❌ Monstro 2 da sala ${i + 1} diferente: ${originalRoom.monster2} vs ${refactoredRoom.monster2}');
          propertiesMatch = false;
        }

        if (originalRoom.trap != refactoredRoom.trap) {
          print(
              '❌ Armadilha da sala ${i + 1} diferente: ${originalRoom.trap} vs ${refactoredRoom.trap}');
          propertiesMatch = false;
        }

        if (originalRoom.specialTrap != refactoredRoom.specialTrap) {
          print(
              '❌ Armadilha especial da sala ${i + 1} diferente: ${originalRoom.specialTrap} vs ${refactoredRoom.specialTrap}');
          propertiesMatch = false;
        }

        if (originalRoom.roomCommon != refactoredRoom.roomCommon) {
          print(
              '❌ Sala comum da sala ${i + 1} diferente: ${originalRoom.roomCommon} vs ${refactoredRoom.roomCommon}');
          propertiesMatch = false;
        }

        if (originalRoom.roomSpecial != refactoredRoom.roomSpecial) {
          print(
              '❌ Sala especial da sala ${i + 1} diferente: ${originalRoom.roomSpecial} vs ${refactoredRoom.roomSpecial}');
          propertiesMatch = false;
        }

        if (originalRoom.roomSpecial2 != refactoredRoom.roomSpecial2) {
          print(
              '❌ Sala especial 2 da sala ${i + 1} diferente: ${originalRoom.roomSpecial2} vs ${refactoredRoom.roomSpecial2}');
          propertiesMatch = false;
        }

        if (originalRoom.treasure != refactoredRoom.treasure) {
          print(
              '❌ Tesouro da sala ${i + 1} diferente: ${originalRoom.treasure} vs ${refactoredRoom.treasure}');
          propertiesMatch = false;
        }

        if (originalRoom.specialTreasure != refactoredRoom.specialTreasure) {
          print(
              '❌ Tesouro especial da sala ${i + 1} diferente: ${originalRoom.specialTreasure} vs ${refactoredRoom.specialTreasure}');
          propertiesMatch = false;
        }

        if (originalRoom.magicItem != refactoredRoom.magicItem) {
          print(
              '❌ Item mágico da sala ${i + 1} diferente: ${originalRoom.magicItem} vs ${refactoredRoom.magicItem}');
          propertiesMatch = false;
        }
      }
    }

    if (propertiesMatch) {
      print('✅ $testName: Todas as propriedades são idênticas!');
    } else {
      print('❌ $testName: Diferenças encontradas!');
    }
  }
}
