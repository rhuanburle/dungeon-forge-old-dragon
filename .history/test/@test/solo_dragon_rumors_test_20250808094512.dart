import 'package:flutter_test/flutter_test.dart';

import '../../lib/services/solo_dragon/solo_dragon_service.dart';

void main() {
  group('@test solo dragon rumors', () {
    test('generate three rumors formatted as A5.2 rows', () {
      final service = SoloDragonService.withSeed(123);
      final rumors = service.generateRumors();
      expect(rumors.length, 3);
      for (final r in rumors) {
        expect(r.createdBy, isNotEmpty);
        expect(r.purpose, isNotEmpty);
        expect(r.target, isNotEmpty);
      }
    });
  });
}


