import 'package:flutter_test/flutter_test.dart';

import '../../lib/services/solo_dragon/solo_dragon_service.dart';

void main() {
  group('@test solo dragon oracle', () {
    test('oracle answers map correctly for 1..6', () {
      expect(SoloDragonService.oracleAnswerFor(1), 'Não, e...');
      expect(SoloDragonService.oracleAnswerFor(2), 'Não');
      expect(SoloDragonService.oracleAnswerFor(3), 'Não, mas...');
      expect(SoloDragonService.oracleAnswerFor(4), 'Sim, mas...');
      expect(SoloDragonService.oracleAnswerFor(5), 'Sim');
      expect(SoloDragonService.oracleAnswerFor(6), 'Sim, e');
    });

    test('oracle throws for out-of-range values', () {
      expect(() => SoloDragonService.oracleAnswerFor(0), throwsArgumentError);
      expect(() => SoloDragonService.oracleAnswerFor(7), throwsArgumentError);
    });
  });
}


