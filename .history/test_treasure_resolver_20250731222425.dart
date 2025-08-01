import 'lib/utils/treasure_resolver.dart';

void main() {
  print('=== Teste do TreasureResolver ===');
  
  // Testes para verificar se o problema do "2 +" foi resolvido
  final testCases = [
    '1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor',
    '1d6 x 10 PO + 1d4 Gemas',
    '1 Qualquer',
    '2 Qualquer',
    '1 Poção',
    '1 Pergaminho',
    '1 Arma',
  ];
  
  for (final testCase in testCases) {
    print('\nTestando: $testCase');
    final result = TreasureResolver.resolve(testCase);
    print('Resultado: $result');
  }
} 