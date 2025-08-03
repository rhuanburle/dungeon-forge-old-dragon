// presentation/shared/widgets/navigable_room_card.dart

import 'package:flutter/material.dart';
import '../../../models/room.dart';
import '../../../theme/app_colors.dart';

/// Widget para sala com sistema de navegação visual
class NavigableRoomCard extends StatelessWidget {
  final Room room;
  final bool isCurrentRoom;
  final bool isVisited;
  final VoidCallback? onRoomTap;
  final VoidCallback? onNavigationTap;
  final bool isEntrance;
  final bool isBoss;

  const NavigableRoomCard({
    super.key,
    required this.room,
    required this.isCurrentRoom,
    required this.isVisited,
    this.onRoomTap,
    this.onNavigationTap,
    this.isEntrance = false,
    this.isBoss = false,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = const Color(0xFF3a3a3a);
    Color borderColor = AppColors.primaryLight;
    Color headerColor = AppColors.primaryLight;
    IconData roomIcon = Icons.room;

    // Define cores baseadas no estado da sala
    if (isEntrance) {
      cardColor = const Color(0xFF4a3a2a);
      borderColor = AppColors.primary;
      headerColor = AppColors.primary;
      roomIcon = Icons.input;
    } else if (isBoss) {
      cardColor = const Color(0xFF3a2a2a);
      borderColor = AppColors.error;
      headerColor = AppColors.error;
      roomIcon = Icons.warning;
    } else if (isCurrentRoom) {
      // Sala atual - destaque especial
      cardColor = const Color(0xFF2a4a3a);
      borderColor = Colors.green;
      headerColor = Colors.green;
      roomIcon = Icons.my_location;
    } else if (isVisited) {
      // Sala visitada - cor diferente
      cardColor = const Color(0xFF3a3a4a);
      borderColor = Colors.blue;
      headerColor = Colors.blue;
      roomIcon = Icons.check_circle;
    }

    return GestureDetector(
      onTap: onRoomTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(roomIcon, color: headerColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sala ${room.index}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: headerColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Indicador de navegação (checkbox)
                  GestureDetector(
                    onTap: onNavigationTap,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCurrentRoom
                            ? Colors.green
                            : isVisited
                            ? Colors.blue
                            : Colors.grey[600]!,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isCurrentRoom
                              ? Colors.green
                              : isVisited
                              ? Colors.blue
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        isCurrentRoom
                            ? Icons.my_location
                            : isVisited
                            ? Icons.check
                            : Icons.radio_button_unchecked,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Labels especiais
                  if (isEntrance)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: const Text(
                        'ENTRADA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (isBoss)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: const Text(
                        'BOSS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informações básicas da sala
                      if (room.air.isNotEmpty && room.air != 'Sem corrente de ar')
                        _buildRoomProperty('Ar', room.air, Icons.air),
                      if (room.smell.isNotEmpty &&
                          room.smell != 'Sem cheiro especial')
                        _buildRoomProperty('Cheiro', room.smell, Icons.air),
                      if (room.sound.isNotEmpty &&
                          room.sound != 'Nenhum som especial')
                        _buildRoomProperty('Som', room.sound, Icons.volume_up),
                      if (room.item.isNotEmpty &&
                          room.item != 'Completamente vazia')
                        _buildRoomProperty('Itens', room.item, Icons.inventory),
                      if (room.specialItem.isNotEmpty && room.specialItem != '—')
                        _buildRoomProperty(
                          'Itens Especiais',
                          room.specialItem,
                          Icons.star,
                        ),
                      if (room.monster1.isNotEmpty && room.monster1 != '—')
                        _buildRoomProperty('Monstro 1', room.monster1, Icons.pets),
                      if (room.monster2.isNotEmpty && room.monster2 != '—')
                        _buildRoomProperty('Monstro 2', room.monster2, Icons.pets),
                      if (room.trap.isNotEmpty && room.trap != '—')
                        _buildRoomProperty('Armadilha', room.trap, Icons.warning),
                      if (room.specialTrap.isNotEmpty && room.specialTrap != '—')
                        _buildRoomProperty(
                          'Armadilha Especial',
                          room.specialTrap,
                          Icons.warning,
                        ),
                      if (room.roomCommon.isNotEmpty && room.roomCommon != '—')
                        _buildRoomProperty(
                          'Sala Comum',
                          room.roomCommon,
                          Icons.home,
                        ),
                      if (room.roomSpecial.isNotEmpty && room.roomSpecial != '—')
                        _buildRoomProperty(
                          'Sala Especial',
                          room.roomSpecial,
                          Icons.architecture,
                        ),
                      if (room.roomSpecial2.isNotEmpty && room.roomSpecial2 != '—')
                        _buildRoomProperty(
                          'Sala Especial 2',
                          room.roomSpecial2,
                          Icons.castle,
                        ),
                      if (room.treasure.isNotEmpty &&
                          room.treasure != 'Nenhum' &&
                          room.treasure != 'Nenhum Tesouro')
                        _buildRoomProperty('Tesouro', room.treasure, Icons.diamond),
                      if (room.specialTreasure.isNotEmpty &&
                          room.specialTreasure != '—')
                        _buildRoomProperty(
                          'Tesouro Especial',
                          room.specialTreasure,
                          Icons.diamond,
                        ),
                      if (room.magicItem.isNotEmpty && room.magicItem != '—')
                        _buildRoomProperty(
                          'Item Mágico',
                          room.magicItem,
                          Icons.psychology,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: headerColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: headerColor.withOpacity(0.3)),
                ),
                child: Text(
                  isCurrentRoom
                      ? 'Sala Atual'
                      : isVisited
                      ? 'Sala Visitada'
                      : 'Clique para mais detalhes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: headerColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomProperty(String label, String value, IconData icon) {
    if (value.isEmpty ||
        value == 'Nenhum som especial' ||
        value == 'Sem cheiro especial') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 12, color: AppColors.primaryLight),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
                SelectableText(
                  value.length > 35 ? '${value.substring(0, 35)}...' : value,
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
