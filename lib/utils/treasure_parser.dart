// utils/treasure_parser.dart

import 'dice_roller.dart';

/// Parser para fórmulas de tesouro
class TreasureParser {
  /// Regex para identificar padrões de dados (ex: 1d6×100 PP)
  static final RegExp _dicePattern = RegExp(
    r'(\d+)d(\d+)(?:\s*[×x\*]\s*([\d,]+))?\s*(PP|PO|Gemas|Objetos de Valor)?',
    caseSensitive: false,
  );

  /// Regex para identificar números simples (ex: 4 PO)
  static final RegExp _numberPattern = RegExp(
    r'^(\d+)\s*(PP|PO|Gemas|Objetos de Valor)?$',
    caseSensitive: false,
  );

  /// Regex para identificar números soltos sem unidade
  static final RegExp _standaloneNumberPattern = RegExp(r'^\d+$');

  /// Analisa uma fórmula de tesouro e retorna os componentes
  static List<TreasureComponent> parse(String template) {
    template = template.trim();

    if (template.isEmpty || template == '—') {
      return [TreasureComponent.empty()];
    }

    if (template.toLowerCase().startsWith('nenhum')) {
      return [TreasureComponent.empty()];
    }

    // Remove "Jogue Novamente + " e analisa o resto
    if (template.contains('Jogue Novamente')) {
      final cleanTemplate = template.replaceAll('Jogue Novamente + ', '');
      return parse(cleanTemplate);
    }

    // Analisa "1 em 1d6"
    if (template.contains('1 em 1d6')) {
      final roll = DiceRoller.roll(1, 6);
      if (roll == 1) {
        final parts = template.split('1 em 1d6');
        if (parts.length > 1) {
          return parse(parts[1].trim());
        }
      }
      return [TreasureComponent.empty()];
    }

    final parts = template.split('+');
    final components = <TreasureComponent>[];

    for (final rawPart in parts) {
      final part = rawPart.trim();
      if (part.isEmpty) continue;

      // Verifica se é um item mágico
      if (_isMagicItem(part)) {
        components.add(TreasureComponent.magicItem(part));
        continue;
      }

      // Verifica padrão de dados
      final diceMatch = _dicePattern.firstMatch(part);
      if (diceMatch != null) {
        components.add(_parseDiceComponent(diceMatch));
        continue;
      }

      // Verifica número simples
      final numberMatch = _numberPattern.firstMatch(part);
      if (numberMatch != null) {
        final number = numberMatch.group(1)!;
        final unit = numberMatch.group(2) ?? '';

        if (unit.isNotEmpty) {
          components.add(TreasureComponent.simple(
            int.parse(number),
            unit.trim(),
          ));
        }
        continue;
      }

      // Verifica número solto sem unidade
      if (_standaloneNumberPattern.hasMatch(part)) {
        // Ignora números soltos sem unidade
        continue;
      }

      // Mantém como está se não se encaixar em nenhum padrão
      components.add(TreasureComponent.raw(part));
    }

    return components;
  }

  /// Verifica se é um item mágico
  static bool _isMagicItem(String part) {
    return part.contains('Qualquer') ||
        part.contains('Poção') ||
        part.contains('Pergaminho') ||
        part.contains('Arma');
  }

  /// Analisa um componente de dados
  static TreasureComponent _parseDiceComponent(RegExpMatch match) {
    final diceCount = int.parse(match.group(1)!);
    final diceSides = int.parse(match.group(2)!);
    final multiplierStr = match.group(3);
    final unit = match.group(4) ?? '';

    int value = DiceRoller.roll(diceCount, diceSides);
    if (multiplierStr != null) {
      final cleanMultiplier = multiplierStr.replaceAll('.', '');
      value *= int.parse(cleanMultiplier);
    }

    return TreasureComponent.dice(value, unit.trim());
  }
}

/// Representa um componente de tesouro
class TreasureComponent {
  final TreasureComponentType type;
  final int? value;
  final String? unit;
  final String? rawText;

  const TreasureComponent._({
    required this.type,
    this.value,
    this.unit,
    this.rawText,
  });

  /// Cria um componente vazio
  factory TreasureComponent.empty() {
    return const TreasureComponent._(type: TreasureComponentType.empty);
  }

  /// Cria um componente de dados
  factory TreasureComponent.dice(int value, String unit) {
    return TreasureComponent._(
      type: TreasureComponentType.dice,
      value: value,
      unit: unit,
    );
  }

  /// Cria um componente simples
  factory TreasureComponent.simple(int value, String unit) {
    return TreasureComponent._(
      type: TreasureComponentType.simple,
      value: value,
      unit: unit,
    );
  }

  /// Cria um componente de item mágico
  factory TreasureComponent.magicItem(String text) {
    return TreasureComponent._(
      type: TreasureComponentType.magicItem,
      rawText: text,
    );
  }

  /// Cria um componente raw
  factory TreasureComponent.raw(String text) {
    return TreasureComponent._(
      type: TreasureComponentType.raw,
      rawText: text,
    );
  }

  @override
  String toString() {
    switch (type) {
      case TreasureComponentType.empty:
        return 'Nenhum';
      case TreasureComponentType.dice:
      case TreasureComponentType.simple:
        return '$value $unit';
      case TreasureComponentType.magicItem:
      case TreasureComponentType.raw:
        return rawText ?? '';
    }
  }
}

/// Tipos de componentes de tesouro
enum TreasureComponentType {
  empty,
  dice,
  simple,
  magicItem,
  raw,
}
