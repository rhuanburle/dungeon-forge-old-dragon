import 'lib/utils/treasure_resolver.dart';

void main() {
  print('=== Teste da Correção de Itens Mágicos ===');
  
  // Testa diferentes tipos de itens mágicos
  final testCases = [
    '1 Arma',
    '1 Qualquer',
    '1 Qualquer não Arma',
    '1 Poção',
    '1 Pergaminho',
    '2 Qualquer',
  ];
  
  for (final testCase in testCases) {
    print('\nTestando: $testCase');
    final result = TreasureResolver.resolve(testCase);
    print('Resultado: $result');
  }
} 