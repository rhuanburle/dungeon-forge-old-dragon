// services/tables/room_table_service.dart

import '../../models/dto/room_table_dto.dart';
import '../../utils/dice_roller.dart';

class RoomTableService {
  static const Map<int, String> _airTable = {
    2: 'corrente de ar quente',
    3: 'corrente de ar quente',
    4: 'leve brisa quente',
    5: 'leve brisa quente',
    6: 'sem corrente de ar',
    7: 'sem corrente de ar',
    8: 'leve brisa fria',
    9: 'leve brisa fria',
    10: 'corrente de ar fria',
    11: 'corrente de ar fria',
    12: 'vento forte e gelado',
  };

  static const Map<int, String> _smellTable = {
    2: 'cheiro de carne podre',
    3: 'cheiro de carne podre',
    4: 'cheiro de umidade e mofo',
    5: 'cheiro de umidade e mofo',
    6: 'sem cheiro especial',
    7: 'sem cheiro especial',
    8: 'cheiro de terra',
    9: 'cheiro de terra',
    10: 'cheiro de fumaça',
    11: 'cheiro de fumaça',
    12: 'cheiro de fezes e urina',
  };

  static const Map<int, String> _soundTable = {
    2: 'arranhado metálico',
    3: 'arranhado metálico',
    4: 'gotejar ritmado',
    5: 'gotejar ritmado',
    6: 'nenhum som especial',
    7: 'nenhum som especial',
    8: 'vento soprando',
    9: 'vento soprando',
    10: 'passos ao longe',
    11: 'passos ao longe',
    12: 'sussurros e gemidos',
  };

  static const Map<int, String> _itemTable = {
    2: 'completamente vazia',
    3: 'completamente vazia',
    4: 'poeira, sujeira e teias',
    5: 'poeira, sujeira e teias',
    6: 'móveis velhos',
    7: 'móveis velhos',
    8: 'vento soprando',
    9: 'vento soprando',
    10: 'restos de comida e lixo',
    11: 'restos de comida e lixo',
    12: 'roupas sujas e fétidas',
  };

  static const Map<int, String> _specialItemTable = {
    2: 'carcaças de monstros',
    3: 'carcaças de monstros',
    4: 'papéis velhos e rasgados',
    5: 'papéis velhos e rasgados',
    6: 'ossadas empilhadas',
    7: 'ossadas empilhadas',
    8: 'restos de tecidos sujos',
    9: 'restos de tecidos sujos',
    10: 'caixas, sacos e baús vazios',
    11: 'caixas, sacos e baús vazios',
    12: 'caixas, sacos e baús cheios',
  };

  static const Map<int, String> _commonRoomTable = {
    2: 'dormitório',
    3: 'dormitório',
    4: 'depósito geral',
    5: 'depósito geral',
    6: 'Especial…',
    7: 'Especial…',
    8: 'completamente vazia',
    9: 'completamente vazia',
    10: 'despensa de comida',
    11: 'despensa de comida',
    12: 'cela de prisão',
  };

  static const Map<int, String> _specialRoomTable = {
    2: 'sala de treinamento',
    3: 'sala de treinamento',
    4: 'refeitório',
    5: 'refeitório',
    6: 'completamente vazia',
    7: 'completamente vazia',
    8: 'Especial 2…',
    9: 'Especial 2…',
    10: 'altar religioso',
    11: 'altar religioso',
    12: 'covil abandonado',
  };

  static const Map<int, String> _specialRoom2Table = {
    2: 'câmara de tortura',
    3: 'câmara de tortura',
    4: 'câmara de rituais',
    5: 'câmara de rituais',
    6: 'laboratório mágico',
    7: 'laboratório mágico',
    8: 'biblioteca',
    9: 'biblioteca',
    10: 'cripta',
    11: 'cripta',
    12: 'arsenal',
  };

  static const Map<int, String> _monsterTable = {
    2: 'Novo Monstro + Ocupante I',
    3: 'Novo Monstro + Ocupante I',
    4: 'Ocupante I + Ocupante II',
    5: 'Ocupante I + Ocupante II',
    6: 'Ocupante I',
    7: 'Ocupante I',
    8: 'Ocupante II',
    9: 'Ocupante II',
    10: 'Novo Monstro',
    11: 'Novo Monstro',
    12: 'Novo Monstro + Ocupante II',
  };

