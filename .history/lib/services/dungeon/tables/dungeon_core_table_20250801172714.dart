// lib/services/dungeon/tables/dungeon_core_table.dart
// Tabela 9-1 (Colunas 1-6) – Propriedades principais da masmorra.
// Cada entrada é duplicada para manter a distribuição estatística de 2d6 (12 itens).

class DungeonCoreEntry {
  final String type; // Ex.: Construção Perdida, Labirinto Artificial
  final String builder; // Ex.: Desconhecido, Cultistas
  final String status; // Ex.: Amaldiçoados, Extintos
  final String objective; // Ex.: Defender, Esconder
  final String target; // Ex.: artefato, livro
  final String condition; // Ex.: sendo procurado, destruído

  const DungeonCoreEntry({
    required this.type,
    required this.builder,
    required this.status,
    required this.objective,
    required this.target,
    required this.condition,
  });

  String get fullObjective => '$objective $target $condition';
}

class DungeonCoreTable {
  DungeonCoreTable._();

  static const List<DungeonCoreEntry> entries = [
    // 1-2
    DungeonCoreEntry(
      type: 'Construção Perdida',
      builder: 'Desconhecido',
      status: 'Amaldiçoados',
      objective: 'Defender',
      target: 'artefato',
      condition: 'sendo procurado',
    ),
    DungeonCoreEntry(
      type: 'Construção Perdida',
      builder: 'Desconhecido',
      status: 'Amaldiçoados',
      objective: 'Defender',
      target: 'artefato',
      condition: 'sendo procurado',
    ),
    // 3-4
    DungeonCoreEntry(
      type: 'Labirinto Artificial',
      builder: 'Cultistas',
      status: 'Extintos',
      objective: 'Esconder',
      target: 'livro',
      condition: 'destruído',
    ),
    DungeonCoreEntry(
      type: 'Labirinto Artificial',
      builder: 'Cultistas',
      status: 'Extintos',
      objective: 'Esconder',
      target: 'livro',
      condition: 'destruído',
    ),
    // 5-6
    DungeonCoreEntry(
      type: 'Cavernas Naturais',
      builder: 'Civilização Ancestral',
      status: 'Ancestrais',
      objective: 'Proteger',
      target: 'espada',
      condition: 'desaparecido',
    ),
    DungeonCoreEntry(
      type: 'Cavernas Naturais',
      builder: 'Civilização Ancestral',
      status: 'Ancestrais',
      objective: 'Proteger',
      target: 'espada',
      condition: 'desaparecido',
    ),
    // 7-8
    DungeonCoreEntry(
      type: 'Covil Desabitado',
      builder: 'Anões',
      status: 'Desaparecidos',
      objective: 'Guardar',
      target: 'gema',
      condition: 'roubado',
    ),
    DungeonCoreEntry(
      type: 'Covil Desabitado',
      builder: 'Anões',
      status: 'Desaparecidos',
      objective: 'Guardar',
      target: 'gema',
      condition: 'roubado',
    ),
    // 9-10
    DungeonCoreEntry(
      type: 'Fortaleza Abandonada',
      builder: 'Magos',
      status: 'Perdidos',
      objective: 'Vigiar',
      target: 'elmo',
      condition: 'intacto',
    ),
    DungeonCoreEntry(
      type: 'Fortaleza Abandonada',
      builder: 'Magos',
      status: 'Perdidos',
      objective: 'Vigiar',
      target: 'elmo',
      condition: 'intacto',
    ),
    // 11-12
    DungeonCoreEntry(
      type: 'Mina Desativada',
      builder: 'Gigantes',
      status: 'em outro local',
      objective: 'Isolar',
      target: 'tesouro',
      condition: 'soterrado',
    ),
    DungeonCoreEntry(
      type: 'Mina Desativada',
      builder: 'Gigantes',
      status: 'em outro local',
      objective: 'Isolar',
      target: 'tesouro',
      condition: 'soterrado',
    ),
  ];
}
