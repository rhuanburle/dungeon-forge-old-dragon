// presentation/features/ermos/ermos_page.dart

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/exploration_service.dart';
import '../../../models/exploration.dart';
import '../../../enums/exploration_enums.dart';
import '../../../enums/table_enums.dart';
import '../../../constants/image_path.dart';
import '../../shared/widgets/action_button.dart';

class ErmosPage extends StatefulWidget {
  const ErmosPage({super.key});

  @override
  State<ErmosPage> createState() => _ErmosPageState();
}

class _ErmosPageState extends State<ErmosPage> {
  final ExplorationService _explorationService = ExplorationService();

  // Configurações de exploração
  bool _isWilderness = true;
  bool _useManualSelection = false;
  DiscoveryType? _selectedDiscoveryType;

  // Resultados atuais
  ExplorationResult? _currentResult;
  AncestralDiscovery? _ancestralDiscovery;
  Ruin? _ruin;
  Lair? _lair;
  RiversRoadsIslands? _riversRoadsIslands;
  CastleFort? _castleFort;
  TempleSanctuary? _templeSanctuary;
  NaturalDanger? _naturalDanger;
  Civilization? _civilization;
  // NestCampTribe? _nestCampTribe; // Comentado até implementar o modelo

  // Histórico de explorações
  List<ExplorationResult> _explorationHistory = [];

  @override
  void initState() {
    super.initState();
    _exploreHex();
  }

  void _exploreHex() {
    setState(() {
      // Limpar resultados anteriores
      _clearResults();

      // Gerar nova exploração
      if (_useManualSelection && _selectedDiscoveryType != null) {
        _currentResult = _explorationService.exploreHexWithType(
          _selectedDiscoveryType!,
        );
      } else {
        _currentResult = _explorationService.exploreHex(
          isWilderness: _isWilderness,
        );
      }

      // Se houve descoberta, gerar detalhes completos
      if (_currentResult!.hasDiscovery) {
        _generateDetailedDiscovery();
      }

      // Adicionar ao histórico
      _explorationHistory.insert(0, _currentResult!);
      if (_explorationHistory.length > 10) {
        _explorationHistory.removeLast();
      }
    });
  }

