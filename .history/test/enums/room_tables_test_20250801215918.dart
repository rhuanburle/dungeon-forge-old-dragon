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
        expect(RoomType.monster.description, equals('Encontro'));
        expect(RoomType.specialTrap.description, equals('Sala Armadilha Especial'));
      });

      test('should have all expected values', () {
        expect(RoomType.values.length, equals(5));
      });
    });

    group('AirCurrent', () {
      test('should have correct descriptions', () {
        expect(AirCurrent.hotDraft.description, equals('corrente de ar quente'));
        expect(AirCurrent.lightHotBreeze.description, equals('leve brisa quente'));
        expect(AirCurrent.noAirCurrent.description, equals('sem corrente de ar'));
        expect(AirCurrent.lightColdBreeze.description, equals('leve brisa fria'));
        expect(AirCurrent.coldDraft.description, equals('corrente de ar fria'));
        expect(AirCurrent.strongIcyWind.description, equals('vento forte e gelado'));
      });

      test('should have all expected values', () {
        expect(AirCurrent.values.length, equals(6));
      });
    });

    group('Smell', () {
      test('should have correct descriptions', () {
        expect(Smell.rottenMeat.description, equals('cheiro de carne podre'));
        expect(Smell.humidityMold.description, equals('cheiro de umidade e mofo'));
        expect(Smell.noSpecialSmell.description, equals('sem cheiro especial'));
        expect(Smell.earthSmell.description, equals('cheiro de terra'));
        expect(Smell.smokeSmell.description, equals('cheiro de fumaça'));
        expect(Smell.fecesUrine.description, equals('cheiro de fezes e urina'));
      });

      test('should have all expected values', () {
        expect(Smell.values.length, equals(6));
      });
    });

    group('Sound', () {
      test('should have correct descriptions', () {
        expect(Sound.metallicScratch.description, equals('arranhado metálico'));
        expect(Sound.rhythmicDrip.description, equals('gotejar ritmado'));
        expect(Sound.noSpecialSound.description, equals('nenhum som especial'));
        expect(Sound.windBlowing.description, equals('vento soprando'));
        expect(Sound.distantFootsteps.description, equals('passos ao longe'));
        expect(Sound.whispersMoans.description, equals('sussurros e gemidos'));
      });

      test('should have all expected values', () {
        expect(Sound.values.length, equals(6));
      });
    });

    group('FoundItem', () {
      test('should have correct descriptions', () {
        expect(FoundItem.completelyEmpty.description, equals('completamente vazia'));
        expect(FoundItem.dustDirtWebs.description, equals('poeira, sujeira e teias'));
        expect(FoundItem.oldFurniture.description, equals('móveis velhos'));
        expect(FoundItem.specialItems.description, equals('itens encontrados especial…'));
        expect(FoundItem.foodRemainsGarbage.description, equals('restos de comida e lixo'));
        expect(FoundItem.dirtyFetidClothes.description, equals('roupas sujas e fétidas'));
      });

      test('should have all expected values', () {
        expect(FoundItem.values.length, equals(6));
      });
    });

    group('SpecialItem', () {
      test('should have correct descriptions', () {
        expect(SpecialItem.monsterCarcasses.description, equals('carcaças de monstros'));
        expect(SpecialItem.oldTornPapers.description, equals('papéis velhos e rasgados'));
        expect(SpecialItem.piledBones.description, equals('ossadas empilhadas'));
        expect(SpecialItem.dirtyFabricRemains.description, equals('restos de tecidos sujos'));
        expect(SpecialItem.emptyBoxesBagsChests.description, equals('caixas, sacos e baús vazios'));
        expect(SpecialItem.fullBoxesBagsChests.description, equals('caixas, sacos e baús cheios'));
      });

      test('should have all expected values', () {
        expect(SpecialItem.values.length, equals(6));
      });
    });

    group('CommonRoom', () {
      test('should have correct descriptions', () {
        expect(CommonRoom.dormitory.description, equals('dormitório'));
        expect(CommonRoom.generalDeposit.description, equals('depósito geral'));
        expect(CommonRoom.special.description, equals('Especial…'));
        expect(CommonRoom.completelyEmpty.description, equals('completamente vazia'));
        expect(CommonRoom.foodPantry.description, equals('despensa de comida'));
        expect(CommonRoom.prisonCell.description, equals('cela de prisão'));
      });

      test('should have all expected values', () {
        expect(CommonRoom.values.length, equals(6));
      });
    });

    group('SpecialRoom', () {
      test('should have correct descriptions', () {
        expect(SpecialRoom.trainingRoom.description, equals('sala de treinamento'));
        expect(SpecialRoom.diningRoom.description, equals('refeitório'));
        expect(SpecialRoom.completelyEmpty.description, equals('completamente vazia'));
        expect(SpecialRoom.special2.description, equals('Especial 2…'));
        expect(SpecialRoom.religiousAltar.description, equals('altar religioso'));
        expect(SpecialRoom.abandonedDen.description, equals('covil abandonado'));
      });

      test('should have all expected values', () {
        expect(SpecialRoom.values.length, equals(6));
      });
    });

    group('SpecialRoom2', () {
      test('should have correct descriptions', () {
        expect(SpecialRoom2.tortureChamber.description, equals('câmara de tortura'));
        expect(SpecialRoom2.ritualChamber.description, equals('câmara de rituais'));
        expect(SpecialRoom2.magicalLaboratory.description, equals('laboratório mágico'));
        expect(SpecialRoom2.library.description, equals('biblioteca'));
        expect(SpecialRoom2.crypt.description, equals('cripta'));
        expect(SpecialRoom2.arsenal.description, equals('arsenal'));
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
        expect(Trap.pit.description, equals('Fosso'));
        expect(Trap.poisonedDarts.description, equals('Dardos Envenenados'));
        expect(Trap.specialTrap.description, equals('Armadilha Especial…'));
        expect(Trap.fallingBlock.description, equals('Bloco que Cai'));
        expect(Trap.acidSpray.description, equals('Spray Ácido'));
      });

      test('should have all expected values', () {
        expect(Trap.values.length, equals(6));
      });
    });

    group('SpecialTrap', () {
      test('should have correct descriptions', () {
        expect(SpecialTrap.waterWell.description, equals('Poço de Água'));
        expect(SpecialTrap.collapse.description, equals('Desmoronamento'));
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
        expect(Treasure.noTreasure.description, equals('Nenhum Tesouro'));
        expect(Treasure.copperSilver.description, equals('1d6 x 100 PP + 1d6 x 10 PO'));
        expect(Treasure.silverGems.description, equals('1d6 x 10 PO + 1d4 Gemas'));
        expect(Treasure.specialTreasure.description, equals('Tesouro Especial…'));
        expect(Treasure.magicItem.description, equals('Item Mágico'));
      });

      test('should have all expected values', () {
        expect(Treasure.values.length, equals(5));
      });
    });

    group('SpecialTreasure', () {
      test('should have correct descriptions', () {
        expect(SpecialTreasure.rollAgainPlusMagicItem.description, equals('Jogue Novamente + Item Mágico'));
        expect(SpecialTreasure.copperSilverGems.description, equals('1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas'));
        expect(SpecialTreasure.copperSilverGems2.description, equals('1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas'));
        expect(SpecialTreasure.copperSilverGemsValuable.description, equals('1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor'));
        expect(SpecialTreasure.copperSilverGemsMagicItem.description, equals('1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico'));
        expect(SpecialTreasure.rollAgainPlusMagicItem2.description, equals('Jogue Novamente + Item Mágico 2'));
      });

      test('should have all expected values', () {
        expect(SpecialTreasure.values.length, equals(6));
      });
    });

    group('MagicItem', () {
      test('should have correct descriptions', () {
        expect(MagicItem.any1.description, equals('1 Qualquer'));
        expect(MagicItem.any1NotWeapon.description, equals('1 Qualquer não Arma'));
        expect(MagicItem.potion1.description, equals('1 Poção'));
        expect(MagicItem.scroll1.description, equals('1 Pergaminho'));
        expect(MagicItem.weapon1.description, equals('1 Arma'));
        expect(MagicItem.any2.description, equals('2 Qualquer'));
      });

      test('should have all expected values', () {
        expect(MagicItem.values.length, equals(6));
      });
    });
  });
}
