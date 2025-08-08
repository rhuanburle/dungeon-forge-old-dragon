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
  DungeonSetup? _setup;

  @override
  void initState() {
    super.initState();
    _rumors = _service.generateRumors();
    _setup = _service.generateDungeonSetupWithRumors();
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
                  Text(
                    _lastOracle!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (_setup != null) ...[
              Text('Tipo de Masmorra: ${_setup!.type}'),
              Text('Entrada: ${_setup!.entrance}'),
              Text('Rolagem (2d6): ${_setup!.typeRoll}'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: _regenSetup,
                    child: const Text('Re-sortear Tipo/Entrada'),
                  ),
                  ElevatedButton(
                    onPressed: _investigate,
                    child: const Text('Testar Investigação (1-2 em 1d6)'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildBoard(),
              const SizedBox(height: 16),
            ],
            const Divider(),
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
    setState(() {
      _rumors = _service.generateRumors();
      _setup = _service.generateDungeonSetupWithRumors();
    });
  }

  void _regenSetup() {
    setState(() => _setup = _service.generateDungeonSetupWithRumors());
  }

  void _investigate() {
    if (_setup == null) return;
    if (_service.rollInvestigationFound()) {
      // determine column and row
      final colRoll = _service.rollD6();
      final rowRoll = _service.rollD6();
      final column = colRoll <= 2
          ? ColumnId.a
          : colRoll <= 4
          ? ColumnId.b
          : ColumnId.c;
      final rowIdx = rowRoll <= 2
          ? 0
          : rowRoll <= 4
          ? 1
          : 2;
      setState(() => _setup!.rumorBoard.eliminate(column, rowIdx));
    } else {
      setState(() {});
    }
  }

  Widget _buildBoard() {
    final board = _setup!.rumorBoard;
    TextStyle cell(bool eliminated) => TextStyle(
      color: eliminated ? AppColors.textSecondary : Colors.white,
      decoration: eliminated ? TextDecoration.lineThrough : TextDecoration.none,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quadro de Rumores (A5.2)'),
        const SizedBox(height: 8),
        // Cabeçalho das colunas
        Row(
          children: [
            const SizedBox(width: 80), // Espaço para rótulo da linha
            Expanded(
              child: Text(
                'A (Criado por...)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                'B (Para...)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                'C (Um(a)...)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Linhas do quadro
        for (int i = 0; i < 3; i++) ...[
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text('Rumor ${i + 1}:', style: TextStyle(fontSize: 12)),
              ),
              Expanded(
                child: Text(
                  board.getRumorAt(i).createdBy,
                  style: cell(board.isEliminated(ColumnId.a, i)),
                ),
              ),
              Expanded(
                child: Text(
                  board.getRumorAt(i).purpose,
                  style: cell(board.isEliminated(ColumnId.b, i)),
                ),
              ),
              Expanded(
                child: Text(
                  board.getRumorAt(i).target,
                  style: cell(board.isEliminated(ColumnId.c, i)),
                ),
              ),
            ],
          ),
          if (i < 2) const Divider(height: 8),
        ],
        const SizedBox(height: 12),
        if (board.hasDiscoveryA)
          Text(
            'Descoberta A: ${board.remainingA}',
            style: const TextStyle(color: Colors.greenAccent),
          ),
        if (board.hasDiscoveryB)
          Text(
            'Descoberta B: ${board.remainingB}',
            style: const TextStyle(color: Colors.greenAccent),
          ),
        if (board.hasDiscoveryC)
          Text(
            'Descoberta C: ${board.remainingC}',
            style: const TextStyle(color: Colors.greenAccent),
          ),
        if (board.isFinalMysteryRevealed)
          const Text(
            'Mistério desvendado! Vá para a Câmara Final.',
            style: TextStyle(color: Colors.amber),
          ),
      ],
    );
  }
}
