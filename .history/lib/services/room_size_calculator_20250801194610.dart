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
    if (minRooms != null && roomCount < minRooms) {
      roomCount = minRooms;
    }
    if (maxRooms != null && roomCount > maxRooms) {
      roomCount = maxRooms;
    }

    return roomCount;
  }

  /// Faz o parse da fórmula de tamanho da tabela
  int _parseSizeFormula(String formula) {
    // Remove espaços e converte para minúsculas para facilitar o parsing
    final cleanFormula = formula.toLowerCase().replaceAll(' ', '');

    if (cleanFormula.contains('grande')) {
      return _parseGrandeFormula(cleanFormula);
    } else if (cleanFormula.contains('média')) {
      return _parseMediaFormula(cleanFormula);
    } else if (cleanFormula.contains('pequena')) {
      return _parsePequenaFormula(cleanFormula);
    }

    // Fallback: retorna um valor padrão
    return 8;
  }

  /// Faz o parse de fórmulas "Grande"
  int _parseGrandeFormula(String formula) {
    if (formula.contains('3d6+4')) {
      return DiceRoller.roll(3, 6) + 4;
    } else if (formula.contains('3d6+6')) {
      return DiceRoller.roll(3, 6) + 6;
    }
    return DiceRoller.roll(3, 6) + 4; // Fallback
  }

  /// Faz o parse de fórmulas "Média"
  int _parseMediaFormula(String formula) {
    if (formula.contains('2d6+4')) {
      return DiceRoller.roll(2, 6) + 4;
    } else if (formula.contains('2d6+6')) {
      return DiceRoller.roll(2, 6) + 6;
    }
    return DiceRoller.roll(2, 6) + 4; // Fallback
  }

  /// Faz o parse de fórmulas "Pequena"
  int _parsePequenaFormula(String formula) {
    if (formula.contains('1d6+4')) {
      return DiceRoller.roll(1, 6) + 4;
    } else if (formula.contains('1d6+6')) {
      return DiceRoller.roll(1, 6) + 6;
    }
    return DiceRoller.roll(1, 6) + 4; // Fallback
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
