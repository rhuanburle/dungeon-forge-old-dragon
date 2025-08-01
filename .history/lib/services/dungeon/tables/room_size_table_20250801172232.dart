// lib/services/dungeon/tables/room_size_table.dart
// Tabela 9-1 (Coluna 9) – Tamanho da masmorra e fórmula de quantidade de salas.
// Cada entrada é duplicada para manter a distribuição estatística de 2d6 (12 itens)
// sem precisar de lógica de pesos adicionais.

import '../../../utils/dice_roller.dart';

class RoomSizeEntry {
  final String label; // Ex.: Grande, Média, Pequena
  final String formula; // Ex.: 3d6+4
  const RoomSizeEntry(this.label, this.formula);

  int rollRoomsCount() => DiceRoller.rollFormula(formula);
}

class RoomSizeTable {
  RoomSizeTable._();

  static const List<RoomSizeEntry> entries = [
    RoomSizeEntry('Grande', '3d6+4'),
    RoomSizeEntry('Grande', '3d6+4'),
    RoomSizeEntry('Média', '2d6+4'),
    RoomSizeEntry('Média', '2d6+4'),
    RoomSizeEntry('Pequena', '1d6+4'),
    RoomSizeEntry('Pequena', '1d6+4'),
    RoomSizeEntry('Pequena', '1d6+6'),
    RoomSizeEntry('Pequena', '1d6+6'),
    RoomSizeEntry('Média', '2d6+6'),
    RoomSizeEntry('Média', '2d6+6'),
    RoomSizeEntry('Grande', '3d6+6'),
    RoomSizeEntry('Grande', '3d6+6'),
  ];
}
