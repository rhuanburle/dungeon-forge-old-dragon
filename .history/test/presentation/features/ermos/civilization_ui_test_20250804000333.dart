import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/services/exploration_service.dart';
import '../../../../lib/enums/exploration_enums.dart';

String _extractField(String details, String fieldName) {
  final lines = details.split('\n');
  for (final line in lines) {
    if (line.contains('• $fieldName:')) {
      return line.split('• $fieldName:')[1].trim();
    }
  }
  return 'N/A';
}

void main() {
  group('Civilization UI Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    testWidgets('should display detailed civilization information', (WidgetTester tester) async {
      // Gerar civilização detalhada
      final civilization = service.generateDetailedCivilization();
      
      // Verificar se contém todos os campos esperados
      expect(civilization.details, contains('Nível Tecnológico'));
      expect(civilization.details, contains('Aparência'));
      expect(civilization.details, contains('Alinhamento do Governo'));
      expect(civilization.details, contains('Governante'));
      expect(civilization.details, contains('Raça Dominante'));
      expect(civilization.details, contains('Especial'));
      expect(civilization.details, contains('Atitude com Visitantes'));
      expect(civilization.details, contains('Tema (Povoado/Aldeia/Vila)'));
      expect(civilization.details, contains('Tema (Cidade/Metrópole)'));
    });

    testWidgets('should extract fields correctly from details', (WidgetTester tester) async {
      final civilization = service.generateDetailedCivilization();
      
      // Testar extração de campos
      final techLevel = _extractField(civilization.details, 'Nível Tecnológico');
      final appearance = _extractField(civilization.details, 'Aparência');
      final alignment = _extractField(civilization.details, 'Alinhamento do Governo');
      
      expect(techLevel, isNot('N/A'));
      expect(appearance, isNot('N/A'));
      expect(alignment, isNot('N/A'));
      
      // Verificar se os valores são válidos
      final validTechLevels = ['Tribal/Selvagem', 'Era do bronze', 'Medieval', 'Renascimento'];
      final validAlignments = ['Ordeiro', 'Neutro', 'Caótico'];
      
      expect(validTechLevels.contains(techLevel), isTrue);
      expect(validAlignments.contains(alignment), isTrue);
    });
  });
} 