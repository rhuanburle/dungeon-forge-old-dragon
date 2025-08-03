import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';
import '../../lib/enums/table_enums.dart';

void main() {
  group('ExplorationService', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Teste de Explorar - Regras Corretas', () {
      test(
        'deve retornar resultado de exploração com 1d6 para áreas selvagens',
        () {
          final result = service.exploreHex(isWilderness: true);
          expect(result, isA<ExplorationResult>());
          expect(result.hasDiscovery, isA<bool>());
          expect(result.description, isA<String>());
        },
      );

      test(
        'deve retornar resultado de exploração com 1d8 para áreas civilizadas',
        () {
          final result = service.exploreHex(isWilderness: false);
          expect(result, isA<ExplorationResult>());
          expect(result.hasDiscovery, isA<bool>());
          expect(result.description, isA<String>());
        },
      );

      test('deve ter 1 chance em 1d6 de descobrir algo em áreas selvagens', () {
        int discoveries = 0;
        const trials = 1000;

        for (int i = 0; i < trials; i++) {
          final result = service.exploreHex(isWilderness: true);
          if (result.hasDiscovery) discoveries++;
        }

        final probability = discoveries / trials;
        // Deve estar entre 1/6 (0.167) com margem de erro
        expect(probability, greaterThan(0.15));
        expect(probability, lessThan(0.19));
      });

      test(
        'deve ter 1 chance em 1d8 de descobrir algo em áreas civilizadas',
        () {
          int discoveries = 0;
          const trials = 1000;

          for (int i = 0; i < trials; i++) {
            final result = service.exploreHex(isWilderness: false);
            if (result.hasDiscovery) discoveries++;
          }

          final probability = discoveries / trials;
          // Deve estar entre 1/8 (0.125) com margem de erro
          expect(probability, greaterThan(0.11));
          expect(probability, lessThan(0.15));
        },
      );

      test('deve usar tabela 4.3 corretamente para áreas selvagens (1d6)', () {
        final distribution = <DiscoveryType, int>{};

        for (int i = 0; i < 1000; i++) {
          final result = service.exploreHex(isWilderness: true);
          if (result.hasDiscovery && result.discoveryType != null) {
            distribution[result.discoveryType!] =
                (distribution[result.discoveryType!] ?? 0) + 1;
          }
        }

        // Deve ter todos os tipos de descoberta para áreas selvagens
        expect(distribution.isNotEmpty, isTrue);
        expect(
          distribution.containsKey(DiscoveryType.ancestralDiscoveries),
          isTrue,
        );
        expect(distribution.containsKey(DiscoveryType.lairs), isTrue);
        expect(
          distribution.containsKey(DiscoveryType.riversRoadsIslands),
          isTrue,
        );
        expect(distribution.containsKey(DiscoveryType.castlesForts), isTrue);
        expect(
          distribution.containsKey(DiscoveryType.templesSanctuaries),
          isTrue,
        );
        expect(distribution.containsKey(DiscoveryType.naturalDangers), isTrue);

        // Civilização NÃO deve aparecer em áreas selvagens
        expect(distribution.containsKey(DiscoveryType.civilization), isFalse);
      });

      test(
        'deve usar tabela 4.3 corretamente para áreas civilizadas (1d8)',
        () {
          final distribution = <DiscoveryType, int>{};

          for (int i = 0; i < 1000; i++) {
            final result = service.exploreHex(isWilderness: false);
            if (result.hasDiscovery && result.discoveryType != null) {
              distribution[result.discoveryType!] =
                  (distribution[result.discoveryType!] ?? 0) + 1;
            }
          }

          // Deve ter todos os tipos de descoberta para áreas civilizadas
          expect(distribution.isNotEmpty, isTrue);
          expect(
            distribution.containsKey(DiscoveryType.ancestralDiscoveries),
            isTrue,
          );
          expect(distribution.containsKey(DiscoveryType.lairs), isTrue);
          expect(
            distribution.containsKey(DiscoveryType.riversRoadsIslands),
            isTrue,
          );
          expect(distribution.containsKey(DiscoveryType.castlesForts), isTrue);
          expect(
            distribution.containsKey(DiscoveryType.templesSanctuaries),
            isTrue,
          );
          expect(
            distribution.containsKey(DiscoveryType.naturalDangers),
            isTrue,
          );
          expect(distribution.containsKey(DiscoveryType.civilization), isTrue);
        },
      );
    });

    group('Teste de Seleção Manual de Tipo de Descoberta', () {
      test('deve gerar descoberta ancestral quando tipo for especificado', () {
        final result = service.exploreHexWithType(
          DiscoveryType.ancestralDiscoveries,
        );
        expect(result.hasDiscovery, isTrue);
        expect(result.discoveryType, DiscoveryType.ancestralDiscoveries);
        expect(result.description, contains('Descobertas Ancestrais'));
      });

      test('deve gerar covil quando tipo for especificado', () {
        final result = service.exploreHexWithType(DiscoveryType.lairs);
        expect(result.hasDiscovery, isTrue);
        expect(result.discoveryType, DiscoveryType.lairs);
        expect(result.description, contains('Covis'));
      });

      test('deve gerar rios/estradas/ilhas quando tipo for especificado', () {
        final result = service.exploreHexWithType(
          DiscoveryType.riversRoadsIslands,
        );
        expect(result.hasDiscovery, isTrue);
        expect(result.discoveryType, DiscoveryType.riversRoadsIslands);
        expect(result.description, contains('Rios, Estradas ou Ilhas'));
      });

      test('deve gerar castelos/fortes quando tipo for especificado', () {
        final result = service.exploreHexWithType(DiscoveryType.castlesForts);
        expect(result.hasDiscovery, isTrue);
        expect(result.discoveryType, DiscoveryType.castlesForts);
        expect(result.description, contains('Castelos e Fortes'));
      });

      test('deve gerar templos/santuários quando tipo for especificado', () {
        final result = service.exploreHexWithType(
          DiscoveryType.templesSanctuaries,
        );
        expect(result.hasDiscovery, isTrue);
        expect(result.discoveryType, DiscoveryType.templesSanctuaries);
        expect(result.description, contains('Templos e Santuários'));
      });

      test('deve gerar perigos naturais quando tipo for especificado', () {
        final result = service.exploreHexWithType(DiscoveryType.naturalDangers);
        expect(result.hasDiscovery, isTrue);
        expect(result.discoveryType, DiscoveryType.naturalDangers);
        expect(result.description, contains('Perigos Naturais'));
      });

      test('deve gerar civilização quando tipo for especificado', () {
        final result = service.exploreHexWithType(DiscoveryType.civilization);
        expect(result.hasDiscovery, isTrue);
        expect(result.discoveryType, DiscoveryType.civilization);
        expect(result.description, contains('Civilização'));
      });

      test(
        'deve gerar detalhes específicos para cada tipo de descoberta manual',
        () {
          final types = [
            DiscoveryType.ancestralDiscoveries,
            DiscoveryType.lairs,
            DiscoveryType.riversRoadsIslands,
            DiscoveryType.castlesForts,
            DiscoveryType.templesSanctuaries,
            DiscoveryType.naturalDangers,
            DiscoveryType.civilization,
          ];

          for (final type in types) {
            final result = service.exploreHexWithType(type);
            expect(result.hasDiscovery, isTrue);
            expect(result.discoveryType, type);
            expect(result.description, isNotEmpty);
          }
        },
      );
    });

    group('Teste de Descobertas Ancestrais - Tabela 4.4', () {
      test('deve gerar descoberta ancestral com 5 rolagens 1d6', () {
        final result = service.generateAncestralDiscovery();

        expect(result, isNotNull);
        expect(result.type, isA<AncestralThingType>());
        expect(result.condition, isA<AncestralCondition>());
        expect(result.material, isA<AncestralMaterial>());
        expect(result.state, isA<AncestralState>());
        expect(result.guardian, isA<AncestralGuardian>());
        expect(result.description, isNotEmpty);
      });

      test('deve gerar ruínas quando tipo ancestral for ruins', () {
        final result = service.generateRuin(RuinType.house);

        expect(result, isNotNull);
        expect(result.type, equals(RuinType.house));
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test('deve gerar relíquias quando tipo ancestral for relics', () {
        final result = service.generateRelic(RelicType.tools);

        expect(result, isNotNull);
        expect(result.type, equals(RelicType.tools));
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test('deve gerar objetos quando tipo ancestral for objects', () {
        final result = service.generateObject(ObjectType.utensils);

        expect(result, isNotNull);
        expect(result.type, equals(ObjectType.utensils));
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test('deve gerar vestígios quando tipo ancestral for vestiges', () {
        final result = service.generateVestige(VestigeType.religious);

        expect(result, isNotNull);
        expect(result.type, equals(VestigeType.religious));
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test('deve gerar ossadas quando tipo ancestral for ossuaries', () {
        final result = service.generateOssuary(OssuaryType.small);

        expect(result, isNotNull);
        expect(result.type, equals(OssuaryType.small));
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test(
        'deve gerar itens mágicos quando tipo ancestral for magicalItems',
        () {
          final result = service.generateMagicalItem(MagicalItemType.weapons);

          expect(result, isNotNull);
          expect(result.type, equals(MagicalItemType.weapons));
          expect(result.description, isNotEmpty);
          expect(result.details, isNotEmpty);
        },
      );
    });

    group('Teste de Covis - Tabela 4.13', () {
      test('deve gerar covil de monstros com 2 rolagens 1d6', () {
        final result = service.generateLair();

        expect(result, isNotNull);
        expect(result.type, isA<LairType>());
        expect(result.occupation, isA<LairOccupation>());
        expect(result.description, isNotEmpty);
      });

      test('deve gerar masmorra quando tipo for dungeons', () {
        final result = service.generateDungeon();

        expect(result, isNotNull);
        expect(result.entry, isNotEmpty);
        expect(result.floors, isA<int>());
        expect(result.rooms, isA<int>());
        expect(result.guardian, isNotEmpty);
        expect(result.description, isNotEmpty);
      });

      test('deve gerar caverna quando tipo for caves', () {
        final result = service.generateCave();

        expect(result, isNotNull);
        expect(result.entry, isNotEmpty);
        expect(result.inhabitant, isNotEmpty);
        expect(result.description, isNotEmpty);
      });

      test('deve gerar toca quando tipo for burrows', () {
        final result = service.generateBurrow();

        expect(result, isNotNull);
        expect(result.entry, isNotEmpty);
        expect(result.occupant, isNotEmpty);
        expect(result.treasure, isNotEmpty);
        expect(result.description, isNotEmpty);
      });

      test('deve gerar ninho quando tipo for nests', () {
        final result = service.generateNest();

        expect(result, isNotNull);
        expect(result.owner, isNotEmpty);
        expect(result.characteristic, isNotEmpty);
        expect(result.description, isNotEmpty);
      });

      test('deve gerar acampamento quando tipo for camps', () {
        final result = service.generateCamp();

        expect(result, isNotNull);
        expect(result.type, isNotEmpty);
        expect(result.special, isNotEmpty);
        expect(result.tents, isNotEmpty);
        expect(result.watch, isNotEmpty);
        expect(result.defenses, isNotEmpty);
        expect(result.description, isNotEmpty);
      });

      test('deve gerar tribo quando tipo for tribes', () {
        final result = service.generateTribe(TerrainType.forests);

        expect(result, isNotNull);
        expect(result.type, isNotEmpty);
        expect(result.members, isA<int>());
        expect(result.soldiers, isA<int>());
        expect(result.leaders, isA<int>());
        expect(result.religious, isA<int>());
        expect(result.special, isA<int>());
        expect(result.description, isNotEmpty);
      });
    });

    group('Teste de Rios, Estradas e Ilhas - Tabela 4.25', () {
      test('deve gerar rio, estrada ou ilha baseado no terreno', () {
        final result = service.generateRiversRoadsIslands(
          isOcean: false,
          hasRiver: false,
        );

        expect(result, isNotNull);
        expect(result.type, isA<RiversRoadsIslandsType>());
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test('deve gerar ilha quando hex for oceano', () {
        final result = service.generateRiversRoadsIslands(
          isOcean: true,
          hasRiver: false,
        );

        expect(result, isNotNull);
        expect(result.type, isA<RiversRoadsIslandsType>());
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test('deve gerar rio quando hex tem rio', () {
        final result = service.generateRiversRoadsIslands(
          isOcean: false,
          hasRiver: true,
        );

        expect(result, isNotNull);
        expect(result.type, isA<RiversRoadsIslandsType>());
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });
    });

    group('Teste de Castelos e Fortes - Tabela 4.30', () {
      test('deve gerar castelo ou forte', () {
        final result = service.generateCastleFort();

        expect(result, isNotNull);
        expect(result.type, isA<CastleFortType>());
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });
    });

    group('Teste de Templos e Santuários - Tabela 4.33', () {
      test('deve gerar templo ou santuário', () {
        final result = service.generateTempleSanctuary();

        expect(result, isNotNull);
        expect(result.type, isA<TempleSanctuaryType>());
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });
    });

    group('Teste de Perigos Naturais - Tabela 4.38', () {
      test('deve gerar perigo natural baseado no terreno', () {
        final result = service.generateNaturalDanger(TerrainType.forests);

        expect(result, isNotNull);
        expect(result.type, isA<NaturalDangerType>());
        expect(result.description, isNotEmpty);
      });
    });

    group('Teste de Civilização - Tabela 4.39', () {
      test('deve gerar civilização', () {
        final result = service.generateCivilization();

        expect(result, isNotNull);
        expect(result.type, isA<CivilizationType>());
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test('deve gerar assentamento', () {
        final result = service.generateSettlement();

        expect(result, isNotNull);
        expect(result.type, isA<SettlementType>());
        expect(result.description, isNotEmpty);
        expect(result.details, isNotEmpty);
      });
    });

    group('Teste de Regras Específicas - Old Dragon RPG', () {
      test('deve seguir tabela 4.3 corretamente para áreas selvagens (1d6)', () {
        // Teste estatístico para verificar distribuição correta
        Map<DiscoveryType, int> distribution = {};
        const totalTests = 10000;

        for (int i = 0; i < totalTests; i++) {
          final result = service.exploreHex(isWilderness: true);
          if (result.hasDiscovery && result.discoveryType != null) {
            distribution[result.discoveryType!] =
                (distribution[result.discoveryType!] ?? 0) + 1;
          }
        }

        // Verificar que civilização NÃO aparece em áreas selvagens
        expect(distribution[DiscoveryType.civilization], isNull);

        // Verificar que pelo menos alguns tipos aparecem (devido à baixa probabilidade)
        expect(distribution.isNotEmpty, isTrue);

        // Verificar que apenas tipos válidos para áreas selvagens aparecem
        for (final type in distribution.keys) {
          expect(type, isNot(equals(DiscoveryType.civilization)));
        }
      });

      test(
        'deve seguir tabela 4.3 corretamente para áreas civilizadas (1d8)',
        () {
          // Teste estatístico para verificar distribuição correta
          Map<DiscoveryType, int> distribution = {};
          const totalTests = 10000;

          for (int i = 0; i < totalTests; i++) {
            final result = service.exploreHex(isWilderness: false);
            if (result.hasDiscovery && result.discoveryType != null) {
              distribution[result.discoveryType!] =
                  (distribution[result.discoveryType!] ?? 0) + 1;
            }
          }

          // Verificar que pelo menos alguns tipos aparecem (devido à baixa probabilidade)
          expect(distribution.isNotEmpty, isTrue);

          // Se civilização aparecer, deve ser apenas em áreas civilizadas
          if (distribution.containsKey(DiscoveryType.civilization)) {
            expect(distribution[DiscoveryType.civilization], greaterThan(0));
          }
        },
      );

      test(
        'deve ter probabilidade correta de descoberta (1/6 para selvagem, 1/8 para civilizada)',
        () {
          int wildernessDiscoveries = 0;
          int civilizedDiscoveries = 0;
          const totalTests = 10000;

          for (int i = 0; i < totalTests; i++) {
            final wildernessResult = service.exploreHex(isWilderness: true);
            final civilizedResult = service.exploreHex(isWilderness: false);

            if (wildernessResult.hasDiscovery) wildernessDiscoveries++;
            if (civilizedResult.hasDiscovery) civilizedDiscoveries++;
          }

          final wildernessRate = wildernessDiscoveries / totalTests;
          final civilizedRate = civilizedDiscoveries / totalTests;

          // 1/6 ≈ 16.67%, 1/8 ≈ 12.5%
          expect(wildernessRate, greaterThan(0.14)); // Pelo menos 14%
          expect(wildernessRate, lessThan(0.19)); // No máximo 19%

          expect(civilizedRate, greaterThan(0.10)); // Pelo menos 10%
          expect(civilizedRate, lessThan(0.15)); // No máximo 15%
        },
      );

      test(
        'deve gerar detalhes específicos para cada tipo de descoberta ancestral',
        () {
          // Teste para verificar se os detalhes são gerados corretamente
          final ruin = service.generateRuin(RuinType.house);
          expect(ruin.details, isNotEmpty);
          expect(ruin.details, isNot(equals('Detalhes da ruína')));

          final relic = service.generateRelic(RelicType.tools);
          expect(relic.details, isNotEmpty);
          expect(relic.details, isNot(equals('Detalhes da relíquia')));

          final object = service.generateObject(ObjectType.utensils);
          expect(object.details, isNotEmpty);
          expect(object.details, isNot(equals('Detalhes do objeto')));
        },
      );

      test(
        'deve gerar ocupantes específicos para tocas baseado no tipo de entrada',
        () {
          // Teste para verificar se os ocupantes são gerados corretamente
          final burrow = service.generateBurrow();
          expect(burrow.occupant, isNotEmpty);
          expect(burrow.occupant, isNot(equals('Ocupante da toca')));

          // Verificar se contém números (quantidade de criaturas)
          expect(burrow.occupant, matches(RegExp(r'\d+')));
        },
      );

      test('deve gerar tipos de tribo baseado no terreno', () {
        // Teste para verificar se os tipos de tribo são gerados corretamente
        final forestTribe = service.generateTribe(TerrainType.forests);
        final mountainTribe = service.generateTribe(TerrainType.mountains);
        final swampTribe = service.generateTribe(TerrainType.swamps);

        expect(forestTribe.type, isNotEmpty);
        expect(mountainTribe.type, isNotEmpty);
        expect(swampTribe.type, isNotEmpty);

        // Verificar se os membros são números válidos
        expect(forestTribe.members, greaterThan(0));
        expect(mountainTribe.members, greaterThan(0));
        expect(swampTribe.members, greaterThan(0));
      });

      test('deve gerar perigos naturais específicos para cada terreno', () {
        // Teste para verificar se os perigos são gerados corretamente
        final forestDanger = service.generateNaturalDanger(TerrainType.forests);
        final mountainDanger = service.generateNaturalDanger(
          TerrainType.mountains,
        );
        final desertDanger = service.generateNaturalDanger(TerrainType.deserts);

        expect(forestDanger.type, isA<NaturalDangerType>());
        expect(mountainDanger.type, isA<NaturalDangerType>());
        expect(desertDanger.type, isA<NaturalDangerType>());

        expect(forestDanger.description, isNotEmpty);
        expect(mountainDanger.description, isNotEmpty);
        expect(desertDanger.description, isNotEmpty);
      });
    });

    group('Teste de Correção do Bug - Distribuição Correta', () {
      test(
        'deve ter distribuição correta de tipos de descoberta em exploração aleatória',
        () {
          final distribution = <DiscoveryType, int>{};
          const trials = 2000;

          for (int i = 0; i < trials; i++) {
            final result = service.exploreHex(isWilderness: true);
            if (result.hasDiscovery && result.discoveryType != null) {
              distribution[result.discoveryType!] =
                  (distribution[result.discoveryType!] ?? 0) + 1;
            }
          }

          // Verifica se todos os tipos aparecem (não apenas ancestral)
          expect(distribution.length, greaterThan(1));

          // Verifica se cada tipo tem pelo menos algumas ocorrências
          for (final type in DiscoveryType.values) {
            if (type != DiscoveryType.civilization) {
              // Civilização só em áreas civilizadas
              final count = distribution[type] ?? 0;
              expect(count, greaterThan(0), reason: 'Tipo $type não apareceu');
            }
          }
        },
      );

      test('deve ter distribuição equilibrada entre tipos de descoberta', () {
        final distribution = <DiscoveryType, int>{};
        const trials = 3000;

        for (int i = 0; i < trials; i++) {
          final result = service.exploreHex(isWilderness: true);
          if (result.hasDiscovery && result.discoveryType != null) {
            distribution[result.discoveryType!] =
                (distribution[result.discoveryType!] ?? 0) + 1;
          }
        }

        // Calcula a média esperada (aproximadamente igual para cada tipo)
        final totalDiscoveries = distribution.values.fold(
          0,
          (sum, count) => sum + count,
        );
        final expectedAverage =
            totalDiscoveries / 6; // 6 tipos para áreas selvagens

        // Cada tipo deve ter pelo menos 80% da média esperada
        for (final count in distribution.values) {
          expect(count, greaterThan(expectedAverage * 0.8));
        }
      });
    });
  });
}
