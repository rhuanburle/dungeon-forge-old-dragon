import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Double Roll Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Magical Items with Double Rolls', () {
      test('should handle double rolls for rings', () {
        // Testar múltiplas vezes para pegar o caso "Jogue 2 vezes"
        for (int i = 0; i < 10; i++) {
          final magicalItem = service.generateMagicalItem();

          if (magicalItem.type == MagicalItemType.rings) {
            expect(magicalItem.power, isNotEmpty);

            // Se contém "e", significa que foi uma rolagem dupla
            if (magicalItem.power.contains(' e ')) {
              expect(magicalItem.power, contains('Anel'));
              print('Double roll result: ${magicalItem.power}');
            }
          }
        }
      });

      test('should handle double rolls for other items', () {
        // Testar múltiplas vezes para pegar o caso "Jogue 2 vezes"
        for (int i = 0; i < 10; i++) {
          final magicalItem = service.generateMagicalItem();

          if (magicalItem.type == MagicalItemType.others) {
            expect(magicalItem.power, isNotEmpty);

            // Se contém "e", significa que foi uma rolagem dupla
            if (magicalItem.power.contains(' e ')) {
              expect(
                magicalItem.power,
                anyOf(
                  contains('Sacola'),
                  contains('Bola'),
                  contains('Manto'),
                  contains('Botas'),
                  contains('Manoplas'),
                ),
              );
              print('Double roll result: ${magicalItem.power}');
            }
          }
        }
      });
    });

    group('Relics with Double Rolls', () {
      test('should handle double rolls for magical weapons', () {
        // Testar múltiplas vezes para pegar o caso "Jogue 2 vezes"
        for (int i = 0; i < 10; i++) {
          final relic = service.generateRelic();

          if (relic.condition.contains('mágica') &&
              relic.type == RelicType.weapons) {
            expect(relic.details, isNotEmpty);

            // Se contém "e", significa que foi uma rolagem dupla
            if (relic.details.contains(' e ')) {
              expect(relic.details, contains('LB2'));
              print('Double roll result: ${relic.details}');
            }
          }
        }
      });

      test('should handle double rolls for magical containers', () {
        // Testar múltiplas vezes para pegar o caso "Jogue 2 vezes"
        for (int i = 0; i < 10; i++) {
          final relic = service.generateRelic();

          if (relic.condition.contains('mágica') &&
              relic.type == RelicType.containers) {
            expect(relic.details, isNotEmpty);

            // Se contém "e", significa que foi uma rolagem dupla
            if (relic.details.contains(' e ')) {
              expect(relic.details, contains('LB2'));
              print('Double roll result: ${relic.details}');
            }
          }
        }
      });
    });
  });
}
