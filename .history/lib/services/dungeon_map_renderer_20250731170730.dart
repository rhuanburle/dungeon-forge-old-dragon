// services/dungeon_map_renderer.dart

import 'dart:math';

import '../models/dungeon.dart';
import '../models/room_position.dart';

/// Produz um mapa em grid semelhante aos desenhos "old-school".
/// Cada célula comporta um caractere indicando tipo de tile.
/// Símbolos:
///   ' ' vazio (rocha)
///   '#' parede
///   '.' piso/corredor
///   '+' porta
///   'E' entrada
///   'B' sala principal / chefe
class DungeonMapRenderer {
  static const _gridSize = 120;
  static const _empty = ' ';
  static const _wall = '#';
  static const _floor = '.';
  static const _door = '+';
  static const _entry = 'E';
  static const _boss = 'B';

  final _rand = Random();

  /// Gera grid de caracteres.
  List<List<String>> buildGrid(Dungeon dungeon) {
    // grid inicialmente vazio
    final grid =
        List.generate(_gridSize, (_) => List.filled(_gridSize, _empty));

    // Centros já posicionados
    final centres = <Point<int>>[];

    // Parametrização de tamanhos
    const minW = 8;
    const maxW = 15;
    const minH = 5;
    const maxH = 10;

    // 1ª sala no centro → será a ENTRADA
    final firstW = _randRange(minW, maxW);
    final firstH = _randRange(minH, maxH);
    final startX = (_gridSize ~/ 2) - (firstW ~/ 2);
    final startY = (_gridSize ~/ 2) - (firstH ~/ 2);
    _placeRoom(grid, startX, startY, firstW, firstH);
    final entryCentre = Point(startX + firstW ~/ 2, startY + firstH ~/ 2);
    centres.add(entryCentre);

    // Demais salas
    for (int i = 1; i < dungeon.roomsCount; i++) {
      bool placed = false;
      for (int attempt = 0; attempt < 60 && !placed; attempt++) {
        final ref = centres[_rand.nextInt(centres.length)];
        final dir = _rand.nextInt(4);
        final w = _randRange(minW, maxW);
        final h = _randRange(minH, maxH);
        int x = ref.x;
        int y = ref.y;
        switch (dir) {
          case 0: // up
            x -= w ~/ 2;
            y -= (h + 4);
            break;
          case 1: // down
            x -= w ~/ 2;
            y += 4;
            break;
          case 2: // left
            x -= (w + 4);
            y -= h ~/ 2;
            break;
          case 3: // right
            x += 4;
            y -= h ~/ 2;
            break;
        }
        if (_canPlaceRoom(grid, x, y, w, h)) {
          _placeRoom(grid, x, y, w, h);
          final centre = Point(x + w ~/ 2, y + h ~/ 2);
          _connect(grid, ref, centre);
          centres.add(centre);
          placed = true;
        }
      }
    }

    // Marcar entrada e chefe
    final bossCentre = centres.last;
    grid[entryCentre.y][entryCentre.x] = _entry;
    grid[bossCentre.y][bossCentre.x] = _boss;

    return grid;
  }

  /// Converte grid em string multi-linha para debug ASCII
  String gridToAscii(List<List<String>> grid) =>
      grid.map((row) => row.join()).join('\n');

  //////////////////////////////////////////////////////////

  int _randRange(int min, int max) => min + _rand.nextInt(max - min + 1);

  bool _canPlaceRoom(List<List<String>> grid, int x, int y, int w, int h) {
    if (x < 1 || y < 1 || x + w + 1 >= _gridSize || y + h + 1 >= _gridSize) {
      return false;
    }
    for (int i = y - 1; i <= y + h + 1; i++) {
      for (int j = x - 1; j <= x + w + 1; j++) {
        if (grid[i][j] != _empty) return false;
      }
    }
    return true;
  }

  void _placeRoom(List<List<String>> grid, int x, int y, int w, int h) {
    // Escolhe formato: 0 = retângulo, 1 = cruz, 2 = diamante
    final shape = _rand.nextInt(3);

    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        final gx = x + j;
        final gy = y + i;

        bool inside;
        switch (shape) {
          case 1: // cruz – mantém somente + vertical/horizontal
            inside = (i == h ~/ 2 || j == w ~/ 2);
            break;
          case 2: // diamante (|x-centre| + |y-centre| < diag)
            final cx = w / 2.0;
            final cy = h / 2.0;
            inside = ((j - cx).abs() + (i - cy).abs()) < (min(w, h) / 2);
            break;
          default: // retângulo cheio
            inside = true;
        }

        if (!inside) continue;

        if (i == 0 || i == h - 1 || j == 0 || j == w - 1) {
          grid[gy][gx] = _wall;
        } else {
          grid[gy][gx] = _floor;
        }
      }
    }
  }

  void _connect(List<List<String>> grid, Point<int> a, Point<int> b) {
    // horizontal
    int x1 = a.x;
    int x2 = b.x;
    int y = a.y;
    if (x2 < x1) {
      final tmp = x1;
      x1 = x2;
      x2 = tmp;
    }
    for (int x = x1; x <= x2; x++) {
      _carveFloor(grid, x, y);
    }
    // vertical
    int y1 = a.y;
    int y2 = b.y;
    int x = b.x;
    if (y2 < y1) {
      final tmp = y1;
      y1 = y2;
      y2 = tmp;
    }
    for (int yy = y1; yy <= y2; yy++) {
      _carveFloor(grid, x, yy);
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