  void _generateDetailedDiscovery() {
    switch (_currentResult!.discoveryType) {
      case DiscoveryType.ancestralDiscoveries:
        _ancestralDiscovery = _explorationService.generateAncestralDiscovery();
        break;
      case DiscoveryType.lairs:
        _lair = _explorationService.generateLair();
        break;
      case DiscoveryType.riversRoadsIslands:
        _riversRoadsIslands = _explorationService.generateRiversRoadsIslands(
          isOcean: false,
          hasRiver: false,
        );
        break;
      case DiscoveryType.castlesForts:
        _castleFort = _explorationService.generateCastleFort();
        break;
      case DiscoveryType.templesSanctuaries:
        _templeSanctuary = _explorationService.generateTempleSanctuary();
        break;
      case DiscoveryType.naturalDangers:
        _naturalDanger = _explorationService.generateNaturalDanger(
          TerrainType.forests,
        );
        break;
      case DiscoveryType.civilization:
        _civilization = _explorationService.generateCivilization();
        break;
      case null:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _clearResults() {
    _ancestralDiscovery = null;
    _ruin = null;
    _lair = null;
    _riversRoadsIslands = null;
    _castleFort = null;
    _templeSanctuary = null;
    _naturalDanger = null;
    _civilization = null;
    // _nestCampTribe = null;
  }

  // Método removido - configurações agora estão na tela principal

  Widget _buildAreaTypeButton(String label, bool isWilderness, bool isMobile) {
    final isSelected = _isWilderness == isWilderness;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _isWilderness = isWilderness;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.selected : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 1)
                : Border.all(color: AppColors.border, width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontSize: isMobile ? 11 : 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildExplorationModeButton(
    String label,
    bool isManual,
    bool isMobile,
  ) {
    final isSelected = _useManualSelection == isManual;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _useManualSelection = isManual;
            _selectedDiscoveryType = null;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.selected : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 1)
                : Border.all(color: AppColors.border, width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontSize: isMobile ? 11 : 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoveryTypeDropdown(bool isMobile) {
    return DropdownButtonFormField<DiscoveryType>(
      value: _selectedDiscoveryType,
      decoration: InputDecoration(
        labelText: 'Selecione o tipo de descoberta',
        labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: isMobile ? 12 : 16,
        ),
      ),
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      items: DiscoveryType.values.map((type) {
        return DropdownMenuItem<DiscoveryType>(
          value: type,
          child: Text(
            type.description,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDiscoveryType = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Selecione um tipo de descoberta';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 16),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.forest, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Exploração dos Ermos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Configurações agora estão na tela principal
                  IconButton(
                    icon: Icon(Icons.refresh, color: AppColors.primary),
                    tooltip: 'Explorar Novo Hex',
                    onPressed: _exploreHex,
                  ),
                  IconButton(
                    icon: Icon(Icons.history, color: AppColors.primary),
                    tooltip: 'Limpar Histórico',
                    onPressed: () {
                      setState(() {
                        _explorationHistory.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Conteúdo principal
            Expanded(
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Painel de Configuração e Histórico - 40%
        Expanded(flex: 4, child: _buildConfigurationPanel()),
        const SizedBox(width: 16),
        // Painel de Resultado - 60%
        Expanded(flex: 6, child: _buildResultPanel()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Painel de Configuração
        Expanded(flex: 1, child: _buildConfigurationPanel()),
        const SizedBox(height: 16),
        // Painel de Resultado
        Expanded(flex: 2, child: _buildResultPanel()),
      ],
    );
  }

  Widget _buildConfigurationPanel() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Configurações de exploração
          _buildExplorationSettingsCard(),
          const SizedBox(height: 16),
          // Configurações atuais
          _buildCurrentSettingsCard(),
          const SizedBox(height: 16),
          // Histórico de explorações
          _buildExplorationHistoryCard(),
        ],
      ),
    );
  }

  Widget _buildExplorationSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Configurações de Exploração',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tipo de área
          Text(
            'Tipo de Área:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildAreaTypeButton('Selvagem', true, false)),
              const SizedBox(width: 8),
              Expanded(child: _buildAreaTypeButton('Civilizada', false, false)),
            ],
          ),
          const SizedBox(height: 16),

          // Modo de exploração
          Text(
            'Modo de Exploração:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildExplorationModeButton('Aleatório', false, false),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildExplorationModeButton('Manual', true, false),
              ),
            ],
          ),

          if (_useManualSelection) ...[
            const SizedBox(height: 16),
            Text(
              'Tipo de Descoberta:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryLight,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            _buildDiscoveryTypeDropdown(false),
            const SizedBox(height: 8),
            if (_selectedDiscoveryType != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primaryDark),
                ),
                child: Text(
                  'Selecionado: ${_selectedDiscoveryType!.description}',
                  style: TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],

          const SizedBox(height: 16),

          // Dicas
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: AppColors.primaryLight, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Dicas:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '• Selvagem: 1 chance em 1d6 de descobrir algo\n'
                  '• Civilizada: 1 chance em 1d8 de descobrir algo\n'
                  '• Aleatório: Tipo de descoberta determinado pelos dados\n'
                  '• Manual: Escolha o tipo específico de descoberta\n'
                  '• Todas as descobertas são automaticamente detalhadas',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Configurações Atuais',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Tipo de Área',
            _isWilderness ? 'Selvagem' : 'Civilizada',
          ),
          _buildInfoRow(
            'Modo de Exploração',
            _useManualSelection
                ? 'Manual (Seleção Específica)'
                : 'Aleatório (Determinado pelos Dados)',
          ),
          if (_useManualSelection && _selectedDiscoveryType != null)
            _buildInfoRow(
              'Tipo Escolhido',
              _selectedDiscoveryType!.description,
            ),
          _buildInfoRow(
            'Chance de Descoberta',
            _isWilderness ? '1 em 1d6' : '1 em 1d8',
          ),
        ],
      ),
    );
  }

  Widget _buildExplorationHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Histórico de Explorações',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_explorationHistory.isEmpty)
            Text(
              'Nenhuma exploração realizada ainda.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ..._explorationHistory
                .take(5)
                .map((result) => _buildHistoryItem(result)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(ExplorationResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            result.hasDiscovery ? Icons.explore : Icons.clear,
            color: result.hasDiscovery
                ? AppColors.primary
                : AppColors.textSecondary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              result.hasDiscovery
                  ? result.discoveryType?.description ?? 'Descoberta'
                  : 'Nada encontrado',
              style: TextStyle(
                color: result.hasDiscovery
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                ImagePath.treasure,
                width: 24,
                height: 24,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 8),
              const Text(
                'Resultado da Exploração',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.primary),
          Expanded(
            child: _currentResult == null
                ? _buildEmptyState()
                : _buildExplorationResult(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Clique em "Explorar Hex" para começar',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildExplorationResult() {
    if (!_currentResult!.hasDiscovery) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.clear, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Nada foi descoberto nesta exploração.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente explorar outro hex.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho da descoberta
          _buildDiscoveryHeader(),
          const SizedBox(height: 16),
          // Detalhes específicos da descoberta
          _buildDiscoveryDetails(),
        ],
      ),
    );
  }

  Widget _buildDiscoveryHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getDiscoveryIcon(_currentResult!.discoveryType!),
                color: AppColors.primaryLight,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _currentResult!.discoveryType!.description,
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _currentResult!.description,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  IconData _getDiscoveryIcon(DiscoveryType type) {
    switch (type) {
      case DiscoveryType.ancestralDiscoveries:
        return Icons.auto_awesome;
      case DiscoveryType.lairs:
        return Icons.home;
      case DiscoveryType.riversRoadsIslands:
        return Icons.water;
      case DiscoveryType.castlesForts:
        return Icons.fort;
      case DiscoveryType.templesSanctuaries:
        return Icons.temple_buddhist;
      case DiscoveryType.naturalDangers:
        return Icons.warning;
      case DiscoveryType.civilization:
        return Icons.location_city;
    }
  }

  Widget _buildDiscoveryDetails() {
    switch (_currentResult!.discoveryType) {
      case DiscoveryType.ancestralDiscoveries:
        return _buildAncestralDetails();
      case DiscoveryType.lairs:
        return _buildLairDetails();
      case DiscoveryType.riversRoadsIslands:
        return _buildRiversRoadsIslandsDetails();
      case DiscoveryType.castlesForts:
        return _buildCastleFortDetails();
      case DiscoveryType.templesSanctuaries:
        return _buildTempleSanctuaryDetails();
      case DiscoveryType.naturalDangers:
        return _buildNaturalDangerDetails();
      case DiscoveryType.civilization:
        return _buildCivilizationDetails();
      case null:
        throw UnimplementedError();
    }
  }

  Widget _buildAncestralDetails() {
    if (_ancestralDiscovery == null) return _buildLoadingPlaceholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailSection('Tipo', _ancestralDiscovery!.type.description),
        _buildDetailSection(
          'Condição',
          _ancestralDiscovery!.condition.description,
        ),
        _buildDetailSection(
          'Material',
          _ancestralDiscovery!.material.description,
        ),
        _buildDetailSection('Estado', _ancestralDiscovery!.state.description),
        _buildDetailSection(
          'Guardião',
          _ancestralDiscovery!.guardian.description,
        ),
        const SizedBox(height: 16),
        _buildDetailSection('Descrição', _ancestralDiscovery!.description),
        const SizedBox(height: 8),
        _buildDetailSection('Detalhes', _ancestralDiscovery!.details),
      ],
    );
  }

