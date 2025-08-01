// lib/services/dungeon/tables/rumor_tables.dart
// Tabela 9-1 (Colunas 13-15) – Rumores sobre a masmorra.
// Cada entrada é duplicada para manter a distribuição estatística de 2d6 (12 itens).

class RumorEntry {
  final String subject; // Ex.: Um/uma [coluna 11] decapitada/o
  final String action; // Ex.: foi visto próximo a
  final String location; // Ex.: festival religioso do outono

  const RumorEntry({
    required this.subject,
    required this.action,
    required this.location,
  });

  String buildRumor(String occupant1, String occupant2, String leader) {
    String rumor = '$subject $action $location';
    
    // Substitui as referências pelas colunas corretas
    return rumor
        .replaceAll('[coluna 11]', occupant2)
        .replaceAll('[coluna 10]', occupant1)
        .replaceAll('[coluna 12]', leader);
  }
}

class RumorTable {
  RumorTable._();

  static const List<RumorEntry> entries = [
    // 1-2
    RumorEntry(
      subject: 'Um/uma [coluna 11] decapitada/o',
      action: 'foi visto próximo a',
      location: 'festival religioso do outono',
    ),
    RumorEntry(
      subject: 'Um/uma [coluna 11] decapitada/o',
      action: 'foi visto próximo a',
      location: 'festival religioso do outono',
    ),
    // 3-4
    RumorEntry(
      subject: 'Um camponês bêbado',
      action: 'foi capturado na/no',
      location: 'vila no ano passado durante o eclipse',
    ),
    RumorEntry(
      subject: 'Um camponês bêbado',
      action: 'foi capturado na/no',
      location: 'vila no ano passado durante o eclipse',
    ),
    // 5-6
    RumorEntry(
      subject: 'Um/uma [coluna 10]',
      action: 'deixou rastros na/no',
      location: 'fazenda quando uma ovelha sumiu',
    ),
    RumorEntry(
      subject: 'Um/uma [coluna 10]',
      action: 'deixou rastros na/no',
      location: 'fazenda quando uma ovelha sumiu',
    ),
    // 7-8
    RumorEntry(
      subject: 'Um estrangeiro muito rico',
      action: 'procurou o sacerdote na/no',
      location: 'aldeia vizinha próxima',
    ),
    RumorEntry(
      subject: 'Um estrangeiro muito rico',
      action: 'procurou o sacerdote na/no',
      location: 'aldeia vizinha próxima',
    ),
    // 9-10
    RumorEntry(
      subject: 'Um místico cego',
      action: 'foi morto por um lobisomem na/no',
      location: 'caravana de comércio da primavera',
    ),
    RumorEntry(
      subject: 'Um místico cego',
      action: 'foi morto por um lobisomem na/no',
      location: 'caravana de comércio da primavera',
    ),
    // 11-12
    RumorEntry(
      subject: '[coluna 12]',
      action: 'amaldiçoou a/o',
      location: 'nevasca do inverno há 3 anos',
    ),
    RumorEntry(
      subject: '[coluna 12]',
      action: 'amaldiçoou a/o',
      location: 'nevasca do inverno há 3 anos',
    ),
  ];
} 