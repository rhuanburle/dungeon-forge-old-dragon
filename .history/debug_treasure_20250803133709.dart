import 'lib/utils/treasure_resolver.dart';
import 'lib/enums/table_enums.dart';

void main() {
  print('Nível 1: ${TreasureResolver.resolveByLevel(TreasureLevel.level1)}');
  print('Nível 4-5: ${TreasureResolver.resolveByLevel(TreasureLevel.level4to5)}');
} 