// services/room_count_calculator.dart

import 'dart:math';
import '../utils/dice_roller.dart';

class RoomCountCalculator {
  static int calculateRoomsCount({
    required String formula,
    int? customRoomCount,
    int? minRooms,
    int? maxRooms,
  }) {
    if (customRoomCount != null) {
      return customRoomCount;
    }

    int roomsCount = _extractRoomsCountFromFormula(formula);

    // Ajuste baseado em min/max
    if (minRooms != null && maxRooms != null) {
      // Gera valor aleatório dentro do intervalo
      final low = min(minRooms, maxRooms);
      final high = max(minRooms, maxRooms);
      roomsCount = low + DiceRoller.roll(1, high - low + 1) - 1;
    } else {
      // Caso apenas um dos filtros exista aplica como clamp
      if (minRooms != null && roomsCount < minRooms) roomsCount = minRooms;
      if (maxRooms != null && roomsCount > maxRooms) roomsCount = maxRooms;
    }

    return roomsCount;
  }

  static int _extractRoomsCountFromFormula(String formula) {
    // Expected format: "Grande – 3d6+6" etc. We'll take formula part after dash.
    final parts = formula.split('–');
    if (parts.length < 2) return 5; // Fallback mínimo
    final diceFormula = parts[1].trim();
    final count = DiceRoller.rollFormula(diceFormula);
    // Garante pelo menos 3 salas
    return count < 3 ? 5 : count;
  }
} 