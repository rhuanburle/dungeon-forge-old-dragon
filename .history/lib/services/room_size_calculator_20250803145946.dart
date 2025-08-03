// services/room_size_calculator.dart

import '../utils/dice_roller.dart';

/// Serviço responsável por calcular o número de salas baseado nas fórmulas da tabela
class RoomSizeCalculator {
  /// Calcula o número de salas baseado na fórmula da tabela
  int calculateRoomCount(
    String sizeFormula, {
    int? customRoomCount,
    int? minRooms,
    int? maxRooms,
  }) {
    // Se foi especificado um número customizado, usa ele
    if (customRoomCount != null && customRoomCount > 0) {
      return customRoomCount;
    }

    // Calcula baseado na fórmula da tabela
    int roomCount = _parseSizeFormula(sizeFormula);

    // Aplica restrições de min/max se especificadas
    if (minRooms != null && maxRooms != null) {
      // Se ambos min e max estão definidos, gera um valor aleatório dentro do range
      if (roomCount < minRooms || roomCount > maxRooms) {
        // Usa uma abordagem que funciona com qualquer range
        final range = maxRooms - minRooms + 1;
        if (range <= 6) {
          // Para ranges pequenos, usa d6 e ajusta
          roomCount = DiceRoller.rollStatic(1, 6);
          while (roomCount > range) {
            roomCount = DiceRoller.rollStatic(1, 6);
          }
          roomCount = minRooms + roomCount - 1;
        } else if (range <= 20) {
          // Para ranges médios, usa d20 e ajusta
          roomCount = DiceRoller.rollStatic(1, 20);
          while (roomCount > range) {
            roomCount = DiceRoller.rollStatic(1, 20);
          }
          roomCount = minRooms + roomCount - 1;
        } else {
          // Para ranges grandes, usa d100 e ajusta
          roomCount = DiceRoller.rollStatic(1, 100);
          while (roomCount > range) {
            roomCount = DiceRoller.rollStatic(1, 100);
          }
          roomCount = minRooms + roomCount - 1;
        }
      }
    } else if (minRooms != null && roomCount < minRooms) {
      // Se apenas min está definido, usa o valor mínimo
      roomCount = minRooms;
    } else if (maxRooms != null && roomCount > maxRooms) {
      // Se apenas max está definido, usa o valor máximo
      roomCount = maxRooms;
    }

    return roomCount;
  }

  /// Faz o parse da fórmula de tamanho da tabela
  int _parseSizeFormula(String formula) {
    // Remove espaços e converte para minúsculas para facilitar o parsing
    final cleanFormula = formula.toLowerCase().replaceAll(' ', '');

    // Remove "salas" do final se presente
    final formulaWithoutSalas = cleanFormula.replaceAll('salas', '');

    // Parse de fórmulas como "1d6+4", "2d6+6", "3d6+8", etc.
    if (formulaWithoutSalas.contains('1d6+4')) {
      return DiceRoller.rollStatic(1, 6) + 4;
    } else if (formulaWithoutSalas.contains('1d6+6')) {
      return DiceRoller.rollStatic(1, 6) + 6;
    } else if (formulaWithoutSalas.contains('2d6+4')) {
      return DiceRoller.rollStatic(2, 6) + 4;
    } else if (formulaWithoutSalas.contains('2d6+6')) {
      return DiceRoller.rollStatic(2, 6) + 6;
    } else if (formulaWithoutSalas.contains('3d6+4')) {
      return DiceRoller.rollStatic(3, 6) + 4;
    } else if (formulaWithoutSalas.contains('3d6+6')) {
      return DiceRoller.rollStatic(3, 6) + 6;
    } else if (formulaWithoutSalas.contains('3d6+8')) {
      return DiceRoller.rollStatic(3, 6) + 8;
    } else if (formulaWithoutSalas.contains('4d6+10')) {
      return DiceRoller.rollStatic(4, 6) + 10;
    } else if (formulaWithoutSalas.contains('5d6+12')) {
      return DiceRoller.rollStatic(5, 6) + 12;
    } else if (formulaWithoutSalas.contains('6d6+14')) {
      return DiceRoller.rollStatic(6, 6) + 14;
    }

    // Fallback: tenta fazer parse genérico de fórmulas NdM+X
    final regex = RegExp(r'(\d+)d(\d+)\+(\d+)');
    final match = regex.firstMatch(formulaWithoutSalas);
    if (match != null) {
      final diceCount = int.parse(match.group(1)!);
      final diceSides = int.parse(match.group(2)!);
      final bonus = int.parse(match.group(3)!);
      return DiceRoller.rollStatic(diceCount, diceSides) + bonus;
    }

    // Fallback: retorna um valor padrão
    print('Fórmula não reconhecida: $formula');
    return 8;
  }

  /// Obtém uma descrição do tamanho baseado no número de salas
  String getSizeDescription(int roomCount) {
    if (roomCount <= 6) {
      return 'Pequena';
    } else if (roomCount <= 12) {
      return 'Média';
    } else {
      return 'Grande';
    }
  }

  /// Valida se o número de salas está dentro de limites razoáveis
  bool isValidRoomCount(int roomCount) {
    return roomCount >= 1 && roomCount <= 50;
  }
}
