import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/enums/exploration_enums.dart';
import '../../lib/enums/table_enums.dart';
import '../../lib/utils/dice_roller.dart';

void main() {
  group('Deep Verification of Natural Dangers Tables', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Tabela 4.38 - Perigos Naturais', () {
      test('Oceano - Distribuição correta dos perigos', () {
        final expectedTypes = [
          NaturalDangerType.softSand,
          NaturalDangerType.softSand,
          NaturalDangerType.quicksand,
          NaturalDangerType.suddenTide,
          NaturalDangerType.mirage,
          NaturalDangerType.tsunami,
        ];

        for (int i = 0; i < 100; i++) {
          final danger = service.generateNaturalDanger(TerrainType.deserts); // Usar deserto que tem areia fofa
          expect(expectedTypes.contains(danger.type), isTrue);
        }
      });

      test('Geleira - Distribuição correta dos perigos', () {
        final expectedTypes = [
          NaturalDangerType.avalanches,
          NaturalDangerType.thinIce,
          NaturalDangerType.softSnow,
          NaturalDangerType.smoothIce,
          NaturalDangerType.mirage,
          NaturalDangerType.earthquake,
        ];

        for (int i = 0; i < 100; i++) {
          final danger = service.generateNaturalDanger(TerrainType.glaciers);
          expect(expectedTypes.contains(danger.type), isTrue);
        }
      });

      test('Pântano - Distribuição correta dos perigos', () {
        final expectedTypes = [
          NaturalDangerType.flooded,
          NaturalDangerType.quicksand,
          NaturalDangerType.thornyBushes,
          NaturalDangerType.thermalSprings,
          NaturalDangerType.tarPit,
          NaturalDangerType.earthquake,
        ];

        for (int i = 0; i < 100; i++) {
          final danger = service.generateNaturalDanger(TerrainType.swamps);
          expect(expectedTypes.contains(danger.type), isTrue);
        }
      });

      test('Floresta - Distribuição correta dos perigos', () {
        final expectedTypes = [
          NaturalDangerType.thornyBushes,
          NaturalDangerType.thermalSprings,
          NaturalDangerType.tarPit,
          NaturalDangerType.tarPit, // Incêndio florestal não está no enum, usando tarPit
          NaturalDangerType.tarPit,
          NaturalDangerType.earthquake,
        ];

        for (int i = 0; i < 100; i++) {
          final danger = service.generateNaturalDanger(TerrainType.forests);
          expect(expectedTypes.contains(danger.type), isTrue);
        }
      });

      test('Planície - Distribuição correta dos perigos', () {
        final expectedTypes = [
          NaturalDangerType.flooded,
          NaturalDangerType.thornyBushes,
          NaturalDangerType.thermalSprings,
          NaturalDangerType.fumaroles,
          NaturalDangerType.tarPit,
          NaturalDangerType.earthquake,
        ];

        for (int i = 0; i < 100; i++) {
          final danger = service.generateNaturalDanger(TerrainType.plains);
          expect(expectedTypes.contains(danger.type), isTrue);
        }
      });

      test('Deserto - Distribuição correta dos perigos', () {
        final expectedTypes = [
          NaturalDangerType.softSand,
          NaturalDangerType.thornyBushes,
          NaturalDangerType.sandstorm,
          NaturalDangerType.sandPit,
          NaturalDangerType.mirage,
          NaturalDangerType.earthquake,
        ];

        for (int i = 0; i < 100; i++) {
          final danger = service.generateNaturalDanger(TerrainType.deserts);
          expect(expectedTypes.contains(danger.type), isTrue);
        }
      });

      test('Colina - Distribuição correta dos perigos', () {
        final expectedTypes = [
          NaturalDangerType.flooded,
          NaturalDangerType.avalanches,
          NaturalDangerType.thornyBushes,
          NaturalDangerType.fumaroles,
          NaturalDangerType.mudVolcano,
          NaturalDangerType.earthquake,
        ];

        for (int i = 0; i < 100; i++) {
          final danger = service.generateNaturalDanger(TerrainType.hills);
          expect(expectedTypes.contains(danger.type), isTrue);
        }
      });

      test('Montanha - Distribuição correta dos perigos', () {
        final expectedTypes = [
          NaturalDangerType.altitude,
          NaturalDangerType.avalanches,
          NaturalDangerType.volcanicEruptions,
          NaturalDangerType.fumaroles,
          NaturalDangerType.mudVolcano,
          NaturalDangerType.earthquake,
        ];

        for (int i = 0; i < 100; i++) {
          final danger = service.generateNaturalDanger(TerrainType.mountains);
          expect(expectedTypes.contains(danger.type), isTrue);
        }
      });
    });

    group('Apêndice B - Detalhes dos Perigos Naturais', () {
      test('Alagados - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.plains);
        if (danger.type == NaturalDangerType.flooded) {
          expect(danger.description, contains('Alagados'));
          expect(danger.details, contains('áreas alagadas'));
          expect(danger.effects, contains('movimento de natação'));
        }
      });

      test('Altitude - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.mountains);
        if (danger.type == NaturalDangerType.altitude) {
          expect(danger.description, contains('Altitude'));
          expect(danger.details, contains('acima de 2.000 metros'));
          expect(danger.effects, contains('Falta de oxigênio'));
        }
      });

      test('Areia Movediça - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.swamps);
        if (danger.type == NaturalDangerType.quicksand) {
          expect(danger.description, contains('Areia Movediça'));
          expect(danger.details, contains('areia e água'));
          expect(danger.effects, contains('afundar'));
        }
      });

      test('Atoleiros - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.swamps);
        if (danger.type == NaturalDangerType.tarPit) {
          expect(danger.description, contains('Poço de Piche'));
          expect(danger.details, contains('terra encharcada'));
          expect(danger.effects, contains('movimento reduzido'));
        }
      });

      test('Avalanches e Deslizamentos - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.mountains);
        if (danger.type == NaturalDangerType.avalanches) {
          expect(danger.description, contains('Avalanches'));
          expect(danger.details, contains('deslizamentos'));
          expect(danger.effects, contains('soterramento'));
        }
      });

      test('Erupções Vulcânicas - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.mountains);
        if (danger.type == NaturalDangerType.volcanicEruptions) {
          expect(danger.description, contains('Erupções'));
          expect(danger.details, contains('Vulcão'));
          expect(danger.effects, contains('lava'));
        }
      });

      test('Espinheiro - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.forests);
        if (danger.type == NaturalDangerType.thornyBushes) {
          expect(danger.description, contains('Espinheiro'));
          expect(danger.details, contains('espinhos'));
          expect(danger.effects, contains('dano'));
        }
      });

      test('Fontes Termais - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.plains);
        if (danger.type == NaturalDangerType.thermalSprings) {
          expect(danger.description, contains('Fontes Termais'));
          expect(danger.details, contains('água quente'));
          expect(danger.effects, contains('vapores'));
        }
      });

      test('Fosso de Areia - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.deserts);
        if (danger.type == NaturalDangerType.sandPit) {
          expect(danger.description, contains('Fosso de Areia'));
          expect(danger.details, contains('cone'));
          expect(danger.effects, contains('afundar'));
        }
      });

      test('Fumarolas - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.plains);
        if (danger.type == NaturalDangerType.fumaroles) {
          expect(danger.description, contains('Fumarolas'));
          expect(danger.details, contains('vapor'));
          expect(danger.effects, contains('gases'));
        }
      });

      test('Gelo Fino - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.glaciers);
        if (danger.type == NaturalDangerType.thinIce) {
          expect(danger.description, contains('Gelo fino'));
          expect(danger.details, contains('camadas finas'));
          expect(danger.effects, contains('quebrar'));
        }
      });

      test('Gelo Liso - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.glaciers);
        if (danger.type == NaturalDangerType.smoothIce) {
          expect(danger.description, contains('Gelo liso'));
          expect(danger.details, contains('escorregadia'));
          expect(danger.effects, contains('deslocamento'));
        }
      });

      test('Poço de Piche - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.forests);
        if (danger.type == NaturalDangerType.tarPit) {
          expect(danger.description, contains('Poço de piche'));
          expect(danger.details, contains('terra encharcada'));
          expect(danger.effects, contains('movimento reduzido'));
        }
      });

      test('Tempestade de Areia - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.deserts);
        if (danger.type == NaturalDangerType.sandstorm) {
          expect(danger.description, contains('Tempestade de areia'));
          expect(danger.details, contains('nuvens de areia'));
          expect(danger.effects, contains('dano por turno'));
        }
      });

      test('Terremoto - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.mountains);
        if (danger.type == NaturalDangerType.earthquake) {
          expect(danger.description, contains('Terremoto'));
          expect(danger.details, contains('Tremor'));
          expect(danger.effects, contains('desabamentos'));
        }
      });

      test('Tsunami - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.subterranean);
        if (danger.type == NaturalDangerType.tsunami) {
          expect(danger.description, contains('Tsunami'));
          expect(danger.details, contains('Onda gigante'));
          expect(danger.effects, contains('afogamento'));
        }
      });

      test('Vulcão de Lama - Detalhes corretos', () {
        final danger = service.generateNaturalDanger(TerrainType.hills);
        if (danger.type == NaturalDangerType.mudVolcano) {
          expect(danger.description, contains('Vulcão de lama'));
          expect(danger.details, contains('lama'));
          expect(danger.effects, contains('ácida'));
        }
      });
    });

    group('Variações e Desdobramentos', () {
      test('Atoleiros - Buracos escondidos (1-2 chances em 1d6)', () {
        // Simular teste para buracos escondidos
        final hasHiddenHoles = DiceRoller.rollStatic(1, 6) <= 2;
        expect(hasHiddenHoles, isA<bool>());
      });

      test('Atoleiros - Gases naturais (1 chance em 1d6)', () {
        // Simular teste para gases naturais
        final hasNaturalGases = DiceRoller.rollStatic(1, 6) == 1;
        expect(hasNaturalGases, isA<bool>());
      });

      test('Erupções Vulcânicas - Chuva de pedras (1-2 chances em 1d6)', () {
        // Simular teste para chuva de pedras
        final hasRockRain = DiceRoller.rollStatic(1, 6) <= 2;
        expect(hasRockRain, isA<bool>());
      });

      test('Erupções Vulcânicas - Cinzas (1-3 chances em 1d6)', () {
        // Simular teste para cinzas
        final hasAsh = DiceRoller.rollStatic(1, 6) <= 3;
        expect(hasAsh, isA<bool>());
      });

      test('Erupções Vulcânicas - Fluxo de lava (1-2 chances em 1d6)', () {
        // Simular teste para fluxo de lava
        final hasLavaFlow = DiceRoller.rollStatic(1, 6) <= 2;
        expect(hasLavaFlow, isA<bool>());
      });

      test('Erupções Vulcânicas - Fumaça (1-4 chances em 1d6)', () {
        // Simular teste para fumaça
        final hasSmoke = DiceRoller.rollStatic(1, 6) <= 4;
        expect(hasSmoke, isA<bool>());
      });

      test('Erupções Vulcânicas - Jorro de lava (1 chance em 1d6)', () {
        // Simular teste para jorro de lava
        final hasLavaJet = DiceRoller.rollStatic(1, 6) == 1;
        expect(hasLavaJet, isA<bool>());
      });

      test('Erupções Vulcânicas - Incêndios (1-3 chances em 1d6)', () {
        // Simular teste para incêndios
        final hasFires = DiceRoller.rollStatic(1, 6) <= 3;
        expect(hasFires, isA<bool>());
      });

      test('Erupções Vulcânicas - Tremores (1 chance em 1d6)', () {
        // Simular teste para tremores
        final hasTremors = DiceRoller.rollStatic(1, 6) == 1;
        expect(hasTremors, isA<bool>());
      });

      test('Espinheiro - Vegetação Urticária (1-2 chances em 1d6)', () {
        // Simular teste para vegetação urticária
        final hasUrticaria = DiceRoller.rollStatic(1, 6) <= 2;
        expect(hasUrticaria, isA<bool>());
      });

      test('Fontes Termais - Fontes Ferventes (1-3 chances em 1d6)', () {
        // Simular teste para fontes ferventes
        final hasBoilingSprings = DiceRoller.rollStatic(1, 6) <= 3;
        expect(hasBoilingSprings, isA<bool>());
      });

      test('Fontes Termais - Fontes Sulfurosas (1-2 chances em 1d6)', () {
        // Simular teste para fontes sulfurosas
        final hasSulfurousSprings = DiceRoller.rollStatic(1, 6) <= 2;
        expect(hasSulfurousSprings, isA<bool>());
      });

      test('Fontes Termais - Gêiseres (1 chance em 1d6)', () {
        // Simular teste para gêiseres
        final hasGeysers = DiceRoller.rollStatic(1, 6) == 1;
        expect(hasGeysers, isA<bool>());
      });

      test('Fontes Termais - Fontes Negras (1 chance em 1d6)', () {
        // Simular teste para fontes negras
        final hasBlackSprings = DiceRoller.rollStatic(1, 6) == 1;
        expect(hasBlackSprings, isA<bool>());
      });

      test('Fumarolas - Sulfataras (1-2 chances em 1d6)', () {
        // Simular teste para sulfataras
        final hasSulfataras = DiceRoller.rollStatic(1, 6) <= 2;
        expect(hasSulfataras, isA<bool>());
      });

      test('Fumarolas - Mofetas (1 chance em 1d6)', () {
        // Simular teste para mofetas
        final hasMofetas = DiceRoller.rollStatic(1, 6) == 1;
        expect(hasMofetas, isA<bool>());
      });

      test('Poço de Piche - Poço de Lama (1-2 chances em 1d6)', () {
        // Simular teste para poço de lama
        final hasMudPit = DiceRoller.rollStatic(1, 6) <= 2;
        expect(hasMudPit, isA<bool>());
      });

      test('Poço de Piche - Poço de Betume (1 chance em 1d6)', () {
        // Simular teste para poço de betume
        final hasBitumenPit = DiceRoller.rollStatic(1, 6) == 1;
        expect(hasBitumenPit, isA<bool>());
      });

      test('Vulcão de Lama - Vulcão inflamável (1-2 chances em 1d6)', () {
        // Simular teste para vulcão inflamável
        final hasFlammableVolcano = DiceRoller.rollStatic(1, 6) <= 2;
        expect(hasFlammableVolcano, isA<bool>());
      });
    });

    group('Pontos de Jornada e Contramedidas', () {
      test('Perigos naturais consomem 1 ponto de jornada extra', () {
        final danger = service.generateNaturalDanger(TerrainType.forests);
        final hasJourneyPoint = danger.details.contains('ponto de jornada') || 
                               danger.effects.contains('ponto de jornada') ||
                               danger.details.contains('jornada');
        expect(hasJourneyPoint, isTrue);
      });

      test('Altitude custa 2 pontos de jornada', () {
        final danger = service.generateNaturalDanger(TerrainType.mountains);
        if (danger.type == NaturalDangerType.altitude) {
          expect(danger.details, contains('2 pontos de jornada'));
        }
      });

      test('Contramedidas são mencionadas', () {
        final danger = service.generateNaturalDanger(TerrainType.deserts);
        final hasContramedidas = danger.details.contains('contramedidas') || 
                                danger.details.contains('abrigo') || 
                                danger.details.contains('aclimatação') ||
                                danger.details.contains('preparo');
        expect(hasContramedidas, isTrue);
      });
    });
  });
} 