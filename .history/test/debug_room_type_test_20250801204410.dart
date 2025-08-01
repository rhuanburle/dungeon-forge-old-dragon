// test/debug_room_type_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:dungeon_forge/services/dungeon_generator_refactored.dart';
import 'package:dungeon_forge/mappers/dungeon_mapper.dart';
import 'package:dungeon_forge/models/dto/dungeon_generation_dto.dart';
import 'package:dungeon_forge/enums/room_tables.dart';

void main() {
  group('Room Type Display', () {
    test('should not show empty parentheses in room types', () {
      final generator = DungeonGeneratorRefactored();
      final dungeon = generator.generate();
      
      print('=== DEBUG ROOM TYPES ===');
      for (final room in dungeon.rooms) {
        print('Sala ${room.index}: ${room.type}');
        
        // Verifica se não há parênteses vazios
        expect(room.type, isNot(contains('()')));
        expect(room.type, isNot(contains('( )')));
        expect(room.type, isNot(contains('(  )')));
      }
      print('========================');
    });

    test('should show parentheses only when there is content', () {
      final generator = DungeonGeneratorRefactored();
      final dungeon = generator.generate();
      
      for (final room in dungeon.rooms) {
        if (room.type.contains('(') && room.type.contains(')')) {
          // Se tem parênteses, deve ter conteúdo entre eles
          final startIndex = room.type.indexOf('(');
          final endIndex = room.type.indexOf(')');
          final content = room.type.substring(startIndex + 1, endIndex);
          
          expect(content.trim(), isNotEmpty, reason: 'Room type: ${room.type}');
        }
      }
    });

    test('should handle all room types correctly', () {
      final generator = DungeonGeneratorRefactored();
      final dungeon = generator.generate();
      
      final validTypes = [
        'Sala Especial',
        'Armadilha',
        'Sala Comum',
        'Encontro',
        'Sala Armadilha Especial',
      ];
      
      for (final room in dungeon.rooms) {
        bool isValidType = false;
        for (final validType in validTypes) {
          if (room.type.startsWith(validType)) {
            isValidType = true;
            break;
          }
        }
        
        expect(isValidType, isTrue, reason: 'Invalid room type: ${room.type}');
      }
    });
  });
} 