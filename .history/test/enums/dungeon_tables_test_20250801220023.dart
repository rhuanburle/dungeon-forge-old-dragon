// test/enums/dungeon_tables_test.dart

import 'package:test/test.dart';
import '../../lib/enums/table_enums.dart';

void main() {
  group('Dungeon Enums', () {
    group('DungeonType', () {
      test('should have correct descriptions', () {
        expect(DungeonType.lostConstruction.description, equals('Construção Perdida'));
        expect(DungeonType.artificialLabyrinth.description, equals('Labirinto Artificial'));
        expect(DungeonType.naturalCaves.description, equals('Cavernas Naturais'));
        expect(DungeonType.abandonedLair.description, equals('Covil Desabitado'));
        expect(DungeonType.abandonedFortress.description, equals('Fortaleza Abandonada'));
        expect(DungeonType.deactivatedMine.description, equals('Mina Desativada'));
      });

      test('should have all expected values', () {
        expect(DungeonType.values.length, equals(6));
      });
    });

    group('DungeonBuilder', () {
      test('should have correct descriptions', () {
        expect(DungeonBuilder.unknown.description, equals('Desconhecido'));
        expect(DungeonBuilder.cultists.description, equals('Cultistas'));
        expect(DungeonBuilder.ancestralCivilization.description, equals('Civilização Ancestral'));
        expect(DungeonBuilder.dwarves.description, equals('Anões'));
        expect(DungeonBuilder.mages.description, equals('Magos'));
        expect(DungeonBuilder.giants.description, equals('Gigantes'));
      });

      test('should have all expected values', () {
        expect(DungeonBuilder.values.length, equals(6));
      });
    });

    group('DungeonStatus', () {
      test('should have correct descriptions', () {
        expect(DungeonStatus.cursed.description, equals('Amaldiçoados'));
        expect(DungeonStatus.extinct.description, equals('Extintos'));
        expect(DungeonStatus.ancestral.description, equals('Ancestrais'));
        expect(DungeonStatus.disappeared.description, equals('Desaparecidos'));
        expect(DungeonStatus.lost.description, equals('Perdidos'));
        expect(DungeonStatus.inAnotherLocation.description, equals('em outro local'));
      });

      test('should have all expected values', () {
        expect(DungeonStatus.values.length, equals(6));
      });
    });

    group('DungeonObjective', () {
      test('should have correct descriptions', () {
        expect(DungeonObjective.defend.description, equals('Defender'));
        expect(DungeonObjective.hide.description, equals('Esconder'));
        expect(DungeonObjective.protect.description, equals('Proteger'));
        expect(DungeonObjective.guard.description, equals('Guardar'));
        expect(DungeonObjective.watch.description, equals('Vigiar'));
        expect(DungeonObjective.isolate.description, equals('Isolar'));
      });

      test('should have all expected values', () {
        expect(DungeonObjective.values.length, equals(6));
      });
    });

    group('DungeonTarget', () {
      test('should have correct descriptions', () {
        expect(DungeonTarget.artifact.description, equals('artefato'));
        expect(DungeonTarget.book.description, equals('livro'));
        expect(DungeonTarget.sword.description, equals('espada'));
        expect(DungeonTarget.gem.description, equals('gema'));
        expect(DungeonTarget.helmet.description, equals('elmo'));
        expect(DungeonTarget.treasure.description, equals('tesouro'));
      });

      test('should have all expected values', () {
        expect(DungeonTarget.values.length, equals(6));
      });
    });

    group('DungeonTargetStatus', () {
      test('should have correct descriptions', () {
        expect(DungeonTargetStatus.beingSought.description, equals('sendo procurado'));
        expect(DungeonTargetStatus.destroyed.description, equals('destruído'));
        expect(DungeonTargetStatus.disappeared.description, equals('desaparecido'));
        expect(DungeonTargetStatus.stolen.description, equals('roubado'));
        expect(DungeonTargetStatus.intact.description, equals('intacto'));
        expect(DungeonTargetStatus.buried.description, equals('soterrado'));
      });

      test('should have all expected values', () {
        expect(DungeonTargetStatus.values.length, equals(6));
      });
    });

    group('DungeonLocation', () {
      test('should have correct descriptions', () {
        expect(DungeonLocation.scorchingDesert.description, equals('Deserto Escaldante'));
        expect(DungeonLocation.underCity.description, equals('Sob uma Cidade'));
        expect(DungeonLocation.frozenMountain.description, equals('Montanha Gelada'));
        expect(DungeonLocation.wildForest.description, equals('Floresta Selvagem'));
        expect(DungeonLocation.fetidSwamp.description, equals('Pântano Fétido'));
        expect(DungeonLocation.isolatedIsland.description, equals('Ilha Isolada'));
      });

      test('should have all expected values', () {
        expect(DungeonLocation.values.length, equals(6));
      });
    });

    group('DungeonEntry', () {
      test('should have correct descriptions', () {
        expect(DungeonEntry.behindWaterfall.description, equals('Atrás de uma Cachoeira'));
        expect(DungeonEntry.secretTunnel.description, equals('Túnel Secreto'));
        expect(DungeonEntry.smallCave.description, equals('Pequena Gruta'));
        expect(DungeonEntry.rockFissure.description, equals('Fissura numa Rocha'));
        expect(DungeonEntry.monsterLair.description, equals('Covil de um Monstro'));
        expect(DungeonEntry.volcanoMouth.description, equals('Boca de um Vulcão'));
      });

      test('should have all expected values', () {
        expect(DungeonEntry.values.length, equals(6));
      });
    });

    group('DungeonSize', () {
      test('should have correct descriptions', () {
        expect(DungeonSize.small.description, equals('Pequena'));
        expect(DungeonSize.medium.description, equals('Média'));
        expect(DungeonSize.large.description, equals('Grande'));
      });

      test('should have all expected values', () {
        expect(DungeonSize.values.length, equals(3));
      });
    });

    group('DungeonOccupant', () {
      test('should have correct descriptions', () {
        expect(DungeonOccupant.trolls.description, equals('Trolls'));
        expect(DungeonOccupant.orcs.description, equals('Orcs'));
        expect(DungeonOccupant.skeletons.description, equals('Esqueletos'));
        expect(DungeonOccupant.goblins.description, equals('Goblins'));
        expect(DungeonOccupant.bugbears.description, equals('Bugbears'));
        expect(DungeonOccupant.ogres.description, equals('Ogros'));
        expect(DungeonOccupant.kobolds.description, equals('Kobolds'));
        expect(DungeonOccupant.grayOoze.description, equals('Limo Cinzento'));
        expect(DungeonOccupant.zombies.description, equals('Zumbis'));
        expect(DungeonOccupant.giantRats.description, equals('Ratos Gigantes'));
        expect(DungeonOccupant.pygmyFungi.description, equals('Fungos Pigmeus'));
        expect(DungeonOccupant.lizardMen.description, equals('Homens-Lagarto'));
        expect(DungeonOccupant.hobgoblin.description, equals('Hobgoblin'));
        expect(DungeonOccupant.gelatinousCube.description, equals('Cubo Gelatinoso'));
        expect(DungeonOccupant.cultist.description, equals('Cultista'));
        expect(DungeonOccupant.shadow.description, equals('Sombra'));
        expect(DungeonOccupant.necromancer.description, equals('Necromante'));
        expect(DungeonOccupant.dragon.description, equals('Dragão'));
      });

      test('should have all expected values', () {
        expect(DungeonOccupant.values.length, equals(18));
      });
    });

    group('RumorSubject', () {
      test('should have correct descriptions', () {
        expect(RumorSubject.decapitatedOccupant.description, equals('Um/uma [coluna 11] decapitada/o'));
        expect(RumorSubject.drunkPeasant.description, equals('Um camponês bêbado'));
        expect(RumorSubject.primaryOccupant.description, equals('Um/uma [coluna 10]'));
        expect(RumorSubject.richForeigner.description, equals('Um estrangeiro muito rico'));
        expect(RumorSubject.blindMystic.description, equals('Um místico cego'));
        expect(RumorSubject.leader.description, equals('[coluna 12]'));
      });

      test('should have all expected values', () {
        expect(RumorSubject.values.length, equals(6));
      });
    });

    group('RumorAction', () {
      test('should have correct descriptions', () {
        expect(RumorAction.seenNear.description, equals('foi visto próximo a'));
        expect(RumorAction.capturedIn.description, equals('foi capturado na/no'));
        expect(RumorAction.leftTrailsIn.description, equals('deixou rastros na/no'));
        expect(RumorAction.soughtPriestIn.description, equals('procurou o sacerdote na/no'));
        expect(RumorAction.killedByWerewolfIn.description, equals('foi morto por um lobisomem na/no'));
        expect(RumorAction.cursed.description, equals('amaldiçoou a/o'));
      });

      test('should have all expected values', () {
        expect(RumorAction.values.length, equals(6));
      });
    });

    group('RumorLocation', () {
      test('should have correct descriptions', () {
        expect(RumorLocation.autumnReligiousFestival.description, equals('festival religioso do outono'));
        expect(RumorLocation.villageLastYearDuringEclipse.description, equals('vila no ano passado durante o eclipse'));
        expect(RumorLocation.farmWhenSheepDisappeared.description, equals('fazenda quando uma ovelha sumiu'));
        expect(RumorLocation.nearbyVillage.description, equals('aldeia vizinha próxima'));
        expect(RumorLocation.springTradeCaravan.description, equals('caravana de comércio da primavera'));
        expect(RumorLocation.winterBlizzard3YearsAgo.description, equals('nevasca do inverno há 3 anos'));
      });

      test('should have all expected values', () {
        expect(RumorLocation.values.length, equals(6));
      });
    });
  });
}
