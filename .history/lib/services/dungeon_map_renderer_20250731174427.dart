// services/dungeon_map_renderer.dart

import 'dart:math';

import '../models/dungeon.dart';
import '../models/room_position.dart';

/// Renderiza mapa estilo Old School com linhas pretas e hachuras.
/// Cada sala tem um número (Key) e o estilo é monocromático.
class DungeonMapRenderer {
  static const _gridSize = 120;
  static const _empty = ' ';
  static const _wall = '#';
  static const _floor = '.';
  static const _door = '+';
  static const _entry = 'E';
  static const _boss = 'B';

  final _rand = Random();

  /// Gera grid de caracteres e retorna posições das salas.
  Map<String, dynamic> buildGridWithPositions(Dungeon dungeon) {
    // grid inicialmente vazio
    final grid =
        List.generate(_gridSize, (_) => List.filled(_gridSize, _empty));

    // Centros já posicionados
    final centres = <Point<int>>[];
    final roomPositions = <RoomPosition>[];

    // Parametrização de tamanhos - salas menores para mais conexões
    const minW = 6;
    const maxW = 12;
    const minH = 4;
    const maxH = 8;

    // 1ª sala no centro → será a ENTRADA
    final firstW = _randRange(minW, maxW);
    final firstH = _randRange(minH, maxH);
    final startX = (_gridSize ~/ 2) - (firstW ~/ 2);
    final startY = (_gridSize ~/ 2) - (firstH ~/ 2);
    _placeRoomOldSchool(grid, startX, startY, firstW, firstH, 1);
    final entryCentre = Point(startX + firstW ~/ 2, startY + firstH ~/ 2);
    centres.add(entryCentre);

    // Adiciona posição da entrada
    roomPositions.add(RoomPosition(
      x: startX,
      y: startY,
      width: firstW,
      height: firstH,
      room: dungeon.rooms[0],
      isEntry: true,
    ));

        // Demais salas - algoritmo simplificado
    for (int i = 1; i < dungeon.roomsCount; i++) {
      bool placed = false;
      for (int attempt = 0; attempt < 100 && !placed; attempt++) {
        // Escolhe uma sala de referência
        final ref = centres[_rand.nextInt(centres.length)];
        
        // Escolhe direção simples
        final dir = _rand.nextInt(4);
        final w = _randRange(minW, maxW);
        final h = _randRange(minH, maxH);
        
        int x = ref.x;
        int y = ref.y;
        
        // Posicionamento simples
        switch (dir) {
          case 0: // up
            x -= w ~/ 2;
            y -= (h + 3);
            break;
          case 1: // down
            x -= w ~/ 2;
            y += 3;
            break;
          case 2: // left
            x -= (w + 3);
            y -= h ~/ 2;
            break;
          case 3: // right
            x += 3;
            y -= h ~/ 2;
            break;
        }
        
        if (_canPlaceRoom(grid, x, y, w, h)) {
          _placeRoomOldSchool(grid, x, y, w, h, i + 1);
          final centre = Point(x + w ~/ 2, y + h ~/ 2);
          _connectOldSchool(grid, ref, centre);
          centres.add(centre);

          // Adiciona posição da sala
          roomPositions.add(RoomPosition(
            x: x,
            y: y,
            width: w,
            height: h,
            room: dungeon.rooms[i],
          ));

          placed = true;
        }
      }
    }

    // Debug: verifica quantas salas foram colocadas
    print('Total de salas colocadas: ${roomPositions.length}');
    
    // Marcar entrada e chefe
    final bossCentre = centres.last;
    grid[entryCentre.y][entryCentre.x] = _entry;
    grid[bossCentre.y][bossCentre.x] = _boss;

    // Marca a última sala como chefe
    if (roomPositions.isNotEmpty) {
      roomPositions.last.isBoss = true;
    }

    return {
      'grid': grid,
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
    // Verifica apenas se a área da sala está livre (mais permissivo)
    for (int i = y; i < y + h; i++) {
      for (int j = x; j < x + w; j++) {
        if (grid[i][j] != _empty && grid[i][j] != _floor) {
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
