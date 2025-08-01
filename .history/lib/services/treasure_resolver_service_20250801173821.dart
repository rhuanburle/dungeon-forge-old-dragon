// services/treasure_resolver_service.dart

import '../utils/treasure_resolver.dart';

class TreasureResolverService {
  static String resolveTreasure(String treasure) {
    if (treasure.contains('d') || treasure.contains('Jogue Novamente')) {
      return TreasureResolver.resolve(treasure);
    }
    return treasure;
  }

  static String resolveMagicItem(String magicItem) {
    if (magicItem.isNotEmpty) {
      return TreasureResolver.resolve(magicItem);
    }
    return magicItem;
  }
}