  Widget _buildRuinDetails() {
    if (_ruin == null) return _buildLoadingPlaceholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailSection('Tipo', _ruin!.type.description),
        _buildDetailSection('Tamanho', _ruin!.size),
        _buildDetailSection('Defesas', _ruin!.defenses),
        const SizedBox(height: 16),
        _buildDetailSection('Descrição', _ruin!.description),
        const SizedBox(height: 8),
        _buildDetailSection('Detalhes', _ruin!.details),
      ],
    );
  }

  Widget _buildLairDetails() {
    if (_lair == null) return _buildLoadingPlaceholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          'Informações do Covil',
          Icons.home,
          [
            _buildInfoRow('Tipo', _lair!.type.description),
            _buildInfoRow('Ocupação', _lair!.occupation.description),
            _buildInfoRow('Ocupante', _lair!.occupant),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailSection('Descrição', _lair!.description),
        const SizedBox(height: 8),
        _buildDetailSection('Detalhes', _lair!.details),
      ],
    );
  }

  Widget _buildRiversRoadsIslandsDetails() {
    if (_riversRoadsIslands == null) return _buildLoadingPlaceholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          'Informações da Descoberta',
          Icons.water,
          [
            _buildInfoRow('Tipo', _riversRoadsIslands!.type.description),
            _buildInfoRow('Direção', _riversRoadsIslands!.direction),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailSection('Descrição', _riversRoadsIslands!.description),
        const SizedBox(height: 8),
        _buildDetailSection('Detalhes', _riversRoadsIslands!.details),
      ],
    );
  }

  Widget _buildCastleFortDetails() {
    if (_castleFort == null) return _buildLoadingPlaceholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card de Informações Básicas
        _buildInfoCard(
          'Informações Básicas',
          Icons.fort,
          [
            _buildInfoRow('Tipo', _castleFort!.type.description),
            _buildInfoRow('Tamanho', _castleFort!.size),
            _buildInfoRow('Defesas', _castleFort!.defenses),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Card de Ocupação
        _buildInfoCard(
          'Ocupação',
          Icons.people,
          [
            _buildInfoRow('Ocupantes', _castleFort!.occupants),
            _buildInfoRow('Lorde', _castleFort!.lord),
            _buildInfoRow('Guarnição', _castleFort!.garrison),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Card de História
        _buildInfoCard(
          'História',
          Icons.history,
          [
            _buildInfoRow('Idade', _castleFort!.age),
            _buildInfoRow('Condição', _castleFort!.condition),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Card de Informações Especiais
        _buildInfoCard(
          'Informações Especiais',
          Icons.star,
          [
            _buildInfoRow('Especial', _castleFort!.special),
            _buildInfoRow('Rumores', _castleFort!.rumors),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Descrições
        _buildDetailSection('Descrição', _castleFort!.description),
        const SizedBox(height: 8),
        _buildDetailSection('Detalhes', _castleFort!.details),
      ],
    );
  }

  Widget _buildTempleSanctuaryDetails() {
    if (_templeSanctuary == null) return _buildLoadingPlaceholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card de Informações Básicas
        _buildInfoCard(
          'Informações do Templo',
          Icons.temple_buddhist,
          [
            _buildInfoRow('Tipo', _templeSanctuary!.type.description),
            _buildInfoRow('Divindade', _templeSanctuary!.deity),
            _buildInfoRow('Ocupantes', _templeSanctuary!.occupants),
          ],
        ),

        const SizedBox(height: 16),

        // Descrições
        _buildDetailSection('Descrição', _templeSanctuary!.description),
        const SizedBox(height: 8),
        _buildDetailSection('Detalhes', _templeSanctuary!.details),
      ],
    );
  }

  Widget _buildNaturalDangerDetails() {
    if (_naturalDanger == null) return _buildLoadingPlaceholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailSection('Tipo', _naturalDanger!.type.description),
        _buildDetailSection('Efeitos', _naturalDanger!.effects),
        const SizedBox(height: 16),
        _buildDetailSection('Descrição', _naturalDanger!.description),
        const SizedBox(height: 8),
        _buildDetailSection('Detalhes', _naturalDanger!.details),
      ],
    );
  }

  Widget _buildCivilizationDetails() {
    if (_civilization == null) return _buildLoadingPlaceholder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card de Informações Básicas
        _buildInfoCard(
          'Informações da Civilização',
          Icons.location_city,
          [
            _buildInfoRow('Tipo', _civilization!.type.description),
            _buildInfoRow('População', _civilization!.population),
            _buildInfoRow('Governo', _civilization!.government),
          ],
        ),

        const SizedBox(height: 16),

        // Descrições
        _buildDetailSection('Descrição', _civilization!.description),
        const SizedBox(height: 8),
        _buildDetailSection('Detalhes', _civilization!.details),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Gerando detalhes...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.primaryLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            content,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class SecondaryActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const SecondaryActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
    );
  }
}