  static const Map<int, String> _trapTable = {
    2: 'Guilhotina Oculta',
    3: 'Guilhotina Oculta',
    4: 'Fosso',
    5: 'Fosso',
    6: 'Dardos Envenenados',
    7: 'Dardos Envenenados',
    8: 'Armadilha Especial…',
    9: 'Armadilha Especial…',
    10: 'Bloco que Cai',
    11: 'Bloco que Cai',
    12: 'Spray Ácido',
  };

  static const Map<int, String> _specialTrapTable = {
    2: 'Poço de Água',
    3: 'Poço de Água',
    4: 'Desmoronamento',
    5: 'Desmoronamento',
    6: 'Teto Retrátil',
    7: 'Teto Retrátil',
    8: 'Porta Secreta',
    9: 'Porta Secreta',
    10: 'Alarme',
    11: 'Alarme',
    12: 'Portal Dimensional',
  };

  static const Map<int, String> _treasureTable = {
    2: 'Nenhum Tesouro',
    3: 'Nenhum Tesouro',
    4: 'Nenhum Tesouro',
    5: 'Nenhum Tesouro',
    6: '1d6 x 100 PP + 1d6 x 10 PO',
    7: '1d6 x 100 PP + 1d6 x 10 PO',
    8: '1d6 x 10 PO + 1d4 Gemas',
    9: '1d6 x 10 PO + 1d4 Gemas',
    10: 'Tesouro Especial…',
    11: 'Tesouro Especial…',
    12: 'Item Mágico',
  };

  static const Map<int, String> _specialTreasureTable = {
    2: 'Jogue Novamente + Item Mágico',
    3: 'Jogue Novamente + Item Mágico',
    4: '1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas',
    5: '1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas',
    6: '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas',
    7: '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas',
    8: '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor',
    9: '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor',
    10: '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico',
    11: '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico',
    12: 'Jogue Novamente + Item Mágico',
  };

  static const Map<int, String> _magicItemTable = {
    2: '1 Qualquer',
    3: '1 Qualquer',
    4: '1 Qualquer não Arma',
    5: '1 Qualquer não Arma',
    6: '1 Poção',
    7: '1 Poção',
    8: '1 Pergaminho',
    9: '1 Pergaminho',
    10: '1 Arma',
    11: '1 Arma',
    12: '2 Qualquer',
  };

  static RoomType _determineRoomType(int roll) {
    if (roll <= 3) return RoomType.specialRoom;
    if (roll <= 5) return RoomType.trap;
    if (roll <= 7) return RoomType.commonRoom;
    if (roll <= 9) return RoomType.encounter;
    if (roll <= 11) return RoomType.commonRoom;
    return RoomType.specialTrap;
  }

  static String _getFromTable(Map<int, String> table, int roll) {
    return table[roll] ?? 'Desconhecido';
  }

  static String _resolveSpecialReference(
      String reference, int col8Roll, int col9Roll) {
    if (reference == 'Especial…') {
      final col8Result = _getFromTable(_specialRoomTable, col8Roll);
      if (col8Result == 'Especial 2…') {
        return _getFromTable(_specialRoom2Table, col9Roll);
      }
      return col8Result;
    }
    return reference;
  }

  static String _resolveTrapReference(String reference, int col12Roll) {
    if (reference == 'Armadilha Especial…') {
      return _getFromTable(_specialTrapTable, col12Roll);
    }
    return reference;
  }

  static String _resolveTreasureReference(String reference, int col14Roll) {
    if (reference == 'Tesouro Especial…') {
      return _getFromTable(_specialTreasureTable, col14Roll);
    }
    return reference;
  }

