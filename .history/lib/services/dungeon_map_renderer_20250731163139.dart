// services/dungeon_map_renderer.dart

import 'dart:math';

import '../models/dungeon.dart';

/// Produz um mapa ASCII "Old School" de uma masmorra.
/// A abordagem é simplificada: posiciona retângulos que representam salas
/// em um grid e cria corredores em linha reta entre centros sucessivos.
class DungeonMapRenderer {
  static const _gridSize = 60;
  static const _empty = ' ';
  static const _wall = '#';
  static const _floor = '.';
  static const _door = '+';

  final _grid = List.generate(_gridSize, (_) => List.filled(_gridSize, _empty));
  final _rand = Random();

  String render(Dungeon dungeon) {
    // Lista de centros das salas já posicionadas.
    final centres = <Point<int>>[];

    // Parâmetros de tamanho de sala.
    const minW = 5;
    const maxW = 9;
    const minH = 3;
    const maxH = 5;

    // Coloque a primeira sala no centro.
    final firstW = _randRange(minW, maxW);
    final firstH = _randRange(minH, maxH);
    final startX = (_gridSize / 2).floor() - (firstW ~/ 2);
    final startY = (_gridSize / 2).floor() - (firstH ~/ 2);
    _placeRoom(startX, startY, firstW, firstH);
    centres.add(Point(startX + firstW ~/ 2, startY + firstH ~/ 2));

    // Demais salas.
    for (int i = 1; i < dungeon.roomsCount; i++) {
      // Tente posicionar até N vezes para evitar sobreposição.
      bool placed = false;
      for (int attempt = 0; attempt < 50 && !placed; attempt++) {
        final ref = centres[_rand.nextInt(centres.length)];
        // Direção aleatória.
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
        if (_canPlaceRoom(x, y, w, h)) {
          _placeRoom(x, y, w, h);
          final centre = Point(x + w ~/ 2, y + h ~/ 2);
          _connect(ref, centre);
          centres.add(centre);
          placed = true;
        }
      }
    }

    // Converte grid para string.
    final buffer = StringBuffer();
    for (final row in _grid) {
      buffer.writeln(row.join());
    }
    return buffer.toString();
  }

  //////////////// helpers //////////////////

  int _randRange(int min, int max) => min + _rand.nextInt(max - min + 1);

  bool _canPlaceRoom(int x, int y, int w, int h) {
    if (x < 1 || y < 1 || x + w + 1 >= _gridSize || y + h + 1 >= _gridSize) {
      return false;
    }
    for (int i = y - 1; i <= y + h + 1; i++) {
      for (int j = x - 1; j <= x + w + 1; j++) {
        if (_grid[i][j] != _empty) return false;
      }
    }
    return true;
  }

  void _placeRoom(int x, int y, int w, int h) {
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        final gx = x + j;
        final gy = y + i;
        // Paredes nas bordas, piso dentro.
        if (i == 0 || i == h - 1 || j == 0 || j == w - 1) {
          _grid[gy][gx] = _wall;
        } else {
          _grid[gy][gx] = _floor;
        }
      }
    }
  }

  void _connect(Point<int> a, Point<int> b) {
    // Carve horizontal.
    int x1 = a.x;
    int x2 = b.x;
    int y = a.y;
    if (x2 < x1) {
      final tmp = x1;
      x1 = x2;
      x2 = tmp;
    }
    for (int x = x1; x <= x2; x++) {
      _carveFloor(x, y);
    }
    // Carve vertical.
    int y1 = a.y;
    int y2 = b.y;
    int x = b.x;
    if (y2 < y1) {
      final tmp = y1;
      y1 = y2;
      y2 = tmp;
    }
    for (int yy = y1; yy <= y2; yy++) {
      _carveFloor(x, yy);
    }
  }

  void _carveFloor(int x, int y) {
    if (_grid[y][x] == _empty) {
      _grid[y][x] = _floor;
    } else if (_grid[y][x] == _wall) {
      _grid[y][x] = _door; // porta onde corredor rompe parede
    }
  }
}
