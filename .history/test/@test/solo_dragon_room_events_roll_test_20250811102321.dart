import 'package:flutter_test/flutter_test.dart';

import '../../lib/services/solo_dragon/solo_dragon_service.dart';

void main() {
  group('@test solo dragon roll encounter and traps', () {
    test('allEventRolls returns 36 ordered values 11..66', () {
      final svc = SoloDragonService();
      final rolls = svc.allEventRolls();
      expect(rolls.length, 36);
      expect(rolls.first, 11);
      expect(rolls.last, 66);
    });

    test('getEventTextForRoll returns non-empty for valid rolls', () {
      final svc = SoloDragonService();
      for (final r in svc.allEventRolls()) {
        expect(svc.getEventTextForRoll(r, EventColumn.doors), isA<String>());
      }
    });
  });
}


