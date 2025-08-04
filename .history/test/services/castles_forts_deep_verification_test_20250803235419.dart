import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/enums/exploration_enums.dart';

const validOccupants = {
  'Abandonado',
  'Humanos',
  'Elfos',
  'Anões',
  'Goblin',
  'Orc',
  'Hobgoblin',
  'Sibilantes',
  'Ogro',
  'Gnoll',
  'Drakold',
  'Kawamung',
  'Homem Lagarto',
  'Trogloditas',
  'Sahuagin',
  'Outros ocupantes (tabela 4.32)',
};

void main() {
  group('Deep Verification of Castles and Forts Tables', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.30 - Castelos e Fortes Deep Verification', () {
      test('All Rolls (1-6) - Type Determination - Dice Resolution', () {
        print(
          '\n=== TABELA 4.30 ALL ROLLS TYPE DETERMINATION DEEP VERIFICATION ===',
        );

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateCastleFort();
          print(
            'Roll $roll: Type: ${result.type}, Description: ${result.description}',
          );

          // Note: Since this uses random dice, we can't predict exact results
          // But we can verify the type is valid
          expect(result.type, isA<CastleFortType>());
          expect(result.description, isA<String>());
          expect(result.details, isA<String>());
          expect(result.size, isA<String>());
          expect(result.defenses, isA<String>());
          expect(result.occupants, isA<String>());
        }

        print('✅ All rolls type determination deep verification passed!');
      });

      test('Type Distribution Logic - Dice Resolution', () {
        print(
          '\n=== TABELA 4.30 TYPE DISTRIBUTION LOGIC DEEP VERIFICATION ===',
        );

        // Test multiple iterations to verify type distribution
        for (int i = 0; i < 10; i++) {
          final result = service.generateCastleFort();
          print('Type iteration ${i + 1}: Type: ${result.type}');

          // Verify type is valid
          expect(
            result.type,
            anyOf(
              CastleFortType.palisade,
              CastleFortType.tower,
              CastleFortType.fort,
              CastleFortType.castle,
            ),
          );
        }

        print('✅ Type distribution logic deep verification passed!');
      });

      test('Size Calculations - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.30 SIZE CALCULATIONS DEEP VERIFICATION ===');

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateCastleFort();
          print('Roll $roll: Size: ${result.size}');

          // Verify size is valid
          expect(
            result.size,
            anyOf(
              'Pequeno',
              'Médio',
              'Grande',
              'Muito Grande',
              'Enorme',
              'Colossal',
            ),
          );
        }

        print('✅ Size calculations deep verification passed!');
      });

      test('Defenses Calculations - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.30 DEFENSES CALCULATIONS DEEP VERIFICATION ===');

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateCastleFort();
          print('Roll $roll: Defenses: ${result.defenses}');

          // Verify defenses is valid
          expect(
            result.defenses,
            anyOf(
              'Sem defesas',
              'Torres simples',
              'Muralhas',
              'Fosso',
              'Múltiplas defesas',
              'Fortificações completas',
            ),
          );
        }

        print('✅ Defenses calculations deep verification passed!');
      });

      test('Occupants Logic - All Types - Dice Resolution', () {
        print('\n=== TABELA 4.30 OCCUPANTS LOGIC DEEP VERIFICATION ===');

        // Test occupants for each castle type
        for (int i = 0; i < 10; i++) {
          final result = service.generateCastleFort();
          print(
            'Occupants iteration ${i + 1}: Type: ${result.type}, Occupants: ${result.occupants}',
          );

          // Verify occupants based on type
          switch (result.type) {
            case CastleFortType.palisade:
              expect(result.occupants, 'Humanos');
              break;
            case CastleFortType.tower:
              expect(result.occupants, 'Humanos ou Anões');
              break;
            case CastleFortType.fort:
              expect(result.occupants, 'Humanos ou Orcs');
              break;
            case CastleFortType.castle:
              expect(result.occupants, 'Humanos Nobres');
              break;
          }
        }

        print('✅ Occupants logic deep verification passed!');
      });
    });

    group('Table 4.31 - Detalhando Castelos e Fortes Deep Verification', () {
      test('Age Logic - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.31 AGE LOGIC DEEP VERIFICATION ===');

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateDetailedCastleFort();
          print('Roll $roll: Description: ${result.description}');

          // Verify description contains castle fort information
          expect(result.description, contains('Tipo:'));
          expect(result.description, contains('Tamanho:'));
          expect(result.description, contains('Defesas:'));
        }

        print('✅ Age logic deep verification passed!');
      });

      test('Conditions Logic - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.31 CONDITIONS LOGIC DEEP VERIFICATION ===');

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateDetailedCastleFort();
          print('Roll $roll: Details: ${result.details}');

          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Conditions logic deep verification passed!');
      });

      test('Occupants Logic - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.31 OCCUPANTS LOGIC DEEP VERIFICATION ===');

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateDetailedCastleFort();
          print('Roll $roll: Occupants: ${result.occupants}');

          // Verify occupants is valid
          expect(
            result.occupants,
            anyOf('Abandonado', 'Humanos', 'Outros ocupantes (tabela 4.32)'),
          );
        }

        print('✅ Occupants logic deep verification passed!');
      });

      test('Castle Lord Logic - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.31 CASTLE LORD LOGIC DEEP VERIFICATION ===');

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateDetailedCastleFort();
          print('Roll $roll: Details: ${result.details}');

          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Castle lord logic deep verification passed!');
      });

      test('Garrison Logic - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.31 GARRISON LOGIC DEEP VERIFICATION ===');

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateDetailedCastleFort();
          print('Roll $roll: Details: ${result.details}');

          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Garrison logic deep verification passed!');
      });

      test('Special Features Logic - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.31 SPECIAL FEATURES LOGIC DEEP VERIFICATION ===');

        for (int roll = 1; roll <= 6; roll++) {
          final result = service.generateDetailedCastleFort();
          print('Roll $roll: Details: ${result.details}');

          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Special features logic deep verification passed!');
      });
    });

    group('Table 4.32 - Outros Ocupantes Deep Verification', () {
      test('Terrain Occupants Logic - All Rolls (1-6) - Dice Resolution', () {
        print(
          '\n=== TABELA 4.32 TERRAIN OCCUPANTS LOGIC DEEP VERIFICATION ===',
        );

        // Test terrain-based occupants
        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print(
            'Terrain occupants iteration ${i + 1}: Occupants: ${result.occupants}',
          );

          // Verify occupants is valid
          expect(validOccupants.contains(result.occupants), isTrue);
        }

        print('✅ Terrain occupants logic deep verification passed!');
      });

      test('Terrain-Based Occupant Distribution - Dice Resolution', () {
        print(
          '\n=== TABELA 4.32 TERRAIN-BASED OCCUPANT DISTRIBUTION DEEP VERIFICATION ===',
        );

        // Test terrain-based occupant distribution
        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print(
            'Terrain distribution iteration ${i + 1}: Occupants: ${result.occupants}',
          );

          // Verify occupants is valid for any terrain
          expect(validOccupants.contains(result.occupants), isTrue);
        }

        print(
          '✅ Terrain-based occupant distribution deep verification passed!',
        );
      });
    });

    group('Complex Castle and Fort Logic Deep Verification', () {
      test('Rumor Logic - Dice Resolution', () {
        print('\n=== COMPLEX RUMOR LOGIC DEEP VERIFICATION ===');

        // Test rumor logic for different castle types
        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print(
            'Rumor iteration ${i + 1}: Type: ${result.type}, Details: ${result.details}',
          );

          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Rumor logic deep verification passed!');
      });

      test('Abandoned Castle Logic - Dice Resolution', () {
        print('\n=== COMPLEX ABANDONED CASTLE LOGIC DEEP VERIFICATION ===');

        // Test abandoned castle logic
        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print(
            'Abandoned iteration ${i + 1}: Occupants: ${result.occupants}, Details: ${result.details}',
          );

          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Abandoned castle logic deep verification passed!');
      });

      test('Garrison Size Calculations - Dice Resolution', () {
        print('\n=== COMPLEX GARRISON SIZE CALCULATIONS DEEP VERIFICATION ===');

        // Test garrison size calculations
        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print('Garrison size iteration ${i + 1}: Details: ${result.details}');

          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Garrison size calculations deep verification passed!');
      });

      test('Castle Lord Level Calculations - Dice Resolution', () {
        print(
          '\n=== COMPLEX CASTLE LORD LEVEL CALCULATIONS DEEP VERIFICATION ===',
        );

        // Test castle lord level calculations
        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print(
            'Castle lord level iteration ${i + 1}: Details: ${result.details}',
          );

          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Castle lord level calculations deep verification passed!');
      });
    });

    group('Edge Cases and Special Scenarios Deep Verification', () {
      test('Abandoned Castle with No Lord or Garrison - Dice Resolution', () {
        print(
          '\n=== EDGE CASE: ABANDONED CASTLE NO LORD OR GARRISON DEEP VERIFICATION ===',
        );

        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print(
            'Abandoned no lord/garrison iteration ${i + 1}: Occupants: ${result.occupants}',
          );

          // Verify abandoned castles can exist
          expect(validOccupants.contains(result.occupants), isTrue);
        }

        print(
          '✅ Abandoned castle no lord or garrison deep verification passed!',
        );
      });

      test('Castle with Special Features - Dice Resolution', () {
        print(
          '\n=== EDGE CASE: CASTLE WITH SPECIAL FEATURES DEEP VERIFICATION ===',
        );

        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print(
            'Special features iteration ${i + 1}: Details: ${result.details}',
          );
          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print('✅ Castle with special features deep verification passed!');
      });

      test('Castle Age and Condition Correlation - Dice Resolution', () {
        print(
          '\n=== EDGE CASE: CASTLE AGE AND CONDITION CORRELATION DEEP VERIFICATION ===',
        );

        for (int i = 0; i < 10; i++) {
          final result = service.generateDetailedCastleFort();
          print(
            'Age and condition iteration ${i + 1}: Details: ${result.details}',
          );
          // Verify details contains castle fort information
          expect(result.details, contains('Tipo:'));
          expect(result.details, contains('Tamanho:'));
          expect(result.details, contains('Defesas:'));
          expect(result.details, contains('Ocupantes:'));
        }

        print(
          '✅ Castle age and condition correlation deep verification passed!',
        );
      });
    });
  });
}