  static RoomTableDto generateRoomData({
    required String occupantI,
    required String occupantII,
  }) {
    final col1Roll = DiceRoller.roll(2, 6);
    final col2Roll = DiceRoller.roll(2, 6);
    final col3Roll = DiceRoller.roll(2, 6);
    final col4Roll = DiceRoller.roll(2, 6);
    final col5Roll = DiceRoller.roll(2, 6);
    final col6Roll = DiceRoller.roll(2, 6);
    final col7Roll = DiceRoller.roll(2, 6);
    final col8Roll = DiceRoller.roll(2, 6);
    final col9Roll = DiceRoller.roll(2, 6);
    final col10Roll = DiceRoller.roll(2, 6);
    final col11Roll = DiceRoller.roll(2, 6);
    final col12Roll = DiceRoller.roll(2, 6);
    final col13Roll = DiceRoller.roll(2, 6);
    final col14Roll = DiceRoller.roll(2, 6);
    final col15Roll = DiceRoller.roll(2, 6);

    final roomType = _determineRoomType(col1Roll);

    // Aplica modificadores de tesouro
    int adjustedCol13Roll = col13Roll + roomType.treasureModifier;
    int adjustedCol14Roll = col14Roll + roomType.treasureModifier;
    int adjustedCol15Roll = col15Roll + roomType.treasureModifier;

    // Garante que os valores não ultrapassem 12
    adjustedCol13Roll = adjustedCol13Roll.clamp(2, 12);
    adjustedCol14Roll = adjustedCol14Roll.clamp(2, 12);
    adjustedCol15Roll = adjustedCol15Roll.clamp(2, 12);

    // Determina tipo de sala baseado no roomType
    String typeDescription = roomType.displayName;
    if (roomType == RoomType.specialRoom) {
      typeDescription =
          'Sala Especial (${_getFromTable(_specialRoomTable, col8Roll)})';
    } else if (roomType == RoomType.trap) {
      typeDescription = 'Armadilha (${_getFromTable(_trapTable, col11Roll)})';
    } else if (roomType == RoomType.commonRoom) {
      typeDescription =
          'Sala Comum (${_getFromTable(_commonRoomTable, col7Roll)})';
    } else if (roomType == RoomType.specialTrap) {
      typeDescription =
          'Sala Armadilha Especial (${_getFromTable(_specialTrapTable, col12Roll)})';
    }

    // Resolve referências especiais
    String roomCommon = '';
    if (roomType == RoomType.commonRoom) {
      final commonRoom = _getFromTable(_commonRoomTable, col7Roll);
      roomCommon = _resolveSpecialReference(commonRoom, col8Roll, col9Roll);
    }

    String roomSpecial = '';
    if (roomType == RoomType.specialRoom) {
      final specialRoom = _getFromTable(_specialRoomTable, col8Roll);
      roomSpecial = _resolveSpecialReference(specialRoom, col8Roll, col9Roll);
    }

    String roomSpecial2 = '';
    if (roomSpecial == 'Especial 2…') {
      roomSpecial2 = _getFromTable(_specialRoom2Table, col9Roll);
    }

    // Determina monstros
    String monster1 = '';
    String monster2 = '';
    if (roomType == RoomType.encounter) {
      String monsterResult = _getFromTable(_monsterTable, col10Roll);
      monsterResult = monsterResult
          .replaceAll('Ocupante I', occupantI)
          .replaceAll('Ocupante II', occupantII);

      if (monsterResult.contains(' + ')) {
        final parts = monsterResult.split(' + ');
        monster1 = parts[0].trim();
        monster2 = parts[1].trim();
      } else {
        monster1 = monsterResult;
      }
    }

    // Determina armadilha
    String trap = '';
    if (roomType == RoomType.trap || roomType == RoomType.specialTrap) {
      final trapResult = _getFromTable(_trapTable, col11Roll);
      trap = _resolveTrapReference(trapResult, col12Roll);
    }

    String specialTrap = '';
    if (trap == 'Armadilha Especial…') {
      specialTrap = _getFromTable(_specialTrapTable, col12Roll);
    }

    // Determina tesouro
    String treasure = _getFromTable(_treasureTable, adjustedCol13Roll);
    String specialTreasure = '';
    if (treasure == 'Tesouro Especial…') {
      specialTreasure = _resolveTreasureReference(treasure, adjustedCol14Roll);
    }

    String magicItem = '';
    if (treasure == 'Item Mágico' || specialTreasure.contains('Item Mágico')) {
      magicItem = _getFromTable(_magicItemTable, adjustedCol15Roll);
    }

    // Determina item especial
    String specialItem = '';
    if (_getFromTable(_itemTable, col5Roll) == 'vento soprando') {
      specialItem = _getFromTable(_specialItemTable, col6Roll);
    }

    return RoomTableDto(
      roomType: roomType,
      air: _getFromTable(_airTable, col2Roll),
      smell: _getFromTable(_smellTable, col3Roll),
      sound: _getFromTable(_soundTable, col4Roll),
      item: _getFromTable(_itemTable, col5Roll),
      specialItem: specialItem,
      monster1: monster1,
      monster2: monster2,
      trap: trap,
      specialTrap: specialTrap,
      roomCommon: roomCommon,
      roomSpecial: roomSpecial,
      roomSpecial2: roomSpecial2,
      treasure: treasure,
      specialTreasure: specialTreasure,
      magicItem: magicItem,
    );
  }
}
