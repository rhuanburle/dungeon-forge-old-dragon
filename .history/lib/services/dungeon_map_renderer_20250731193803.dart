// services/dungeon_map_renderer.dart

import 'dart:math';

import '../models/dungeon.dart';
import '../models/room_position.dart';

/// Renderiza mapa estilo Old School com linhas pretas e hachuras.
/// Cada sala tem um número (Key) e o estilo é monocromático.
class DungeonMapRenderer {
  static const _gridSize = 100; // Reduzido para melhor visualização
  static const _empty = ' ';
  static const _wall = '#';
  static const _floor = '.';
  static const _door = '+';
  static const _entry = 'E';
  static const _boss = 'B';

  final _rand = Random();

  /// Gera posições das salas usando Containers simples.
  Map<String, dynamic> buildGridWithPositions(Dungeon dungeon) {
    final roomPositions = <RoomPosition>[];

    // Sala inicial (entrada) no centro
    final firstW = _randRange(6, 12);
    final firstH = _randRange(4, 8);
    final startX = 50 - (firstW ~/ 2);
    final startY = 50 - (firstH ~/ 2);

    roomPositions.add(RoomPosition(
      x: startX,
      y: startY,
      width: firstW,
      height: firstH,
      room: dungeon.rooms[0],
      isEntry: true,
    ));

    // Gera posições para as outras salas
    for (int i = 1; i < dungeon.roomsCount; i++) {
      final w = _randRange(5, 10);
      final h = _randRange(3, 7);

      // Posiciona salas em uma grade simples
      final row = (i - 1) ~/ 3;
      final col = (i - 1) % 3;

      final x = startX + (col * 15) + _randRange(-5, 5);
      final y = startY + (row * 12) + _randRange(-3, 3);

      roomPositions.add(RoomPosition(
        x: x,
        y: y,
        width: w,
        height: h,
        room: dungeon.rooms[i],
      ));
    }

    // Marca a última sala como chefe
    if (roomPositions.isNotEmpty) {
      roomPositions.last.isBoss = true;
    }

    return {
      'grid': <List<String>>[], // Grid vazio - não usado mais
      'roomPositions': roomPositions,
    };
  }

  /// Converte grid em string multi-linha para debug ASCII
  String gridToAscii(List<List<String>> grid) =>
      grid.map((row) => row.join()).join('\n');

  /// Método legado para compatibilidade
  List<List<String>> buildGrid(Dungeon dungeon) {
    final result = buildGridWithPositions(dungeon);
    return result['grid'] as List<List<String>>;
  }

  //////////////////////////////////////////////////////////

  int _randRange(int min, int max) => min + _rand.nextInt(max - min + 1);

  bool _canPlaceRoom(List<List<String>> grid, int x, int y, int w, int h) {
    if (x < 0 || y < 0 || x + w >= _gridSize || y + h >= _gridSize) {
      return false;
    }

    // Verifica se há sobreposição com outras salas
    for (int i = y; i < y + h; i++) {
      for (int j = x; j < x + w; j++) {
        final cell = grid[i][j];
        // Permite colocar sobre pisos existentes, mas não sobre paredes
        if (cell == _wall) {
          return false;
        }
      }
    }

    return true;
  }

  void _placeRoomOldSchool(
      List<List<String>> grid, int x, int y, int w, int h, int roomNumber) {
    // Simplifica para retângulos - mais confiável
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        final gx = x + j;
        final gy = y + i;

        if (i == 0 || i == h - 1 || j == 0 || j == w - 1) {
          grid[gy][gx] = _wall;
        } else {
          grid[gy][gx] = _floor;
        }
      }
    }

    // Adiciona número da sala no centro
    final centerX = x + w ~/ 2;
    final centerY = y + h ~/ 2;
    if (centerY < _gridSize && centerX < _gridSize) {
      grid[centerY][centerX] = roomNumber.toString();
    }
  }

  void _connectOldSchool(List<List<String>> grid, Point<int> a, Point<int> b) {
    // Conecta com linha reta L-shaped (horizontal + vertical)
    final path = <Point<int>>[];

    // Primeiro horizontal
    int x1 = a.x;
    int x2 = b.x;
    int y = a.y;
    if (x2 < x1) {
      final tmp = x1;
      x1 = x2;
      x2 = tmp;
    }
    for (int x = x1; x <= x2; x++) {
      path.add(Point(x, y));
    }

    // Depois vertical
    int y1 = a.y;
    int y2 = b.y;
    int x = b.x;
    if (y2 < y1) {
      final tmp = y1;
      y1 = y2;
      y2 = tmp;
    }
    for (int yy = y1; yy <= y2; yy++) {
      path.add(Point(x, yy));
    }

    // Remove duplicatas e desenha o caminho
    final uniquePath = path.toSet().toList();
    for (final point in uniquePath) {
      _carveFloor(grid, point.x, point.y);
    }
  }

  void _carveFloor(List<List<String>> grid, int x, int y) {
    if (grid[y][x] == _empty) {
      grid[y][x] = _floor;
    } else if (grid[y][x] == _wall) {
      grid[y][x] = _door;
    }
  }
}
