/// ========================================
/// ENUMS PARA DADOS (D2 a D100)
/// ========================================

/// Enum para representar tipos de dados de D2 a D100
enum DiceType {
  d2('D2', 2),
  d3('D3', 3),
  d4('D4', 4),
  d6('D6', 6),
  d8('D8', 8),
  d10('D10', 10),
  d12('D12', 12),
  d20('D20', 20),
  d100('D100', 100);

  const DiceType(this.description, this.sides);
  final String description;
  final int sides;
}
