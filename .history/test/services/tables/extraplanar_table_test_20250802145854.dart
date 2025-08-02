// test/services/tables/extraplanar_table_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../../lib/tables/extraplanar_table.dart';
import '../../../lib/enums/table_enums.dart';

void main() {
  group('ExtraplanarTable', () {
    late ExtraplanarTable table;

    setUp(() {
      table = ExtraplanarTable();
    });

    test('should have correct table properties', () {
      expect(table.tableName, equals('Tabela A13.10 - Encontros Extraplanares'));
      expect(table.description, equals('Tabela de encontros extraplanares'));
      expect(table.columnCount, equals(3));
      expect(table.difficultyLevel, equals(DifficultyLevel.medium));
    });

    test('should return correct values for Extraplanar I column', () {
      expect(table.getExtraplanarI(1), equals(MonsterType.imp));
      expect(table.getExtraplanarI(2), equals(MonsterType.traag));
      expect(table.getExtraplanarI(3), equals(MonsterType.waterElementalLesser));
      expect(table.getExtraplanarI(4), equals(MonsterType.earthElementalLesser));
      expect(table.getExtraplanarI(5), equals(MonsterType.airElementalLesser));
      expect(table.getExtraplanarI(6), equals(MonsterType.fireElementalLesser));
      expect(table.getExtraplanarI(7), equals(MonsterType.doppelganger));
      expect(table.getExtraplanarI(8), equals(MonsterType.slenderMan));
    });

    test('should return correct values for Extraplanar II column', () {
      expect(table.getExtraplanarII(1), equals(MonsterType.slenderMan));
      expect(table.getExtraplanarII(2), equals(MonsterType.flyingPolyp));
      expect(table.getExtraplanarII(3), equals(MonsterType.waterElemental));
      expect(table.getExtraplanarII(4), equals(MonsterType.earthElemental));
      expect(table.getExtraplanarII(5), equals(MonsterType.airElemental));
      expect(table.getExtraplanarII(6), equals(MonsterType.fireElemental));
      expect(table.getExtraplanarII(7), equals(MonsterType.genie));
      expect(table.getExtraplanarII(8), equals(MonsterType.invisibleHunter));
    });

    test('should return correct values for Extraplanar III column', () {
      expect(table.getExtraplanarIII(1), equals(MonsterType.invisibleHunter));
      expect(table.getExtraplanarIII(2), equals(MonsterType.efreeti));
      expect(table.getExtraplanarIII(3), equals(MonsterType.waterElementalGreater));
      expect(table.getExtraplanarIII(4), equals(MonsterType.earthElementalGreater));
      expect(table.getExtraplanarIII(5), equals(MonsterType.airElementalGreater));
      expect(table.getExtraplanarIII(6), equals(MonsterType.fireElementalGreater));
      expect(table.getExtraplanarIII(7), equals(MonsterType.shoggoth));
      expect(table.getExtraplanarIII(8), equals(MonsterType.cerberus));
    });

    test('should work with getByPartyLevel method', () {
      expect(table.getByPartyLevel(PartyLevel.beginners, 1), equals(MonsterType.imp));
      expect(table.getByPartyLevel(PartyLevel.heroic, 1), equals(MonsterType.slenderMan));
      expect(table.getByPartyLevel(PartyLevel.advanced, 1), equals(MonsterType.invisibleHunter));
    });

    test('should throw error for invalid roll', () {
      expect(() => table.getExtraplanarI(0), throwsArgumentError);
      expect(() => table.getExtraplanarI(9), throwsArgumentError);
      expect(() => table.getExtraplanarII(0), throwsArgumentError);
      expect(() => table.getExtraplanarII(9), throwsArgumentError);
    });

    test('should return correct table info', () {
      final info = table.getTableInfo();
      expect(info, contains('Tabela A13.10 - Encontros Extraplanares'));
      expect(info, contains('Tabela de encontros extraplanares'));
      expect(info, contains('3 colunas'));
      expect(info, contains('Mediano'));
    });
  });
} 