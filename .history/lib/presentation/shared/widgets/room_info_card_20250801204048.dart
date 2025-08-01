// presentation/shared/widgets/room_info_card.dart

import 'package:flutter/material.dart';
import '../../../models/room.dart';
import 'responsive_layout.dart';

/// Widget reutilizável para exibir informações de uma sala
class RoomInfoCard extends StatelessWidget {
  final Room room;
  final VoidCallback? onTap;
  final bool showDetails;

  const RoomInfoCard({
    super.key,
    required this.room,
    this.onTap,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ResponsiveScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                if (showDetails) ...[
                  const SizedBox(height: 8),
                  _buildEnvironmentInfo(context),
                  const SizedBox(height: 8),
                  _buildContentInfo(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getTypeColor(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Sala ${room.index}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            room.type,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 14,
          ),
      ],
    );
  }

  Widget _buildEnvironmentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (room.air.isNotEmpty) _buildInfoRow('Ar', room.air),
        if (room.smell.isNotEmpty) _buildInfoRow('Cheiro', room.smell),
        if (room.sound.isNotEmpty) _buildInfoRow('Som', room.sound),
        if (room.item.isNotEmpty) _buildInfoRow('Itens', room.item),
        if (room.specialItem.isNotEmpty)
          _buildInfoRow('Itens Especiais', room.specialItem),
      ],
    );
  }

  Widget _buildContentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (room.monster1.isNotEmpty || room.monster2.isNotEmpty)
          _buildMonsterInfo(context),
        if (room.trap.isNotEmpty || room.specialTrap.isNotEmpty)
          _buildTrapInfo(context),
        if (room.treasure.isNotEmpty && room.treasure != 'Nenhum')
          _buildTreasureInfo(context),
      ],
    );
  }

  Widget _buildMonsterInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Encontros:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
        ),
        if (room.monster1.isNotEmpty) _buildInfoRow('Monstro 1', room.monster1),
        if (room.monster2.isNotEmpty) _buildInfoRow('Monstro 2', room.monster2),
      ],
    );
  }

  Widget _buildTrapInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Armadilhas:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
        ),
        if (room.trap.isNotEmpty) _buildInfoRow('Armadilha', room.trap),
        if (room.specialTrap.isNotEmpty)
          _buildInfoRow('Armadilha Especial', room.specialTrap),
      ],
    );
  }

  Widget _buildTreasureInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tesouro:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.amber[700],
              ),
        ),
        if (room.treasure.isNotEmpty) _buildInfoRow('Tesouro', room.treasure),
        if (room.specialTreasure.isNotEmpty)
          _buildInfoRow('Tesouro Especial', room.specialTreasure),
        if (room.magicItem.isNotEmpty)
          _buildInfoRow('Item Mágico', room.magicItem),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(BuildContext context) {
    if (room.type.contains('Encontro')) {
      return Colors.red;
    } else if (room.type.contains('Armadilha')) {
      return Colors.orange;
    } else if (room.type.contains('Especial')) {
      return Colors.purple;
    } else {
      return Theme.of(context).primaryColor;
    }
  }
}
