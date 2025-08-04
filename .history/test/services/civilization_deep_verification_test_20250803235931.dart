import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Deep Verification of Civilization Tables', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Tabela 4.39 - Civilização', () {
      test('Tipo, população e cálculos aleatórios', () {
        final tiposEsperados = [
          CivilizationType.settlement,
          CivilizationType.village,
          CivilizationType.town,
          CivilizationType.city,
          CivilizationType.metropolis,
        ];
        final popRegex = RegExp(r'(\d+[.,]?\d*|\d+d\d+|\d+\+\d+d\d+|\d+ x \d+)');
        final results = <String, int>{};
        for (int i = 0; i < 100; i++) {
          final result = service.generateCivilization();
          expect(result, isNotNull);
          expect(tiposEsperados.contains(result.type), isTrue);
          expect(result.description, isNotEmpty);
          expect(result.details, isNotEmpty);
          expect(result.population, isNotEmpty);
          expect(result.government, isNotEmpty);
          // População deve conter número ou expressão de dado
          expect(popRegex.hasMatch(result.population), isTrue);
          results[result.type.toString()] = (results[result.type.toString()] ?? 0) + 1;
        }
        // Todos os tipos devem aparecer
        expect(results.length, equals(tiposEsperados.length));
      });
    });

    group('Tabela 4.40 - Assentamentos', () {
      test('Tipos e subtipos de assentamento', () {
        final tiposEsperados = [
          SettlementType.extractionMines,
          SettlementType.commercialOutpost,
          SettlementType.ruralProperty,
          SettlementType.educationalInstitutions,
          SettlementType.tavernAndInn,
          SettlementType.settlement,
        ];
        final results = <String, int>{};
        for (int i = 0; i < 100; i++) {
          final result = service.generateSettlement();
          expect(result, isNotNull);
          expect(tiposEsperados.contains(result.type), isTrue);
          expect(result.description, isNotEmpty);
          expect(result.details, isNotEmpty);
          results[result.type.toString()] = (results[result.type.toString()] ?? 0) + 1;
        }
        // Todos os tipos devem aparecer
        expect(results.length, equals(tiposEsperados.length));
      });
    });

    group('Tabela 4.41 - Detalhamento de Povoados', () {
      test('Detalhes completos de povoados', () {
        final niveisTecnologicos = [
          'Tribal/Selvagem',
          'Era do bronze',
          'Medieval',
          'Renascimento',
        ];
        final aparencias = [
          'Cabanas de palha',
          'Cabanas de barro',
          'Casas rústicas de madeira',
          'Casas rústicas de pedra',
          'Casas de madeira e pedra',
        ];
        final alinhamentos = ['Ordeiro', 'Neutro', 'Caótico'];
        final governantes = [
          'Nobre local',
          'Político plebeu local',
          'Ladrão',
          'Guerreiro',
          'Clérigo',
          'Mago',
        ];
        final racas = [
          'Humano',
          'Anões',
          'Elfos',
          'Halflings',
          'Gnomos',
          'Multirracial',
        ];
        for (int i = 0; i < 50; i++) {
          final result = service.generateDetailedCivilization();
          expect(result, isNotNull);
          expect(result.description, contains('Tipo:'));
          expect(result.details, contains('Nível Tecnológico'));
          expect(
            niveisTecnologicos.any((nivel) => result.details.contains(nivel)),
            isTrue,
          );
          expect(
            aparencias.any((ap) => result.details.contains(ap)),
            isTrue,
          );
          expect(
            alinhamentos.any((al) => result.details.contains(al)),
            isTrue,
          );
          expect(
            governantes.any((gov) => result.details.contains(gov)),
            isTrue,
          );
          expect(
            racas.any((r) => result.details.contains(r)),
            isTrue,
          );
        }
      });
    });

    group('Tabela 4.42 - Atitude e Temas', () {
      test('Atitude e temas de povoados', () {
        final atitudes = [
          'Extrema curiosidade',
          'Hospitalidade sincera',
          'Ansiedade para fazer negócios',
          'Indiferença total',
          'Misteriosa e estranha',
          'Hostilidade aberta e total',
        ];
        final temasPovoados = [
          'Pacata, rural e isolada',
          'Entreposto comercial rural',
          'Amaldiçoada ou chantageada por inimigos poderosos',
          'Erguida em torno da torre de um mago',
          'Em reconstrução pós-incêndio',
          'Sofrendo ataques de monstros',
        ];
        final temasCidades = [
          'Sede do governo central',
          'Cidade livre com forte apelo comercial',
          'Tomada pelas guildas de criminosos',
          'Possui o templo principal de uma região',
          'Em reconstrução pós-guerra',
          'Cercada por inimigos',
        ];
        for (int i = 0; i < 50; i++) {
          final result = service.generateDetailedCivilization();
          expect(result, isNotNull);
          expect(
            atitudes.any((a) => result.details.contains(a)),
            isTrue,
          );
          expect(
            temasPovoados.any((t) => result.details.contains(t)) ||
                temasCidades.any((t) => result.details.contains(t)),
            isTrue,
          );
        }
      });
    });
  });
}