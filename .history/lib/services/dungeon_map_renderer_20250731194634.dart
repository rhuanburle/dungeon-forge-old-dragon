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

  /// Gera masmorra aleatória com corredores e salas variadas.
  Map<String, dynamic> buildGridWithPositions(Dungeon dungeon) {
    final roomPositions = <RoomPosition>[];
    final corridors = <Map<String, int>>[];

    // Sala inicial (entrada) - sempre no centro
    final entryWidth = _randRange(60, 100);
    final entryHeight = _randRange(40, 80);
    final entryX = 250 - (entryWidth ~/ 2);
    final entryY = 200 - (entryHeight ~/ 2);

    roomPositions.add(RoomPosition(
      x: entryX,
      y: entryY,
      width: entryWidth,
      height: entryHeight,
      room: dungeon.rooms[0],
      isEntry: true,
    ));

    // Gera salas aleatórias conectadas
    final connectedRooms = <RoomPosition>[roomPositions.first];

    for (int i = 1; i < dungeon.roomsCount; i++) {
      // Escolhe uma sala de referência aleatória
      final refRoom = connectedRooms[_rand.nextInt(connectedRooms.length)];

      // Tenta posicionar a nova sala
      bool placed = false;
      int attempts = 0;

      while (!placed && attempts < 50) {
        attempts++;

        // Tamanhos aleatórios para variedade
        final width = _randRange(40, 120);
        final height = _randRange(30, 80);

        // Direção aleatória a partir da sala de referência
        final direction = _rand.nextInt(4);
        int x, y;

        switch (direction) {
          case 0: // Norte
            x = refRoom.x + _randRange(-20, 20);
            y = refRoom.y - height - _randRange(10, 30);
            break;
          case 1: // Sul
            x = refRoom.x + _randRange(-20, 20);
            y = refRoom.y + refRoom.height + _randRange(10, 30);
            break;
          case 2: // Leste
            x = refRoom.x + refRoom.width + _randRange(10, 30);
            y = refRoom.y + _randRange(-20, 20);
            break;
          case 3: // Oeste
            x = refRoom.x - width - _randRange(10, 30);
            y = refRoom.y + _randRange(-20, 20);
            break;
          default:
            x = refRoom.x;
            y = refRoom.y;
        }

        // Verifica se a posição é válida
        if (_isValidPosition(x, y, width, height, roomPositions)) {
          final newRoom = RoomPosition(
            x: x,
            y: y,
            width: width,
            height: height,
            room: dungeon.rooms[i],
          );

          roomPositions.add(newRoom);
          connectedRooms.add(newRoom);

          // Adiciona corredor
          corridors.add({
            'fromX': refRoom.x + (refRoom.width ~/ 2),
            'fromY': refRoom.y + (refRoom.height ~/ 2),
            'toX': x + (width ~/ 2),
            'toY': y + (height ~/ 2),
          });

          placed = true;
        }
      }

      // Se não conseguiu colocar, adiciona em posição aleatória
      if (!placed) {
        final x = _randRange(50, 450);
        final y = _randRange(50, 350);
        final width = _randRange(40, 80);
        final height = _randRange(30, 60);

        roomPositions.add(RoomPosition(
          x: x,
          y: y,
          width: width,
          height: height,
          room: dungeon.rooms[i],
        ));
      }
    }

    // Marca a última sala como chefe
    if (roomPositions.isNotEmpty) {
      roomPositions.last.isBoss = true;
    }

    return {
      'grid': <List<String>>[],
      'roomPositions': roomPositions,
      'corridors': corridors,
    };
  }

  /// Verifica se uma posição é válida (não sobrepõe outras salas)
  bool _isValidPosition(
      int x, int y, int width, int height, List<RoomPosition> existingRooms) {
    // Limites da área
    if (x < 0 || y < 0 || x + width > 600 || y + height > 500) {
      return false;
    }

    // Verifica sobreposição com outras salas
    for (final room in existingRooms) {
      if (x < room.x + room.width &&
          x + width > room.x &&
          y < room.y + room.height &&
          y + height > room.y) {
        return false;
      }
    }

    return true;
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
