import 'dart:math';

void main() {
  print('=== Teste da Nova Lógica de Tesouro ===');
  
  // Simula os dados da tabela
  final results = <String>[];
  
  for (int i = 1; i <= 20; i++) {
    final treasureRoll = Random().nextInt(12) + 2; // 2d6
    String treasure = '';
    String specialTreasure = '';
    String magicItem = '';
    
    // Determina o tesouro baseado no roll da coluna 13
    if (treasureRoll <= 3) {
      // 2-3: Nenhum Tesouro
      treasure = 'Nenhum';
    } else if (treasureRoll <= 5) {
      // 4-5: Nenhum Tesouro
      treasure = 'Nenhum';
    } else if (treasureRoll <= 7) {
      // 6-7: 1d6 x 100 PP + 1d6 x 10 PO
      treasure = '1d6 x 100 PP + 1d6 x 10 PO';
    } else if (treasureRoll <= 9) {
      // 8-9: 1d6 x 10 PO + 1d4 Gemas
      treasure = '1d6 x 10 PO + 1d4 Gemas';
    } else if (treasureRoll <= 11) {
      // 10-11: Tesouro Especial...
      treasure = 'Tesouro Especial…';
      // Rola na coluna 14 para tesouro especial
      final specialRoll = Random().nextInt(12) + 2;
      if (specialRoll <= 2) {
        specialTreasure = 'Jogue Novamente + Item Mágico';
      } else if (specialRoll <= 4) {
        specialTreasure = '1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas';
      } else if (specialRoll <= 6) {
        specialTreasure = '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas';
      } else if (specialRoll <= 8) {
        specialTreasure = '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor';
      } else if (specialRoll <= 10) {
        specialTreasure = '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico';
      } else {
        specialTreasure = 'Jogue Novamente + Item Mágico 2';
      }
    } else {
      // 12-14: Item Mágico
      treasure = 'Item Mágico';
    }
    
    // Determina item mágico baseado na coluna 15 (só se necessário)
    if (treasure == 'Item Mágico' || specialTreasure.contains('Item Mágico')) {
      final magicRoll = Random().nextInt(12) + 2;
      if (magicRoll <= 3) {
        magicItem = '1 Qualquer';
      } else if (magicRoll <= 5) {
        magicItem = '1 Qualquer não Arma';
      } else if (magicRoll <= 7) {
        magicItem = '1 Poção';
      } else if (magicRoll <= 9) {
        magicItem = '1 Pergaminho';
      } else if (magicRoll <= 11) {
        magicItem = '1 Arma';
      } else {
        magicItem = '2 Qualquer';
      }
    }
    
    results.add('Sala $i: Roll=$treasureRoll, Tesouro=$treasure, Especial=$specialTreasure, Mágico=$magicItem');
  }
  
  // Mostra os resultados
  for (final result in results) {
    print(result);
  }
  
  // Estatísticas
  print('\n=== Estatísticas ===');
  final nenhumCount = results.where((r) => r.contains('Tesouro=Nenhum')).length;
  final tesouroCount = results.where((r) => r.contains('1d6') || r.contains('1d10')).length;
  final especialCount = results.where((r) => r.contains('Tesouro Especial')).length;
  final magicoCount = results.where((r) => r.contains('Item Mágico')).length;
  
  print('Nenhum Tesouro: $nenhumCount/20 (${(nenhumCount/20*100).toStringAsFixed(1)}%)');
  print('Tesouro Normal: $tesouroCount/20 (${(tesouroCount/20*100).toStringAsFixed(1)}%)');
  print('Tesouro Especial: $especialCount/20 (${(especialCount/20*100).toStringAsFixed(1)}%)');
  print('Item Mágico: $magicoCount/20 (${(magicoCount/20*100).toStringAsFixed(1)}%)');
} 