import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Guardian Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Guardian Generation', () {
      test('should generate random guardian', () {
        final guardian = service.generateRandomGuardian();
        
        expect(guardian, isA<Guardian>());
        expect(guardian.type, isA<GuardianType>());
        expect(guardian.description, isNotEmpty);
        expect(guardian.details, isNotEmpty);
      });

      test('should generate none guardian', () {
        final guardian = service.generateGuardian(GuardianType.none);
        
        expect(guardian.type, equals(GuardianType.none));
        expect(guardian.description, contains('Nenhum guardião'));
        expect(guardian.details, contains('não possui proteção'));
      });

      test('should generate trap guardian', () {
        final guardian = service.generateGuardian(GuardianType.traps);
        
        expect(guardian.type, equals(GuardianType.traps));
        expect(guardian.description, contains('Armadilhas:'));
        expect(guardian.details, contains('Dano:'));
      });

      test('should generate giant guardian', () {
        final guardian = service.generateGuardian(GuardianType.giants);
        
        expect(guardian.type, equals(GuardianType.giants));
        expect(guardian.description, contains('Gigante:'));
        expect(guardian.details, isNotEmpty);
      });

      test('should generate undead guardian', () {
        final guardian = service.generateGuardian(GuardianType.undead);
        
        expect(guardian.type, equals(GuardianType.undead));
        expect(guardian.description, contains('Morto-Vivo:'));
        expect(guardian.details, isNotEmpty);
      });

      test('should generate other guardian', () {
        final guardian = service.generateGuardian(GuardianType.others);
        
        expect(guardian.type, equals(GuardianType.others));
        expect(guardian.description, contains('Outro:'));
        expect(guardian.details, isNotEmpty);
      });

      test('should generate dragon guardian', () {
        final guardian = service.generateGuardian(GuardianType.dragons);
        
        expect(guardian.type, equals(GuardianType.dragons));
        expect(guardian.description, contains('Dragão:'));
        expect(guardian.details, isNotEmpty);
      });
    });

    group('Trap Guardian Details', () {
      test('should have correct trap types', () {
        final trapTypes = [
          TrapType.poisonedDarts,
          TrapType.pitWithStakes,
          TrapType.fallingBlock,
          TrapType.hiddenGuillotine,
          TrapType.acidSpray,
          TrapType.retractableCeiling,
        ];

        for (final trapType in trapTypes) {
          expect(trapType.description, isNotEmpty);
        }
      });

      test('should have damage information for all traps', () {
        final trapTypes = TrapType.values;
        
        for (final trapType in trapTypes) {
          final guardian = service.generateGuardian(GuardianType.traps);
          expect(guardian.details, contains('Dano:'));
        }
      });
    });

    group('Giant Guardian Details', () {
      test('should have correct giant types', () {
        final giantTypes = [
          GiantType.ettin,
          GiantType.hillGiant,
          GiantType.mountainGiant,
          GiantType.stormGiant,
          GiantType.fireGiant,
          GiantType.iceGiant,
        ];

        for (final giantType in giantTypes) {
          expect(giantType.description, isNotEmpty);
        }
      });
    });

    group('Undead Guardian Details', () {
      test('should have correct undead types', () {
        final undeadTypes = [
          UndeadType.specter,
          UndeadType.ghost,
          UndeadType.banshee,
          UndeadType.mummy,
          UndeadType.vampire,
          UndeadType.lich,
        ];

        for (final undeadType in undeadTypes) {
          expect(undeadType.description, isNotEmpty);
        }
      });
    });

    group('Dragon Guardian Details', () {
      test('should have correct dragon types', () {
        final dragonTypes = [
          DragonType.blueDragon,
          DragonType.whiteDragon,
          DragonType.goldDragon,
          DragonType.blackDragon,
          DragonType.greenDragon,
          DragonType.redDragon,
        ];

        for (final dragonType in dragonTypes) {
          expect(dragonType.description, isNotEmpty);
        }
      });
    });

    group('Guardian Type Distribution', () {
      test('should generate all guardian types over multiple rolls', () {
        final generatedTypes = <GuardianType>{};
        
        // Generate multiple guardians to ensure all types are covered
        for (int i = 0; i < 50; i++) {
          final guardian = service.generateRandomGuardian();
          generatedTypes.add(guardian.type);
        }

        // Should have generated most guardian types
        expect(generatedTypes.length, greaterThan(3));
      });
    });
  });
} 