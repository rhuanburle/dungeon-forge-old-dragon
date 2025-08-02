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
        expect(DungeonType.abandonedLair.description, equals('Covil Abandonado'));
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
        expect(DungeonStatus.cursed.description, equals('Amaldiçoado'));
        expect(DungeonStatus.extinct.description, equals('Extinto'));
        expect(DungeonStatus.ancestral.description, equals('Ancestral'));
        expect(DungeonStatus.disappeared.description, equals('Desaparecido'));
        expect(DungeonStatus.lost.description, equals('Perdido'));
        expect(DungeonStatus.inAnotherLocation.description, equals('Em Outro Local'));
      });

      test('should have all expected values', () {
        expect(DungeonStatus.values.length, equals(6));
      });
    });

    group('DungeonObjective', () {
      test('should have correct descriptions', () {
        expect(DungeonObjective.unknown.description, equals('Desconhecido'));
        expect(DungeonObjective.defense.description, equals('Defesa'));
        expect(DungeonObjective.attack.description, equals('Ataque'));
        expect(DungeonObjective.refuge.description, equals('Refúgio'));
        expect(DungeonObjective.observation.description, equals('Observação'));
        expect(DungeonObjective.storage.description, equals('Armazenamento'));
      });

      test('should have all expected values', () {
        expect(DungeonObjective.values.length, equals(6));
      });
    });

    group('DungeonTarget', () {
      test('should have correct descriptions', () {
        expect(DungeonTarget.unknown.description, equals('Desconhecido'));
        expect(DungeonTarget.village.description, equals('Aldeia'));
        expect(DungeonTarget.city.description, equals('Cidade'));
        expect(DungeonTarget.road.description, equals('Estrada'));
        expect(DungeonTarget.forest.description, equals('Floresta'));
        expect(DungeonTarget.mountain.description, equals('Montanha'));
      });

      test('should have all expected values', () {
        expect(DungeonTarget.values.length, equals(6));
      });
    });

    group('DungeonTargetStatus', () {
      test('should have correct descriptions', () {
        expect(DungeonTargetStatus.unknown.description, equals('Desconhecido'));
        expect(DungeonTargetStatus.destroyed.description, equals('Destruído'));
        expect(DungeonTargetStatus.abandoned.description, equals('Abandonado'));
        expect(DungeonTargetStatus.occupied.description, equals('Ocupado'));
        expect(DungeonTargetStatus.underConstruction.description, equals('Em Construção'));
        expect(DungeonTargetStatus.flourishing.description, equals('Próspero'));
      });

      test('should have all expected values', () {
        expect(DungeonTargetStatus.values.length, equals(6));
      });
    });

    group('DungeonOccupant', () {
      test('should have correct descriptions', () {
        expect(DungeonOccupant.trolls.description, equals('Trolls'));
        expect(DungeonOccupant.orcs.description, equals('Orcs'));
        expect(DungeonOccupant.skeletons.description, equals('Esqueletos'));
        expect(DungeonOccupant.goblins.description, equals('Goblins'));
        expect(DungeonOccupant.bugbears.description, equals('Bugbears'));
        expect(DungeonOccupant.ogres.description, equals('Ogres'));
        expect(DungeonOccupant.kobolds.description, equals('Kobolds'));
        expect(DungeonOccupant.grayOoze.description, equals('Lodo Cinza'));
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
        expect(RumorSubject.decapitatedOccupant.description, equals('Ocupante Decapitado'));
        expect(RumorSubject.drunkPeasant.description, equals('Camponês Bêbado'));
        expect(RumorSubject.primaryOccupant.description, equals('Ocupante Primário'));
        expect(RumorSubject.richForeigner.description, equals('Estrangeiro Rico'));
        expect(RumorSubject.blindMystic.description, equals('Místico Cego'));
        expect(RumorSubject.leader.description, equals('Líder'));
      });

      test('should have all expected values', () {
        expect(RumorSubject.values.length, equals(6));
      });
    });

    group('RumorAction', () {
      test('should have correct descriptions', () {
        expect(RumorAction.seenNear.description, equals('Visto Perto'));
        expect(RumorAction.capturedIn.description, equals('Capturado Em'));
        expect(RumorAction.leftTrailsIn.description, equals('Deixou Rastros Em'));
        expect(RumorAction.soughtPriestIn.description, equals('Procurou Sacerdote Em'));
        expect(RumorAction.killedByWerewolfIn.description, equals('Morto Por Lobisomem Em'));
        expect(RumorAction.cursed.description, equals('Amaldiçoado'));
      });

      test('should have all expected values', () {
        expect(RumorAction.values.length, equals(6));
      });
    });

    group('RumorLocation', () {
      test('should have correct descriptions', () {
        expect(RumorLocation.autumnReligiousFestival.description, equals('Festival Religioso de Outono'));
        expect(RumorLocation.villageLastYearDuringEclipse.description, equals('Aldeia Ano Passado Durante Eclipse'));
        expect(RumorLocation.farmWhenSheepDisappeared.description, equals('Fazenda Quando Ovelhas Desapareceram'));
        expect(RumorLocation.nearbyVillage.description, equals('Aldeia Próxima'));
        expect(RumorLocation.springTradeCaravan.description, equals('Caravana Comercial da Primavera'));
        expect(RumorLocation.winterBlizzard3YearsAgo.description, equals('Nevasca de Inverno Há 3 Anos'));
      });

      test('should have all expected values', () {
        expect(RumorLocation.values.length, equals(6));
      });
    });
  });
}
