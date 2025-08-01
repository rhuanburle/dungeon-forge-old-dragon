// presentation/shared/widgets/dungeon_info_card.dart

import 'package:flutter/material.dart';
import '../../../models/dungeon.dart';
import 'responsive_layout.dart';

/// Widget reutilizável para exibir informações da masmorra
class DungeonInfoCard extends StatelessWidget {
  final Dungeon dungeon;
  final VoidCallback? onTap;
  final bool showDetails;

  const DungeonInfoCard({
    super.key,
    required this.dungeon,
    this.onTap,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                if (showDetails) ...[
                  const SizedBox(height: 12),
                  _buildBasicInfo(context),
                  const SizedBox(height: 12),
                  _buildOccupantsInfo(context),
                  const SizedBox(height: 12),
                  _buildRumorInfo(context),
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
        Icon(
          Icons.castle,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dungeon.type,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${dungeon.roomsCount} salas',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
        if (onTap != null)
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 16,
          ),
      ],
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Tipo', dungeon.type),
        _buildInfoRow('Contruido/habitado por', dungeon.builderOrInhabitant),
        _buildInfoRow('Status', dungeon.status),
        _buildInfoRow('Localização', dungeon.location),
        _buildInfoRow('Entrada', dungeon.entry),
        _buildInfoRow('Objetivo', dungeon.objective),
      ],
    );
  }

  Widget _buildOccupantsInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Ocupante I', dungeon.occupant1),
        _buildInfoRow('Ocupante II', dungeon.occupant2),
        _buildInfoRow('Líder', dungeon.leader),
      ],
    );
  }

  Widget _buildRumorInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rumor:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          dungeon.rumor1,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
