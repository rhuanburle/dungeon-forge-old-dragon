import 'lib/tables/table_manager.dart';

void main() {
  print('=== TESTE DE MAPEAMENTO DA TABELA 9.1 ===');
  
  final tableManager = TableManager();
  final dungeonTable = tableManager.dungeonTable;
  
  print('\n--- Verificação da Coluna 1 (Tipo de Masmorra) ---');
  print('Roll 2-3: ${dungeonTable.getColumn1(2)} e ${dungeonTable.getColumn1(3)}');
  print('Roll 4-5: ${dungeonTable.getColumn1(4)} e ${dungeonTable.getColumn1(5)}');
  print('Roll 6-7: ${dungeonTable.getColumn1(6)} e ${dungeonTable.getColumn1(7)}');
  print('Roll 8-9: ${dungeonTable.getColumn1(8)} e ${dungeonTable.getColumn1(9)}');
  print('Roll 10-11: ${dungeonTable.getColumn1(10)} e ${dungeonTable.getColumn1(11)}');
  print('Roll 12: ${dungeonTable.getColumn1(12)}');
  
  print('\n--- Verificação da Coluna 2 (Construtor/Habitante) ---');
  print('Roll 2-3: ${dungeonTable.getColumn2(2)} e ${dungeonTable.getColumn2(3)}');
  print('Roll 4-5: ${dungeonTable.getColumn2(4)} e ${dungeonTable.getColumn2(5)}');
  print('Roll 6-7: ${dungeonTable.getColumn2(6)} e ${dungeonTable.getColumn2(7)}');
  print('Roll 8-9: ${dungeonTable.getColumn2(8)} e ${dungeonTable.getColumn2(9)}');
  print('Roll 10-11: ${dungeonTable.getColumn2(10)} e ${dungeonTable.getColumn2(11)}');
  print('Roll 12: ${dungeonTable.getColumn2(12)}');
  
  print('\n--- Verificação da Coluna 9 (Fórmula de Tamanho) ---');
  print('Roll 2-3: ${dungeonTable.getColumn9(2)} e ${dungeonTable.getColumn9(3)}');
  print('Roll 4-5: ${dungeonTable.getColumn9(4)} e ${dungeonTable.getColumn9(5)}');
  print('Roll 6-7: ${dungeonTable.getColumn9(6)} e ${dungeonTable.getColumn9(7)}');
  print('Roll 8-9: ${dungeonTable.getColumn9(8)} e ${dungeonTable.getColumn9(9)}');
  print('Roll 10-11: ${dungeonTable.getColumn9(10)} e ${dungeonTable.getColumn9(11)}');
  print('Roll 12: ${dungeonTable.getColumn9(12)}');
  
  print('\n=== FIM DO TESTE ===');
} 