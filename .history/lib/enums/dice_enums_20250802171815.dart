/// ========================================
/// ENUMS PARA DADOS (D2 a D100)
/// ========================================

/// Enum para representar tipos de dados de D2 a D100
enum DiceType {
  d2(2),
  d4(4),
  d6(6),
  d8(8),
  d10(10),
  d12(12),
  d20(20),
  d100(100);

  const DiceType(this.sides);
  final int sides;
}
