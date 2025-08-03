// test/presentation/shared/widgets/navigable_room_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dungeon_forge/models/room.dart';
import 'package:dungeon_forge/presentation/shared/widgets/navigable_room_card.dart';

void main() {
  group('NavigableRoomCard Tests', () {
    late Room testRoom;

    setUp(() {
      testRoom = Room(
        index: 1,
        type: 'Sala Comum',
        air: 'Corrente de ar quente',
        smell: 'Cheiro de umidade',
        sound: 'Gotejar ritmado',
        item: 'Móveis velhos',
        specialItem: '—',
        monster1: 'Ocupante I',
        monster2: '—',
        trap: '—',
        specialTrap: '—',
        roomCommon: 'Dormitório',
        roomSpecial: '—',
        roomSpecial2: '—',
        treasure: 'Nenhum',
        specialTreasure: '—',
        magicItem: '—',
      );
    });

    Widget createTestWidget({
      required Room room,
      required bool isCurrentRoom,
      required bool isVisited,
      bool isEntrance = false,
      bool isBoss = false,
      VoidCallback? onRoomTap,
      VoidCallback? onNavigationTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: NavigableRoomCard(
            room: room,
            isCurrentRoom: isCurrentRoom,
            isVisited: isVisited,
            isEntrance: isEntrance,
            isBoss: isBoss,
            onRoomTap: onRoomTap,
            onNavigationTap: onNavigationTap,
          ),
        ),
      );
    }

    group('Visual States', () {
      testWidgets('should display current room with green color and location icon',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: true,
          isVisited: false,
        ));

        // Verifica se o ícone de localização está presente
        expect(find.byIcon(Icons.my_location), findsOneWidget);
        
        // Verifica se o texto "Sala Atual" está presente
        expect(find.text('Sala Atual'), findsOneWidget);
      });

      testWidgets('should display visited room with blue color and check icon',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: true,
        ));

        // Verifica se o ícone de check está presente
        expect(find.byIcon(Icons.check), findsOneWidget);
        
        // Verifica se o texto "Sala Visitada" está presente
        expect(find.text('Sala Visitada'), findsOneWidget);
      });

      testWidgets('should display unvisited room with grey color and unchecked icon',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: false,
        ));

        // Verifica se o ícone de radio button unchecked está presente
        expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
        
        // Verifica se o texto "Clique para mais detalhes" está presente
        expect(find.text('Clique para mais detalhes'), findsOneWidget);
      });

      testWidgets('should display entrance room with special styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: false,
          isEntrance: true,
        ));

        // Verifica se o ícone de entrada está presente
        expect(find.byIcon(Icons.input), findsOneWidget);
        
        // Verifica se o label "ENTRADA" está presente
        expect(find.text('ENTRADA'), findsOneWidget);
      });

      testWidgets('should display boss room with special styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: false,
          isBoss: true,
        ));

        // Verifica se o ícone de warning está presente
        expect(find.byIcon(Icons.warning), findsOneWidget);
        
        // Verifica se o label "BOSS" está presente
        expect(find.text('BOSS'), findsOneWidget);
      });
    });

    group('Interaction Tests', () {
      testWidgets('should call onRoomTap when tapping the room card',
          (WidgetTester tester) async {
        bool roomTapped = false;
        
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: false,
          onRoomTap: () => roomTapped = true,
        ));

        // Toca na sala (não no ícone de navegação)
        await tester.tap(find.text('Sala 1'));
        await tester.pump();

        expect(roomTapped, isTrue);
      });

      testWidgets('should call onNavigationTap when tapping the navigation icon',
          (WidgetTester tester) async {
        bool navigationTapped = false;
        
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: false,
          onNavigationTap: () => navigationTapped = true,
        ));

        // Toca no ícone de navegação
        await tester.tap(find.byIcon(Icons.radio_button_unchecked));
        await tester.pump();

        expect(navigationTapped, isTrue);
      });

      testWidgets('should not call onRoomTap when tapping navigation icon',
          (WidgetTester tester) async {
        bool roomTapped = false;
        
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: false,
          onRoomTap: () => roomTapped = true,
        ));

        // Toca no ícone de navegação
        await tester.tap(find.byIcon(Icons.radio_button_unchecked));
        await tester.pump();

        expect(roomTapped, isFalse);
      });
    });

    group('Content Display', () {
      testWidgets('should display room information correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: false,
        ));

        // Verifica se as informações da sala estão presentes
        expect(find.text('Sala 1'), findsOneWidget);
        expect(find.text('Ar'), findsOneWidget);
        expect(find.text('Corrente de ar quente'), findsOneWidget);
        expect(find.text('Cheiro'), findsOneWidget);
        expect(find.text('Cheiro de umidade'), findsOneWidget);
        expect(find.text('Som'), findsOneWidget);
        expect(find.text('Gotejar ritmado'), findsOneWidget);
        expect(find.text('Itens'), findsOneWidget);
        expect(find.text('Móveis velhos'), findsOneWidget);
        expect(find.text('Monstro 1'), findsOneWidget);
        expect(find.text('Ocupante I'), findsOneWidget);
        expect(find.text('Sala Comum'), findsOneWidget);
        expect(find.text('Dormitório'), findsOneWidget);
      });

      testWidgets('should not display empty or default values',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: false,
          isVisited: false,
        ));

        // Verifica que valores vazios ou padrão não são exibidos
        expect(find.text('—'), findsNothing);
        expect(find.text('Nenhum'), findsNothing);
        expect(find.text('Sem corrente de ar'), findsNothing);
        expect(find.text('Sem cheiro especial'), findsNothing);
        expect(find.text('Nenhum som especial'), findsNothing);
        expect(find.text('Completamente vazia'), findsNothing);
      });
    });

    group('Priority States', () {
      testWidgets('should prioritize current room over visited state',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: true,
          isVisited: true,
        ));

        // Deve mostrar como sala atual (verde) mesmo sendo visitada
        expect(find.byIcon(Icons.my_location), findsOneWidget);
        expect(find.text('Sala Atual'), findsOneWidget);
      });

      testWidgets('should prioritize entrance over other states',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: true,
          isVisited: true,
          isEntrance: true,
        ));

        // Deve mostrar como entrada mesmo sendo atual e visitada
        expect(find.byIcon(Icons.input), findsOneWidget);
        expect(find.text('ENTRADA'), findsOneWidget);
      });

      testWidgets('should prioritize boss over other states',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(
          room: testRoom,
          isCurrentRoom: true,
          isVisited: true,
          isBoss: true,
        ));

        // Deve mostrar como boss mesmo sendo atual e visitada
        expect(find.byIcon(Icons.warning), findsOneWidget);
        expect(find.text('BOSS'), findsOneWidget);
      });
    });
  });
} 