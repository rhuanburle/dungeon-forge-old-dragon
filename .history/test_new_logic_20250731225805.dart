import 'dart:math';

void main() {
  print('=== Teste da Nova Lógica da Tabela 9.2 ===');
  
  // Simula a geração de algumas salas para verificar a lógica
  for (int i = 1; i <= 5; i++) {
    print('\n--- Sala $i ---');
    
    // Simula os rolls da tabela 9.2
    final col1Roll = Random().nextInt(12) + 2; // 2d6
    final col5Roll = Random().nextInt(12) + 2;
    final col13Roll = Random().nextInt(12) + 2;
    
    // Determina tipo de sala
    String type;
    if (col1Roll <= 3) {
      type = 'Sala Especial (coluna 8)';
    } else if (col1Roll <= 5) {
      type = 'Armadilha (coluna 11)';
    } else if (col1Roll <= 7) {
      type = 'Sala Comum (coluna 7)';
    } else if (col1Roll <= 9) {
      type = 'Monstro (coluna 10)';
    } else if (col1Roll <= 11) {
      type = 'Sala Comum (coluna 7)';
    } else {
      type = 'Sala Armadilha Especial (coluna 12)';
    }
    
    print('Roll Col1: $col1Roll → Tipo: $type');
    
    // Verifica se item especial é usado
    if (col5Roll == 9) {
      print('Roll Col5: $col5Roll → Item Especial será usado (coluna 6)');
    } else {
      print('Roll Col5: $col5Roll → Item Especial NÃO será usado');
    }
    
    // Verifica tesouro
    String treasure;
    if (col13Roll <= 5) {
      treasure = 'Nenhum';
    } else if (col13Roll <= 7) {
      treasure = '1d6 x 100 PP + 1d6 x 10 PO';
    } else if (col13Roll <= 9) {
      treasure = '1d6 x 10 PO + 1d4 Gemas';
    } else if (col13Roll <= 11) {
      treasure = 'Tesouro Especial…';
    } else {
      treasure = 'Item Mágico';
    }
    
    print('Roll Col13: $col13Roll → Tesouro: $treasure');
    
    // Verifica se colunas especiais são usadas
    if (type.contains('Sala Comum')) {
      print('→ Coluna 7 será usada para Sala Comum');
    }
    if (type.contains('Sala Especial')) {
      print('→ Coluna 8 será usada para Sala Especial');
    }
    if (type.contains('Monstro')) {
      print('→ Coluna 10 será usada para Monstros');
    }
    if (type.contains('Armadilha')) {
      print('→ Coluna 11 será usada para Armadilhas');
    }
    if (treasure == 'Tesouro Especial…') {
      print('→ Coluna 14 será usada para Tesouro Especial');
    }
    if (treasure == 'Item Mágico' || treasure.contains('Item Mágico')) {
      print('→ Coluna 15 será usada para Item Mágico');
    }
  }
} 