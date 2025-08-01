// lib/services/dungeon/tables/dungeon_location_table.dart
// Tabela 9-1 (Colunas 7-8) – Localização e entrada da masmorra.
// Cada entrada é duplicada para manter a distribuição estatística de 2d6 (12 itens).

class DungeonLocationEntry {
  final String location; // Ex.: Deserto Escaldante, Sob uma Cidade
  final String entry; // Ex.: Atrás de uma Cachoeira, Túnel Secreto

  const DungeonLocationEntry({
    required this.location,
    required this.entry,
  });
}

class DungeonLocationTable {
  DungeonLocationTable._();

  static const List<DungeonLocationEntry> entries = [
    // 1-2
    DungeonLocationEntry(
      location: 'Deserto Escaldante',
      entry: 'Atrás de uma Cachoeira',
    ),
    DungeonLocationEntry(
      location: 'Deserto Escaldante',
      entry: 'Atrás de uma Cachoeira',
    ),
    // 3-4
    DungeonLocationEntry(
      location: 'Sob uma Cidade',
      entry: 'Túnel Secreto',
    ),
    DungeonLocationEntry(
      location: 'Sob uma Cidade',
      entry: 'Túnel Secreto',
    ),
    // 5-6
    DungeonLocationEntry(
      location: 'Montanha Gelada',
      entry: 'Pequena Gruta',
    ),
    DungeonLocationEntry(
      location: 'Montanha Gelada',
      entry: 'Pequena Gruta',
    ),
    // 7-8
    DungeonLocationEntry(
      location: 'Floresta Selvagem',
      entry: 'Fissura numa Rocha',
    ),
    DungeonLocationEntry(
      location: 'Floresta Selvagem',
      entry: 'Fissura numa Rocha',
    ),
    // 9-10
    DungeonLocationEntry(
      location: 'Pântano Fétido',
      entry: 'Covil de um Monstro',
    ),
    DungeonLocationEntry(
      location: 'Pântano Fétido',
      entry: 'Covil de um Monstro',
    ),
    // 11-12
    DungeonLocationEntry(
      location: 'Ilha Isolada',
      entry: 'Boca de um Vulcão',
    ),
    DungeonLocationEntry(
      location: 'Ilha Isolada',
      entry: 'Boca de um Vulcão',
    ),
  ];
} 