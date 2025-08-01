// test/debug_dungeon_info_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:dungeon_forge/services/dungeon_data_service.dart';
import 'package:dungeon_forge/mappers/dungeon_mapper.dart';
import 'package:dungeon_forge/models/dto/dungeon_generation_dto.dart';

void main() {
  group('Debug Dungeon Info', () {
    test('should generate dungeon with all required information', () {
      final service = DungeonDataService();
      final dto = service.generateDungeonData();
      
      print('=== DEBUG DUNGEON INFO ===');
      print('Tipo (Coluna 1): ${dto.type.description}');
      print('Construtor/Habitante (Coluna 2): ${dto.builderOrInhabitant.description}');
      print('Status (Coluna 3): ${dto.status.description}');
      print('Objetivo: ${dto.fullObjective}');
      print('Localização: ${dto.location.description}');
      print('Entrada: ${dto.entry.description}');
      print('Ocupante I: ${dto.occupantI}');
      print('Ocupante II: ${dto.occupantII}');
      print('Líder: ${dto.leader}');
      print('Rumor: ${dto.fullRumor}');
      print('========================');
      
      // Verifica se todos os campos estão preenchidos
      expect(dto.type.description, isNotEmpty);
      expect(dto.builderOrInhabitant.description, isNotEmpty);
      expect(dto.status.description, isNotEmpty);
      expect(dto.fullObjective, isNotEmpty);
      expect(dto.location.description, isNotEmpty);
      expect(dto.entry.description, isNotEmpty);
      expect(dto.occupantI, isNotEmpty);
      expect(dto.occupantII, isNotEmpty);
      expect(dto.leader, isNotEmpty);
      expect(dto.fullRumor, isNotEmpty);
    });

    test('should map DTO to Dungeon model correctly', () {
      final service = DungeonDataService();
      final dto = service.generateDungeonData();
      
      // Simula uma lista vazia de salas para o teste
      final rooms = <dynamic>[];
      final dungeon = DungeonMapper.fromDto(dto, rooms);
      
      print('=== MAPPED DUNGEON INFO ===');
      print('Tipo: ${dungeon.type}');
      print('Construtor/Habitante: ${dungeon.builderOrInhabitant}');
      print('Status: ${dungeon.status}');
      print('Objetivo: ${dungeon.objective}');
      print('Localização: ${dungeon.location}');
      print('Entrada: ${dungeon.entry}');
      print('Ocupante I: ${dungeon.occupant1}');
      print('Ocupante II: ${dungeon.occupant2}');
      print('Líder: ${dungeon.leader}');
      print('Rumor: ${dungeon.rumor1}');
      print('==========================');
      
      // Verifica se todos os campos estão mapeados corretamente
      expect(dungeon.type, equals(dto.type.description));
      expect(dungeon.builderOrInhabitant, equals(dto.builderOrInhabitant.description));
      expect(dungeon.status, equals(dto.status.description));
      expect(dungeon.objective, equals(dto.fullObjective));
      expect(dungeon.location, equals(dto.location.description));
      expect(dungeon.entry, equals(dto.entry.description));
      expect(dungeon.occupant1, equals(dto.occupantI));
      expect(dungeon.occupant2, equals(dto.occupantII));
      expect(dungeon.leader, equals(dto.leader));
      expect(dungeon.rumor1, equals(dto.fullRumor));
    });
  });
} 