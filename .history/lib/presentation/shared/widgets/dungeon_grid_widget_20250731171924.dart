// presentation/shared/widgets/dungeon_grid_widget.dart

import 'package:flutter/material.dart';
import '../../../models/room_position.dart';

class DungeonGridWidget extends StatelessWidget {
  const DungeonGridWidget({
    super.key,
    required this.grid,
    this.cellSize = 8,
    this.roomPositions = const [],
    this.onRoomTap,
  });

  final List<List<String>> grid;
  final double cellSize;
  final List<RoomPosition> roomPositions;
  final Function(RoomPosition)? onRoomTap;

  Color _colorForChar(String c) {
    switch (c) {
      case '#':
        return Colors.grey.shade800;
      case '.':
        return Colors.grey.shade200;
      case '+':
        return Colors.brown.shade700;
      case 'E':
        return Colors.amber.shade500;
      case 'B':
        return Colors.red.shade500;
      default:
        return Colors.grey.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = grid.length;
    final cols = grid.first.length;

    return SizedBox(
      width: cols * cellSize,
      child: Stack(
        children: [
          // Grid base
          Column(
            children: [
              for (int y = 0; y < rows; y++)
                Row(
                  children: [
                    for (int x = 0; x < cols; x++)
                      Container(
                        width: cellSize,
                        height: cellSize,
                        color: _colorForChar(grid[y][x]),
                      ),
                  ],
                ),
            ],
          ),
          // Ícones clicáveis para salas
          if (onRoomTap != null)
            ...roomPositions.map((room) => Positioned(
                  left: (room.x + room.width / 2) * cellSize - 12,
                  top: (room.y + room.height / 2) * cellSize - 12,
                  child: GestureDetector(
                    onTap: () => onRoomTap!(room),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: room.isEntry
                            ? Colors.amber.shade400
                            : room.isBoss
                                ? Colors.red.shade400
                                : Colors.blue.shade400,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        room.isEntry
                            ? Icons.input
                            : room.isBoss
                                ? Icons.warning
                                : Icons.info,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
