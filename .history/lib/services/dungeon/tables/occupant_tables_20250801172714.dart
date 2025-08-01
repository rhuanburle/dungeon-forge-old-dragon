// lib/services/dungeon/tables/occupant_tables.dart
// Tabela 9-1 (Colunas 10-12) – Ocupantes e líder da masmorra.
// Cada entrada é duplicada para manter a distribuição estatística de 2d6 (12 itens).

class OccupantEntry {
  final String occupant1; // Ex.: Trolls, Orcs
  final String occupant2; // Ex.: Kobolds, Limo Cinzento
  final String leader; // Ex.: Hobgoblin, Cubo Gelatinoso

  const OccupantEntry({
    required this.occupant1,
    required this.occupant2,
    required this.leader,
  });
}

class OccupantTable {
  OccupantTable._();

  static const List<OccupantEntry> entries = [
    // 1-2
    OccupantEntry(
      occupant1: 'Trolls',
      occupant2: 'Kobolds',
      leader: 'Hobgoblin',
    ),
    OccupantEntry(
      occupant1: 'Trolls',
      occupant2: 'Kobolds',
      leader: 'Hobgoblin',
    ),
    // 3-4
    OccupantEntry(
      occupant1: 'Orcs',
      occupant2: 'Limo Cinzento',
      leader: 'Cubo Gelatinoso',
    ),
    OccupantEntry(
      occupant1: 'Orcs',
      occupant2: 'Limo Cinzento',
      leader: 'Cubo Gelatinoso',
    ),
    // 5-6
    OccupantEntry(
      occupant1: 'Esqueletos',
      occupant2: 'Zumbis',
      leader: 'Cultista',
    ),
    OccupantEntry(
      occupant1: 'Esqueletos',
      occupant2: 'Zumbis',
      leader: 'Cultista',
    ),
    // 7-8
    OccupantEntry(
      occupant1: 'Goblins',
      occupant2: 'Ratos Gigantes',
      leader: 'Sombra',
    ),
    OccupantEntry(
      occupant1: 'Goblins',
      occupant2: 'Ratos Gigantes',
      leader: 'Sombra',
    ),
    // 9-10
    OccupantEntry(
      occupant1: 'Bugbears',
      occupant2: 'Fungos Pigmeu',
      leader: 'Necromante',
    ),
    OccupantEntry(
      occupant1: 'Bugbears',
      occupant2: 'Fungos Pigmeu',
      leader: 'Necromante',
    ),
    // 11-12
    OccupantEntry(
      occupant1: 'Ogros',
      occupant2: 'Homens Lagartos',
      leader: 'Dragão',
    ),
    OccupantEntry(
      occupant1: 'Ogros',
      occupant2: 'Homens Lagartos',
      leader: 'Dragão',
    ),
  ];
}
