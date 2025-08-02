// test/enums/room_tables_test.dart

import 'package:test/test.dart';
import '../../lib/enums/table_enums.dart';

void main() {
  group('Room Enums', () {
    group('RoomType', () {
      test('should have correct descriptions', () {
        expect(RoomType.specialRoom.description, equals('Sala Especial'));
        expect(RoomType.trap.description, equals('Armadilha'));
        expect(RoomType.commonRoom.description, equals('Sala Comum'));
        expect(RoomType.monster.description, equals('Monstro'));
        expect(RoomType.specialTrap.description, equals('Armadilha Especial'));
      });

      test('should have all expected values', () {
        expect(RoomType.values.length, equals(5));
      });
    });

    group('AirCurrent', () {
      test('should have correct descriptions', () {
        expect(AirCurrent.hotDraft.description, equals('Corrente Quente'));
        expect(AirCurrent.lightHotBreeze.description, equals('Brisa Quente Leve'));
        expect(AirCurrent.noAirCurrent.description, equals('Sem Corrente de Ar'));
        expect(AirCurrent.lightColdBreeze.description, equals('Brisa Fria Leve'));
        expect(AirCurrent.coldDraft.description, equals('Corrente Fria'));
        expect(AirCurrent.strongIcyWind.description, equals('Vento Gelado Forte'));
      });

      test('should have all expected values', () {
        expect(AirCurrent.values.length, equals(6));
      });
    });

    group('Smell', () {
      test('should have correct descriptions', () {
        expect(Smell.rottenMeat.description, equals('Carne Podre'));
        expect(Smell.humidityMold.description, equals('Umidade e Mofo'));
        expect(Smell.noSpecialSmell.description, equals('Sem Cheiro Especial'));
        expect(Smell.earthSmell.description, equals('Cheiro de Terra'));
        expect(Smell.smokeSmell.description, equals('Cheiro de Fumaça'));
        expect(Smell.fecesUrine.description, equals('Fezes e Urina'));
      });

      test('should have all expected values', () {
        expect(Smell.values.length, equals(6));
      });
    });

    group('Sound', () {
      test('should have correct descriptions', () {
        expect(Sound.metallicScratch.description, equals('Arranhão Metálico'));
        expect(Sound.rhythmicDrip.description, equals('Gotejamento Rítmico'));
        expect(Sound.noSpecialSound.description, equals('Sem Som Especial'));
        expect(Sound.windBlowing.description, equals('Vento Soprando'));
        expect(Sound.distantFootsteps.description, equals('Passos Distantes'));
        expect(Sound.whispersMoans.description, equals('Sussurros e Gemidos'));
      });

      test('should have all expected values', () {
        expect(Sound.values.length, equals(6));
      });
    });

    group('FoundItem', () {
      test('should have correct descriptions', () {
        expect(FoundItem.completelyEmpty.description, equals('Completamente Vazio'));
        expect(FoundItem.dustDirtWebs.description, equals('Poeira, Sujeira e Teias'));
        expect(FoundItem.oldFurniture.description, equals('Móveis Velhos'));
        expect(FoundItem.specialItems.description, equals('Itens Especiais'));
        expect(FoundItem.foodRemainsGarbage.description, equals('Restos de Comida e Lixo'));
        expect(FoundItem.dirtyFetidClothes.description, equals('Roupas Sujas e Fétidas'));
      });

      test('should have all expected values', () {
        expect(FoundItem.values.length, equals(6));
      });
    });

    group('SpecialItem', () {
      test('should have correct descriptions', () {
        expect(SpecialItem.monsterCarcasses.description, equals('Carcaças de Monstros'));
        expect(SpecialItem.oldTornPapers.description, equals('Papéis Velhos e Rasgados'));
        expect(SpecialItem.piledBones.description, equals('Ossos Empilhados'));
        expect(SpecialItem.dirtyFabricRemains.description, equals('Restos de Tecido Sujo'));
        expect(SpecialItem.emptyBoxesBagsChests.description, equals('Caixas, Sacos e Baús Vazios'));
        expect(SpecialItem.fullBoxesBagsChests.description, equals('Caixas, Sacos e Baús Cheios'));
      });

      test('should have all expected values', () {
        expect(SpecialItem.values.length, equals(6));
      });
    });

    group('CommonRoom', () {
      test('should have correct descriptions', () {
        expect(CommonRoom.dormitory.description, equals('Dormitório'));
        expect(CommonRoom.generalDeposit.description, equals('Depósito Geral'));
        expect(CommonRoom.special.description, equals('Especial'));
        expect(CommonRoom.completelyEmpty.description, equals('Completamente Vazio'));
        expect(CommonRoom.foodPantry.description, equals('Despensa de Comida'));
        expect(CommonRoom.prisonCell.description, equals('Cela de Prisão'));
      });

      test('should have all expected values', () {
        expect(CommonRoom.values.length, equals(6));
      });
    });

    group('SpecialRoom', () {
      test('should have correct descriptions', () {
        expect(SpecialRoom.trainingRoom.description, equals('Sala de Treinamento'));
        expect(SpecialRoom.diningRoom.description, equals('Sala de Jantar'));
        expect(SpecialRoom.completelyEmpty.description, equals('Completamente Vazio'));
        expect(SpecialRoom.special2.description, equals('Especial 2'));
        expect(SpecialRoom.religiousAltar.description, equals('Altar Religioso'));
        expect(SpecialRoom.abandonedDen.description, equals('Covil Abandonado'));
      });

      test('should have all expected values', () {
        expect(SpecialRoom.values.length, equals(6));
      });
    });

    group('SpecialRoom2', () {
      test('should have correct descriptions', () {
        expect(SpecialRoom2.tortureChamber.description, equals('Câmara de Tortura'));
        expect(SpecialRoom2.ritualChamber.description, equals('Câmara de Ritual'));
        expect(SpecialRoom2.magicalLaboratory.description, equals('Laboratório Mágico'));
        expect(SpecialRoom2.library.description, equals('Biblioteca'));
        expect(SpecialRoom2.crypt.description, equals('Cripta'));
        expect(SpecialRoom2.arsenal.description, equals('Arsenal'));
      });

      test('should have all expected values', () {
        expect(SpecialRoom2.values.length, equals(6));
      });
    });

    group('Monster', () {
      test('should have correct descriptions', () {
        expect(Monster.newMonsterPlusOccupantI.description, equals('Novo Monstro + Ocupante I'));
        expect(Monster.occupantIPlusOccupantII.description, equals('Ocupante I + Ocupante II'));
        expect(Monster.occupantI.description, equals('Ocupante I'));
        expect(Monster.occupantII.description, equals('Ocupante II'));
        expect(Monster.newMonster.description, equals('Novo Monstro'));
        expect(Monster.newMonsterPlusOccupantII.description, equals('Novo Monstro + Ocupante II'));
      });

      test('should have all expected values', () {
        expect(Monster.values.length, equals(6));
      });
    });

    group('Trap', () {
      test('should have correct descriptions', () {
        expect(Trap.hiddenGuillotine.description, equals('Guilhotina Oculta'));
        expect(Trap.pit.description, equals('Poço'));
        expect(Trap.poisonedDarts.description, equals('Dardos Envenenados'));
        expect(Trap.specialTrap.description, equals('Armadilha Especial'));
        expect(Trap.fallingBlock.description, equals('Bloco Caindo'));
        expect(Trap.acidSpray.description, equals('Spray de Ácido'));
      });

      test('should have all expected values', () {
        expect(Trap.values.length, equals(6));
      });
    });

    group('SpecialTrap', () {
      test('should have correct descriptions', () {
        expect(SpecialTrap.waterWell.description, equals('Poço de Água'));
        expect(SpecialTrap.collapse.description, equals('Desabamento'));
        expect(SpecialTrap.retractableCeiling.description, equals('Teto Retrátil'));
        expect(SpecialTrap.secretDoor.description, equals('Porta Secreta'));
        expect(SpecialTrap.alarm.description, equals('Alarme'));
        expect(SpecialTrap.dimensionalPortal.description, equals('Portal Dimensional'));
      });

      test('should have all expected values', () {
        expect(SpecialTrap.values.length, equals(6));
      });
    });

    group('Treasure', () {
      test('should have correct descriptions', () {
        expect(Treasure.noTreasure.description, equals('Sem Tesouro'));
        expect(Treasure.copperSilver.description, equals('Cobre e Prata'));
        expect(Treasure.silverGems.description, equals('Prata e Gemas'));
        expect(Treasure.specialTreasure.description, equals('Tesouro Especial'));
        expect(Treasure.magicItem.description, equals('Item Mágico'));
      });

      test('should have all expected values', () {
        expect(Treasure.values.length, equals(5));
      });
    });

    group('SpecialTreasure', () {
      test('should have correct descriptions', () {
        expect(SpecialTreasure.rollAgainPlusMagicItem.description, equals('Role Novamente + Item Mágico'));
        expect(SpecialTreasure.copperSilverGems.description, equals('Cobre, Prata e Gemas'));
        expect(SpecialTreasure.copperSilverGems2.description, equals('Cobre, Prata e Gemas 2'));
        expect(SpecialTreasure.copperSilverGemsValuable.description, equals('Cobre, Prata, Gemas e Objetos Valiosos'));
        expect(SpecialTreasure.copperSilverGemsMagicItem.description, equals('Cobre, Prata, Gemas e Item Mágico'));
        expect(SpecialTreasure.rollAgainPlusMagicItem2.description, equals('Role Novamente + Item Mágico 2'));
      });

      test('should have all expected values', () {
        expect(SpecialTreasure.values.length, equals(6));
      });
    });

    group('MagicItem', () {
      test('should have correct descriptions', () {
        expect(MagicItem.any1.description, equals('Qualquer 1'));
        expect(MagicItem.any1NotWeapon.description, equals('Qualquer 1 (Não Arma)'));
        expect(MagicItem.potion1.description, equals('Poção 1'));
        expect(MagicItem.scroll1.description, equals('Pergaminho 1'));
        expect(MagicItem.weapon1.description, equals('Arma 1'));
        expect(MagicItem.any2.description, equals('Qualquer 2'));
      });

      test('should have all expected values', () {
        expect(MagicItem.values.length, equals(6));
      });
    });
  });
}
