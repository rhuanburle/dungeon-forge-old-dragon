import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Exploration Improvements Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Ruins with Dice Rolls', () {
      test('should generate ruins with resolved dice rolls', () {
        final ruin = service.generateRuin();

        expect(ruin, isA<Ruin>());
        expect(ruin.type, isA<RuinType>());
        expect(ruin.description, isNotEmpty);
        expect(ruin.details, isNotEmpty);
        expect(ruin.size, isNotEmpty);

        // Verificar se as rolagens foram resolvidas
        if (ruin.size.contains('casas')) {
          expect(ruin.size, matches(r'\d+ casas'));
        }
      });

      test('should generate village with correct dice rolls', () {
        final ruin = service.generateRuin();

        if (ruin.type == RuinType.village) {
          expect(ruin.size, matches(r'\d+ casas'));
        }
      });

      test('should generate city with correct dice rolls', () {
        final ruin = service.generateRuin();

        if (ruin.type == RuinType.city) {
          expect(ruin.size, matches(r'\d+ casas'));
        }
      });
    });

    group('Relics with Magic Items', () {
      test(
        'should generate relics with magic items when condition is magical',
        () {
          final relic = service.generateRelic();

          expect(relic, isA<Relic>());
          expect(relic.type, isA<RelicType>());
          expect(relic.description, isNotEmpty);
          expect(relic.details, isNotEmpty);
          expect(relic.condition, isNotEmpty);

          // Verificar se itens mágicos estão sendo gerados
          if (relic.condition.contains('mágica')) {
            expect(relic.details, contains('LB2'));
          }
        },
      );

      test('should generate relics with silver/mithral items', () {
        final relic = service.generateRelic();

        if (relic.condition.contains('prata') ||
            relic.condition.contains('mitral')) {
          expect(relic.details, anyOf(contains('prata'), contains('mitral')));
        }
      });
    });

    group('Magical Items', () {
      test('should generate magical items with correct powers', () {
        final magicalItem = service.generateMagicalItem();

        expect(magicalItem, isA<MagicalItem>());
        expect(magicalItem.type, isA<MagicalItemType>());
        expect(magicalItem.description, isNotEmpty);
        expect(magicalItem.details, isNotEmpty);
        expect(magicalItem.power, isNotEmpty);

        // Verificar se o poder é específico do tipo
        switch (magicalItem.type) {
          case MagicalItemType.weapons:
            expect(
              magicalItem.power,
              anyOf(
                contains('Espada'),
                contains('Adaga'),
                contains('Machado'),
                contains('Flechas'),
              ),
            );
            break;
          case MagicalItemType.armors:
            expect(
              magicalItem.power,
              anyOf(contains('Armadura'), contains('Escudo'), contains('Cota')),
            );
            break;
          case MagicalItemType.potions:
            expect(
              magicalItem.power,
              anyOf(contains('Poção'), contains('Venenos')),
            );
            break;
          case MagicalItemType.rings:
            expect(
              magicalItem.power,
              anyOf(contains('Anel'), contains('Jogue 2 vezes')),
            );
            break;
          case MagicalItemType.staves:
            expect(
              magicalItem.power,
              anyOf(
                contains('Varinha'),
                contains('Cajado'),
                contains('Bastão'),
              ),
            );
            break;
          case MagicalItemType.others:
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
            break;
        }
      });
    });

    group('Ancestral Discoveries', () {
      test('should generate complete ancestral discovery', () {
        final discovery = service.generateAncestralDiscovery();

        expect(discovery, isA<AncestralDiscovery>());
        expect(discovery.type, isA<AncestralThingType>());
        expect(discovery.condition, isA<AncestralCondition>());
        expect(discovery.material, isA<AncestralMaterial>());
        expect(discovery.state, isA<AncestralState>());
        expect(discovery.guardian, isA<AncestralGuardian>());
        expect(discovery.description, isNotEmpty);
        expect(discovery.details, isNotEmpty);
      });
    });
  });
}
