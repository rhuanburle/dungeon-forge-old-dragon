// presentation/shared/widgets/dungeon_grid_widget.dart

import 'package:flutter/material.dart';
import '../../../models/room_position.dart';

class DungeonGridWidget extends StatefulWidget {
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
  State<DungeonGridWidget> createState() => _DungeonGridWidgetState();
}

class _DungeonGridWidgetState extends State<DungeonGridWidget> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset? _startingFocalPoint;
  double? _startingScale;
  Offset? _startingOffset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _startingFocalPoint = details.focalPoint;
        _startingScale = _scale;
        _startingOffset = _offset;
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = (_startingScale ?? _scale) * details.scale;
          _scale = _scale.clamp(0.5, 3.0);
          if (details.focalPointDelta != Offset.zero) {
            _offset = (_startingOffset ?? _offset) + details.focalPointDelta;
          }
        });
      },
      onScaleEnd: (details) {
        _startingFocalPoint = null;
        _startingScale = null;
        _startingOffset = null;
      },
      child: Center(
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
          child: Container(
            width: 600,
            height: 500,
            color: Colors.grey.shade100,
            child: Stack(
              children: [
                // Corredores (linhas pretas)
                ..._buildCorridors(),
                // Salas como Containers simples
                ...widget.roomPositions.map((room) => Positioned(
                      left: room.x.toDouble(),
                      top: room.y.toDouble(),
                      child: GestureDetector(
                        onTap: () => widget.onRoomTap?.call(room),
                        child: Container(
                          width: room.width.toDouble(),
                          height: room.height.toDouble(),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 4.0, // Borda grossa para parede
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 3,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: room.isEntry
                                    ? Colors.amber.shade400
                                    : room.isBoss
                                        ? Colors.red.shade400
                                        : Colors.blue.shade400,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '${room.room.index}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir corredores
  List<Widget> _buildCorridors() {
    // Por enquanto, retorna lista vazia
    // TODO: Implementar corredores quando o renderer retornar os dados
    return [];
  }
}
