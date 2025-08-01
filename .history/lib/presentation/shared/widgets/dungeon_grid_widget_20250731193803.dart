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
            width: 400,
            height: 300,
            color: Colors.grey.shade100,
            child: Stack(
              children: [
                // Salas como Containers simples
                ...widget.roomPositions.map((room) => Positioned(
                      left: room.x * 3.0, // Escala para visualização
                      top: room.y * 3.0,
                      child: GestureDetector(
                        onTap: () => widget.onRoomTap?.call(room),
                        child: Container(
                          width: room.width * 3.0,
                          height: room.height * 3.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 3.0, // Borda grossa para parede
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          child: Center(
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
                              ),
                              child: Center(
                                child: Text(
                                  '${room.room.index}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
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
}
