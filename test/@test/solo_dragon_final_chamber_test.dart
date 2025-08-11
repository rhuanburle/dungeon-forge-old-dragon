import 'package:flutter_test/flutter_test.dart';

import '../../lib/services/solo_dragon/solo_dragon_service.dart';

void main() {
  group('@test solo dragon final chamber (A5.7)', () {
    test('getFinalChamberForRolls maps A->subtable correctly', () {
      final svc = SoloDragonService();

      final r1 = svc.getFinalChamberForRolls(1, 3);
      expect(r1.subTable, 'B');
      expect(r1.aText.contains('nada certo'), isTrue);

      final r2 = svc.getFinalChamberForRolls(3, 2);
      expect(r2.subTable, 'C');
      expect(r2.aText.contains('em parte'), isTrue);

      final r3 = svc.getFinalChamberForRolls(6, 5);
      expect(r3.subTable, 'D');
      expect(r3.aText.contains('bem-sucedida'), isTrue);
    });

    test('getFinalChamberForRolls selects subText by subRoll', () {
      final svc = SoloDragonService();

      final b = svc.getFinalChamberForRolls(1, 1);
      expect(b.subText, contains('construtor'));

      final c = svc.getFinalChamberForRolls(3, 4);
      expect(c.subText.isNotEmpty, isTrue);

      final d = svc.getFinalChamberForRolls(5, 6);
      expect(d.subText, contains('irreversível'));
    });
  });
}
