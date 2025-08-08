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

    test('rumor board follows A5.2 structure with 3x3 grid', () {
      final service = SoloDragonService.withSeed(42);
      final setup = service.generateDungeonSetupWithRumors();
      final board = setup.rumorBoard;
      
      // Verifica que temos 3 rumores
      expect(board.rumors.length, 3);
      
      // Verifica que cada rumor tem as 3 partes (A, B, C)
      for (int i = 0; i < 3; i++) {
        final rumor = board.getRumorAt(i);
        expect(rumor.createdBy, isNotEmpty); // Coluna A
        expect(rumor.purpose, isNotEmpty);   // Coluna B  
        expect(rumor.target, isNotEmpty);    // Coluna C
      }
      
      // Verifica que inicialmente nada está eliminado
      for (int i = 0; i < 3; i++) {
        expect(board.isEliminated(ColumnId.a, i), false);
        expect(board.isEliminated(ColumnId.b, i), false);
        expect(board.isEliminated(ColumnId.c, i), false);
      }
    });

    test('elimination follows migration rules A1>A2>A3>B1>B2>B3>C1>C2>C3>A1', () {
      final service = SoloDragonService.withSeed(99);
      final setup = service.generateDungeonSetupWithRumors();
      final board = setup.rumorBoard;
      
      // Elimina A1
      board.eliminate(ColumnId.a, 0);
      expect(board.isEliminated(ColumnId.a, 0), true);
      
      // Elimina A2  
      board.eliminate(ColumnId.a, 1);
      expect(board.isEliminated(ColumnId.a, 1), true);
      
      // Elimina A3
      board.eliminate(ColumnId.a, 2);
      expect(board.isEliminated(ColumnId.a, 2), true);
      
      // Agora deve migrar para B1
      board.eliminate(ColumnId.a, 0); // Tenta eliminar A1 novamente
      expect(board.isEliminated(ColumnId.b, 0), true); // Deve ter migrado para B1
    });
  });
}
