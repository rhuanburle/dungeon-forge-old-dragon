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

  @override
  Widget build(BuildContext context) {
    final rows = grid.length;
    final cols = grid.first.length;

    return SizedBox(
      width: cols * cellSize,
      child: Stack(
        children: [
          // Grid base com estilo Old School
          CustomPaint(
            size: Size(cols * cellSize, rows * cellSize),
            painter: OldSchoolDungeonPainter(
              grid: grid,
              cellSize: cellSize,
            ),
          ),
          // Números das salas
          ...roomPositions.map((room) => Positioned(
                left: (room.x + room.width / 2) * cellSize - 10,
                top: (room.y + room.height / 2) * cellSize - 10,
                child: GestureDetector(
                  onTap: () => onRoomTap?.call(room),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: room.isEntry
                          ? Colors.amber.shade400
                          : room.isBoss
                              ? Colors.red.shade400
                              : Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(10),
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
                      size: 12,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class OldSchoolDungeonPainter extends CustomPainter {
  OldSchoolDungeonPainter({
    required this.grid,
    required this.cellSize,
  });

  final List<List<String>> grid;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final wallPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final floorPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;

    final doorPaint = Paint()
      ..color = Colors.brown.shade700
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final textPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final hatchingPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Desenha o grid base
    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[y].length; x++) {
        final char = grid[y][x];
        final rect = Rect.fromLTWH(
          x * cellSize,
          y * cellSize,
          cellSize,
          cellSize,
        );

        switch (char) {
          case '#': // Parede
            canvas.drawRect(rect, wallPaint);
            _drawHatching(canvas, rect, hatchingPaint);
            break;
          case '.': // Piso
            canvas.drawRect(rect, floorPaint);
            break;
          case '+': // Porta
            canvas.drawRect(rect, doorPaint);
            canvas.drawRect(rect, floorPaint);
            break;
          case 'E': // Entrada
            canvas.drawRect(rect, wallPaint);
            canvas.drawRect(rect, floorPaint);
            _drawText(canvas, 'E', rect, textPaint);
            break;
          case 'B': // Chefe
            canvas.drawRect(rect, wallPaint);
            canvas.drawRect(rect, floorPaint);
            _drawText(canvas, 'B', rect, textPaint);
            break;
          default:
            // Números das salas
            if (char != ' ') {
              canvas.drawRect(rect, floorPaint);
              _drawText(canvas, char, rect, textPaint);
            }
        }
      }
    }

    // Desenha grid de fundo
    _drawGrid(canvas, size);
  }

  void _drawHatching(Canvas canvas, Rect rect, Paint paint) {
    const spacing = 4.0;
    for (double i = 0; i < rect.width; i += spacing) {
      canvas.drawLine(
        Offset(rect.left + i, rect.top),
        Offset(rect.left + i, rect.bottom),
        paint,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Rect rect, Paint paint) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: paint.color,
        fontSize: cellSize * 0.6,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        rect.left + (rect.width - textPainter.width) / 2,
        rect.top + (rect.height - textPainter.height) / 2,
      ),
    );
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Linhas verticais
    for (int x = 0; x <= size.width; x += cellSize.toInt()) {
      canvas.drawLine(
        Offset(x.toDouble(), 0),
        Offset(x.toDouble(), size.height),
        gridPaint,
      );
    }

    // Linhas horizontais
    for (int y = 0; y <= size.height; y += cellSize.toInt()) {
      canvas.drawLine(
        Offset(0, y.toDouble()),
        Offset(size.width, y.toDouble()),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
