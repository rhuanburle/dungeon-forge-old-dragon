// presentation/shared/widgets/dungeon_grid_widget.dart

import 'package:flutter/material.dart';
import '../../../models/room_position.dart';

class DungeonGridWidget extends StatelessWidget {
  const DungeonGridWidget({
    super.key,
    required this.grid,
    this.cellSize = 6,
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
        return Colors.grey.shade700;
      case '.':
        return Colors.grey.shade300;
      case '+':
        return Colors.brown.shade600;
      case 'E':
        return Colors.amber.shade400;
      case 'B':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade100;
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
          // Overlay clicável para salas
          if (onRoomTap != null)
            ...roomPositions.map((room) => Positioned(
                  left: room.x * cellSize,
                  top: room.y * cellSize,
                  child: GestureDetector(
                    onTap: () => onRoomTap!(room),
                    child: Container(
                      width: room.width * cellSize,
                      height: room.height * cellSize,
                                           decoration: BoxDecoration(
                       border: Border.all(
                         color: room.isEntry
                             ? Colors.amber.shade600
                             : room.isBoss
                                 ? Colors.red.shade600
                                 : Colors.blue.shade600,
                         width: 2,
                       ),
                       color: room.isEntry
                           ? Colors.amber.withOpacity(0.1)
                           : room.isBoss
                               ? Colors.red.withOpacity(0.1)
                               : Colors.blue.withOpacity(0.1),
                     ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
