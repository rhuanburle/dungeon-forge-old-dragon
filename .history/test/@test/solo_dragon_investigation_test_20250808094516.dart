import 'package:flutter_test/flutter_test.dart';

import '../../lib/services/solo_dragon/solo_dragon_service.dart';

void main() {
  group('@test solo dragon investigation', () {
    test('investigation has 1-2 in 1d6 chance', () {
      final service = SoloDragonService.withSeed(42);
      int hits = 0;
      for (int i = 0; i < 6000; i++) {
        if (service.rollInvestigationFound()) hits++;
      }
      // Around ~33%, accept broad bounds
      final ratio = hits / 6000.0;
      expect(ratio, greaterThan(0.25));
      expect(ratio, lessThan(0.42));
    });
  });
}


