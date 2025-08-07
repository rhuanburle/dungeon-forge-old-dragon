import 'package:flutter_test/flutter_test.dart';
import 'package:dungeon_forge/services/exploration_service.dart';
import 'package:dungeon_forge/models/exploration.dart' as models;

void main() {
  group('@test exploration refactor structure', () {
    test('generateDetailedAncestralDiscovery returns populated result', () {
      final service = ExplorationService();
      final result = service.generateDetailedAncestralDiscovery();
      expect(result, isA<models.AncestralDiscovery>());
      expect(result.description, isNotEmpty);
      expect(result.details, isNotEmpty);
    });
  });
}
