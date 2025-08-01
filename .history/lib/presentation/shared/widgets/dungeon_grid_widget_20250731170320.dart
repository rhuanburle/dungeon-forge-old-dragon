// presentation/shared/widgets/dungeon_grid_widget.dart

import 'package:flutter/material.dart';

class DungeonGridWidget extends StatelessWidget {
  const DungeonGridWidget({super.key, required this.grid, this.cellSize = 8});

  final List<List<String>> grid;
  final double cellSize;

  Color _colorForChar(String c) {
    switch (c) {
      case '#':
        return Colors.grey.shade800;
      case '.':
        return Colors.grey.shade400;
      case '+':
        return Colors.brown.shade700;
      case 'E':
        return Colors.yellow;
      case 'B':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = grid.length;
    final cols = grid.first.length;
    return SizedBox(
      width: cols * cellSize,
      child: Column(
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
    );
  }
}
