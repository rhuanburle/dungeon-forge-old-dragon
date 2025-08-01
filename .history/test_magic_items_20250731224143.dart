import 'lib/utils/treasure_resolver.dart';

void main() {
  print('=== Teste de Itens Mágicos ===');
  
  // Testes para diferentes tipos de itens mágicos
  final testCases = [
    '1 Qualquer',
    '2 Qualquer',
    '1 Qualquer não Arma',
    '1 Arma',
    '1 Poção',
    '1 Pergaminho',
  ];
  
  for (final testCase in testCases) {
    print('\nTestando: $testCase');
    final result = TreasureResolver.resolve(testCase);
    print('Resultado: $result');
  }
  
  // Teste múltiplo para ver variedade
  print('\n=== Teste de Variedade (10x "1 Qualquer") ===');
  for (int i = 1; i <= 10; i++) {
    final result = TreasureResolver.resolve('1 Qualquer');
    print('$i: $result');
  }
  
  print('\n=== Teste de Variedade (10x "1 Arma") ===');
  for (int i = 1; i <= 10; i++) {
    final result = TreasureResolver.resolve('1 Arma');
    print('$i: $result');
  }
  
  print('\n=== Teste de Variedade (10x "1 Qualquer não Arma") ===');
  for (int i = 1; i <= 10; i++) {
    final result = TreasureResolver.resolve('1 Qualquer não Arma');
    print('$i: $result');
  }
} 