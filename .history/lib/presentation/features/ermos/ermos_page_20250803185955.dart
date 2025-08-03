import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../services/exploration_service.dart';
import '../../../models/exploration.dart';
import '../../../enums/exploration_enums.dart';
import '../../../enums/table_enums.dart';

class ErmosPage extends StatefulWidget {
  const ErmosPage({super.key});

  @override
  State<ErmosPage> createState() => _ErmosPageState();
}

class _ErmosPageState extends State<ErmosPage> {
  final ExplorationService _explorationService = ExplorationService();

  bool _isWilderness = true;
  bool _isGenerating = false;
  bool _useManualSelection = false;
  DiscoveryType? _selectedDiscoveryType;
  ExplorationResult? _currentResult;
  AncestralDiscovery? _ancestralDiscovery;
  Lair? _lair;
  RiversRoadsIslands? _riversRoadsIslands;
  CastleFort? _castleFort;
  TempleSanctuary? _templeSanctuary;
  NaturalDanger? _naturalDanger;
  Civilization? _civilization;
  Settlement? _settlement;

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
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.forest, color: AppColors.primaryLight, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Exploração dos Ermos',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isMobile ? 15 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh, color: AppColors.primaryLight),
                    tooltip: 'Explorar Hex',
                    onPressed: _isGenerating ? null : _exploreHex,
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 10 : 16),
            // Conteúdo principal
            Expanded(
              child: isMobile
                  ? _buildMobileLayout(isMobile)
                  : _buildDesktopLayout(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Painel de Configuração - 40%
        Expanded(flex: 4, child: _buildConfigurationPanel(isMobile)),
        const SizedBox(width: 16),
        // Painel de Resultado - 60%
        Expanded(flex: 6, child: _buildResultPanel(isMobile)),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return Column(
      children: [
        _buildConfigurationPanel(isMobile),
        const SizedBox(height: 16),
        Expanded(child: _buildResultPanel(isMobile)),
      ],
    );
  }

  Widget _buildConfigurationPanel(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Tipo de Área
          Text(
            'Tipo de Área:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAreaTypeButton('Selvagem (1d6)', true, isMobile),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAreaTypeButton(
                  'Civilizada (1d8)',
                  false,
                  isMobile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Modo de Exploração
          Text(
            'Modo de Exploração:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildExplorationModeButton(
                  'Aleatória',
                  false,
                  isMobile,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildExplorationModeButton('Manual', true, isMobile),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Seleção Manual de Tipo (apenas quando modo manual estiver ativo)
          if (_useManualSelection) ...[
            Text(
              'Tipo de Descoberta:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildDiscoveryTypeDropdown(isMobile),
            const SizedBox(height: 16),
          ],
          // Botão Explorar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _isGenerating ||
                      (_useManualSelection && _selectedDiscoveryType == null)
                  ? null
                  : _exploreHex,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isGenerating
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Explorando...',
                          style: TextStyle(fontSize: isMobile ? 13 : 14),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.explore, size: isMobile ? 16 : 18),
                        const SizedBox(width: 8),
                        Text(
                          _useManualSelection
                              ? 'Gerar Descoberta'
                              : 'Explorar Hex',
                          style: TextStyle(fontSize: isMobile ? 13 : 14),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

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
            _selectedDiscoveryType =
                null; // Limpar seleção manual quando muda o modo
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
      items: DiscoveryType.values.map((type) {
        return DropdownMenuItem<DiscoveryType>(
          value: type,
          child: Text(type.name),
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

  Widget _buildResultPanel(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resultado da Exploração',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _currentResult == null
                ? _buildEmptyState(isMobile)
                : _buildExplorationResult(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Clique em "Explorar Hex" para começar',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 13 : 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExplorationResult() {
    if (_currentResult == null) return _buildEmptyState(true); // Adicionar parâmetro isMobile

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do resultado
          Row(
            children: [
              Icon(
                _currentResult!.hasDiscovery ? Icons.explore : Icons.search_off,
                color: _currentResult!.hasDiscovery ? AppColors.success : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _currentResult!.hasDiscovery ? 'Descoberta Encontrada!' : 'Nada Encontrado',
                  style: TextStyle(
                    color: _currentResult!.hasDiscovery ? AppColors.success : AppColors.textSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Descrição principal
          Text(
            _currentResult!.description,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // Detalhes específicos se houver descoberta
          if (_currentResult!.hasDiscovery && _currentResult!.discoveryType != null) ...[
            _buildDiscoveryDetails(),
            const SizedBox(height: 16),
            
            // Botão para detalhamento completo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateDetailedDiscovery,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.details, size: 18),
                label: const Text('Gerar Detalhamento Completo'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscoveryDetails() {
    if (_currentResult?.discoveryType == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tipo de Descoberta: ${_currentResult!.discoveryType!.description}',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          // Detalhes específicos baseados no tipo
          _buildSpecificDiscoveryDetails(),
        ],
      ),
    );
  }

  Widget _buildSpecificDiscoveryDetails() {
    switch (_currentResult!.discoveryType!) {
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
    }
  }

  Widget _buildAncestralDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_ancestralDiscovery != null) ...[
          _buildDetailSection('Tipo Ancestral', _ancestralDiscovery!.type.description),
          _buildDetailSection('Condição', _ancestralDiscovery!.condition.description),
          _buildDetailSection('Material', _ancestralDiscovery!.material.description),
          _buildDetailSection('Estado', _ancestralDiscovery!.state.description),
          _buildDetailSection('Guardião', _ancestralDiscovery!.guardian.description),
          const SizedBox(height: 8),
          _buildDetailSection('Rolagens', '1d6 para cada aspecto (Tabela 4.4)'),
        ] else ...[
          Text(
            'Clique em "Gerar Detalhamento Completo" para ver todos os detalhes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLairDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_lair != null) ...[
          _buildDetailSection('Tipo de Covil', _lair!.type.description),
          _buildDetailSection('Ocupação', _lair!.occupation.description),
          _buildDetailSection('Ocupante', _lair!.occupant),
          const SizedBox(height: 8),
          _buildDetailSection('Rolagens', '1d6 para cada aspecto (Tabela 4.13)'),
        ] else ...[
          Text(
            'Clique em "Gerar Detalhamento Completo" para ver todos os detalhes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRiversRoadsIslandsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_riversRoadsIslands != null) ...[
          _buildDetailSection('Tipo', _riversRoadsIslands!.type.description),
          _buildDetailSection('Direção', _riversRoadsIslands!.direction),
          const SizedBox(height: 8),
          _buildDetailSection('Rolagens', '1d6 para cada aspecto (Tabela 4.25)'),
        ] else ...[
          Text(
            'Clique em "Gerar Detalhamento Completo" para ver todos os detalhes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCastleFortDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_castleFort != null) ...[
          _buildDetailSection('Tipo', _castleFort!.type.description),
          _buildDetailSection('Tamanho', _castleFort!.size),
          _buildDetailSection('Defesas', _castleFort!.defenses),
          _buildDetailSection('Ocupantes', _castleFort!.occupants),
          const SizedBox(height: 8),
          _buildDetailSection('Rolagens', '1d6 para cada aspecto (Tabela 4.30)'),
        ] else ...[
          Text(
            'Clique em "Gerar Detalhamento Completo" para ver todos os detalhes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTempleSanctuaryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_templeSanctuary != null) ...[
          _buildDetailSection('Tipo', _templeSanctuary!.type.description),
          _buildDetailSection('Divindade', _templeSanctuary!.deity),
          _buildDetailSection('Ocupantes', _templeSanctuary!.occupants),
          const SizedBox(height: 8),
          _buildDetailSection('Rolagens', '1d6 para cada aspecto (Tabela 4.33)'),
        ] else ...[
          Text(
            'Clique em "Gerar Detalhamento Completo" para ver todos os detalhes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNaturalDangerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_naturalDanger != null) ...[
          _buildDetailSection('Tipo', _naturalDanger!.type.description),
          _buildDetailSection('Efeitos', _naturalDanger!.effects),
          const SizedBox(height: 8),
          _buildDetailSection('Rolagens', '1d6 para cada aspecto (Tabela 4.38)'),
        ] else ...[
          Text(
            'Clique em "Gerar Detalhamento Completo" para ver todos os detalhes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCivilizationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_civilization != null) ...[
          _buildDetailSection('Tipo', _civilization!.type.description),
          _buildDetailSection('População', _civilization!.population),
          _buildDetailSection('Governo', _civilization!.government),
          const SizedBox(height: 8),
          _buildDetailSection('Rolagens', '1d6 para cada aspecto (Tabela 4.39)'),
        ] else ...[
          Text(
            'Clique em "Gerar Detalhamento Completo" para ver todos os detalhes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$title:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exploreHex() async {
    setState(() {
      _isGenerating = true;
    });

    // Simular delay para feedback visual
    await Future.delayed(const Duration(milliseconds: 500));

    final result = _useManualSelection && _selectedDiscoveryType != null
        ? _explorationService.exploreHexWithType(_selectedDiscoveryType!)
        : _explorationService.exploreHex(isWilderness: _isWilderness);

    setState(() {
      _currentResult = result;
      _isGenerating = false;

      // Limpar resultados anteriores
      _ancestralDiscovery = null;
      _lair = null;
      _riversRoadsIslands = null;
      _castleFort = null;
      _templeSanctuary = null;
      _naturalDanger = null;
      _civilization = null;
      _settlement = null;

      // Gerar detalhes específicos se houver descoberta
      if (result.hasDiscovery && result.discoveryType != null) {
        _generateDiscoveryDetails(result.discoveryType!);
      }
    });
  }

  void _generateDiscoveryDetails(DiscoveryType discoveryType) {
    switch (discoveryType) {
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
    }
  }

  void _generateDetailedDiscovery() async {
    setState(() {
      _isGenerating = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentResult?.discoveryType != null) {
      switch (_currentResult!.discoveryType!) {
        case DiscoveryType.ancestralDiscoveries:
          _ancestralDiscovery = _explorationService.generateDetailedAncestralDiscovery();
          break;
        case DiscoveryType.lairs:
          _lair = _explorationService.generateDetailedLair();
          break;
        case DiscoveryType.riversRoadsIslands:
          _riversRoadsIslands = _explorationService.generateDetailedRiversRoadsIslands();
          break;
        case DiscoveryType.castlesForts:
          _castleFort = _explorationService.generateDetailedCastleFort();
          break;
        case DiscoveryType.templesSanctuaries:
          _templeSanctuary = _explorationService.generateDetailedTempleSanctuary();
          break;
        case DiscoveryType.naturalDangers:
          _naturalDanger = _explorationService.generateDetailedNaturalDanger();
          break;
        case DiscoveryType.civilization:
          _civilization = _explorationService.generateDetailedCivilization();
          break;
      }
    }

    setState(() {
      _isGenerating = false;
    });
  }
}
