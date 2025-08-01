void main() {
  // Teste da lógica de separação de monstros
  testMonsterSeparation();
}

void testMonsterSeparation() {
  print('=== Teste da Lógica de Separação de Monstros ===');
  
  // Casos de teste
  final testCases = [
    'Ocupante I + Ocupante II',
    'Novo Monstro + Ocupante I',
    'Novo Monstro + Ocupante II',
    'Ocupante I',
    'Ocupante II',
    'Novo Monstro',
  ];
  
  final occupantI = 'Goblin';
  final occupantII = 'Orc';
  
  for (final testCase in testCases) {
    print('\nTestando: $testCase');
    
    // Simula a substituição
    var result = testCase;
    result = result.replaceAll('Ocupante I', occupantI);
    result = result.replaceAll('Ocupante II', occupantII);
    
    print('Após substituição: $result');
    
    // Simula a separação
    String monster1 = '';
    String monster2 = '';
    
    if (result.contains(' + ')) {
      final parts = result.split(' + ');
      if (parts.length >= 2) {
        monster1 = parts[0].trim();
        monster2 = parts[1].trim();
        print('  -> Separado: monster1="$monster1", monster2="$monster2"');
      } else {
        monster1 = result;
        monster2 = '';
        print('  -> Caso inesperado, usando single: "$monster1"');
      }
    } else {
      monster1 = result;
      monster2 = '';
      print('  -> Single monster: "$monster1"');
    }
  }
} 