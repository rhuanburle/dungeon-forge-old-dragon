import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/solo_dragon/solo_dragon_service.dart';

class SoloDragonPage extends StatefulWidget {
  const SoloDragonPage({super.key});

  @override
  State<SoloDragonPage> createState() => _SoloDragonPageState();
}

class _SoloDragonPageState extends State<SoloDragonPage> {
  final SoloDragonService _service = SoloDragonService();
  List<RumorEntry> _rumors = const [];
  String? _lastOracle;

  @override
  void initState() {
    super.initState();
    _rumors = _service.generateRumors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Solo Dragon', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _rollOracle,
                  child: const Text('Oráculo (1d6)'),
                ),
                const SizedBox(width: 12),
                if (_lastOracle != null)
                  Text(_lastOracle!, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _regenRumors,
                  child: const Text('Sortear Rumores (3x A5.2)'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _rumors.length,
                separatorBuilder: (_, __) => Divider(color: AppColors.border),
                itemBuilder: (context, index) {
                  final r = _rumors[index];
                  return ListTile(
                    title: Text(r.createdBy),
                    subtitle: Text('${r.purpose} ${r.target}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rollOracle() {
    final roll = _service.rollD6();
    setState(() => _lastOracle = SoloDragonService.oracleAnswerFor(roll));
  }

  void _regenRumors() {
    setState(() => _rumors = _service.generateRumors());
  }
}


