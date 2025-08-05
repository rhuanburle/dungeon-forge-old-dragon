import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Recursion Safety Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    test('should not cause infinite recursion in double rolls', () {
      // Testar múltiplas vezes para garantir que não há recursão infinita
      for (int i = 0; i < 50; i++) {
        final magicalItem = service.generateMagicalItem();
        expect(magicalItem, isA<MagicalItem>());
        expect(magicalItem.power, isNotEmpty);

        // Verificar se não há recursão infinita
        expect(magicalItem.power, isNot(contains('Jogue 2 vezes')));
      }
    });

    test('should not cause infinite recursion in relics', () {
      // Testar múltiplas vezes para garantir que não há recursão infinita
      for (int i = 0; i < 50; i++) {
        final relic = service.generateRelic();
        expect(relic, isA<Relic>());
        expect(relic.details, isNotEmpty);

        // Verificar se não há recursão infinita
        expect(relic.details, isNot(contains('Jogue 2 vezes')));
      }
    });

    test('should handle complex double roll scenarios', () {
      // Testar cenários complexos de rolagem dupla
      for (int i = 0; i < 20; i++) {
        final magicalItem = service.generateMagicalItem();

        if (magicalItem.type == MagicalItemType.rings ||
            magicalItem.type == MagicalItemType.others) {
          // Verificar se o resultado é válido
          expect(magicalItem.power, isNotEmpty);
          expect(
            magicalItem.power.length,
            lessThan(200),
          ); // Não deve ser muito longo

          // Se contém "e", deve ter pelo menos dois itens
          if (magicalItem.power.contains(' e ')) {
            final parts = magicalItem.power.split(' e ');
            expect(parts.length, greaterThanOrEqualTo(2));
            expect(parts[0], isNotEmpty);
            expect(parts[1], isNotEmpty);
          }
        }
      }
    });
  });
}
