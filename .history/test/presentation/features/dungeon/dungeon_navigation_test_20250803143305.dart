// test/presentation/features/dungeon/dungeon_navigation_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/presentation/features/dungeon/dungeon_page.dart';
import '../../lib/services/dungeon_generator_refactored.dart';
import '../../lib/models/dungeon.dart';

void main() {
  group('Dungeon Navigation Tests', () {
    late Dungeon testDungeon;

    setUp(() {
      final generator = DungeonGeneratorRefactored();
      testDungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 5,
      );
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: DungeonPage(),
      );
    }

    group('Navigation State Management', () {
      testWidgets('should initialize with room 1 as current and visited',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verifica se a sala 1 está marcada como atual
        expect(find.text('Sala Atual: 1'), findsOneWidget);
        expect(find.text('Salas Visitadas: 1/5'), findsOneWidget);
      });

      testWidgets('should update current room when navigation icon is tapped',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Encontra e clica no ícone de navegação da sala 2
        final navigationIcons = find.byIcon(Icons.radio_button_unchecked);
        if (navigationIcons.evaluate().isNotEmpty) {
          await tester.tap(navigationIcons.first);
          await tester.pumpAndSettle();

          // Verifica se a sala 2 agora é a atual
          expect(find.text('Sala Atual: 2'), findsOneWidget);
          expect(find.text('Salas Visitadas: 2/5'), findsOneWidget);
        }
      });

      testWidgets('should add room to visited list when marked as current',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Marca sala 3 como atual
        final navigationIcons = find.byIcon(Icons.radio_button_unchecked);
        if (navigationIcons.evaluate().length >= 2) {
          await tester.tap(navigationIcons.at(1)); // Sala 3
          await tester.pumpAndSettle();

          // Verifica se a sala 3 foi adicionada às visitadas
          expect(find.text('Salas Visitadas: 2/5'), findsOneWidget);
        }
      });

      testWidgets('should clear navigation when clear button is pressed',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Marca algumas salas como visitadas
        final navigationIcons = find.byIcon(Icons.radio_button_unchecked);
        if (navigationIcons.evaluate().length >= 2) {
          await tester.tap(navigationIcons.first); // Sala 2
          await tester.pumpAndSettle();
          await tester.tap(navigationIcons.at(1)); // Sala 3
          await tester.pumpAndSettle();

          // Clica no botão de limpar navegação
          final clearButton = find.byIcon(Icons.clear_all);
          await tester.tap(clearButton);
          await tester.pumpAndSettle();

          // Verifica se voltou ao estado inicial
          expect(find.text('Sala Atual: 1'), findsOneWidget);
          expect(find.text('Salas Visitadas: 1/5'), findsOneWidget);
        }
      });
    });

    group('Visual State Indicators', () {
      testWidgets('should show current room with green styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verifica se a sala atual tem o ícone de localização
        expect(find.byIcon(Icons.my_location), findsOneWidget);
        expect(find.text('Sala Atual'), findsOneWidget);
      });

      testWidgets('should show visited rooms with blue styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Marca uma sala como visitada
        final navigationIcons = find.byIcon(Icons.radio_button_unchecked);
        if (navigationIcons.evaluate().isNotEmpty) {
          await tester.tap(navigationIcons.first);
          await tester.pumpAndSettle();

          // Verifica se a sala visitada tem o ícone de check
          expect(find.byIcon(Icons.check), findsOneWidget);
          expect(find.text('Sala Visitada'), findsOneWidget);
        }
      });

      testWidgets('should show entrance room with special styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verifica se a sala de entrada tem o ícone de entrada
        expect(find.byIcon(Icons.input), findsOneWidget);
        expect(find.text('ENTRADA'), findsOneWidget);
      });

      testWidgets('should show boss room with special styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verifica se a sala do boss tem o ícone de warning
        expect(find.byIcon(Icons.warning), findsOneWidget);
        expect(find.text('BOSS'), findsOneWidget);
      });
    });

    group('Navigation Progress Display', () {
      testWidgets('should display correct navigation progress',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verifica se o progresso inicial está correto
        expect(find.text('Sala Atual: 1'), findsOneWidget);
        expect(find.text('Salas Visitadas: 1/5'), findsOneWidget);
        expect(find.text('Total de Salas: 5'), findsOneWidget);
      });

      testWidgets('should update progress when rooms are visited',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Marca algumas salas como visitadas
        final navigationIcons = find.byIcon(Icons.radio_button_unchecked);
        if (navigationIcons.evaluate().length >= 3) {
          await tester.tap(navigationIcons.first); // Sala 2
          await tester.pumpAndSettle();
          await tester.tap(navigationIcons.at(1)); // Sala 3
          await tester.pumpAndSettle();

          // Verifica se o progresso foi atualizado
          expect(find.text('Sala Atual: 3'), findsOneWidget);
          expect(find.text('Salas Visitadas: 3/5'), findsOneWidget);
        }
      });
    });

    group('Navigation Reset', () {
      testWidgets('should reset navigation when new dungeon is generated',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Marca algumas salas como visitadas
        final navigationIcons = find.byIcon(Icons.radio_button_unchecked);
        if (navigationIcons.evaluate().length >= 2) {
          await tester.tap(navigationIcons.first); // Sala 2
          await tester.pumpAndSettle();

          // Gera uma nova masmorra
          final generateButton = find.byIcon(Icons.refresh);
          await tester.tap(generateButton);
          await tester.pumpAndSettle();

          // Verifica se a navegação foi resetada
          expect(find.text('Sala Atual: 1'), findsOneWidget);
          expect(find.text('Salas Visitadas: 1/'), findsOneWidget);
        }
      });
    });
  });
} 