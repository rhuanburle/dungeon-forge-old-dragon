// utils/treasure_models.dart

import '../models/base_model.dart';

/// Representa um item de tesouro
class TreasureItem extends BaseModel {
  final int quantity;
  final String unit;
  final String? description;
  final TreasureItemType type;

  const TreasureItem({
    required this.quantity,
    required this.unit,
    this.description,
    required this.type,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'unit': unit,
      'description': description,
      'type': type.name,
    };
  }

  @override
  TreasureItem copyWith<T extends BaseModel>() {
    return TreasureItem(
      quantity: quantity,
      unit: unit,
      description: description,
      type: type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TreasureItem &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.description == description &&
        other.type == type;
  }

  @override
  int get hashCode {
    return Object.hash(quantity, unit, description, type);
  }

  @override
  String toString() {
    if (description != null) {
      return '$quantity $unit: $description';
    }
    return '$quantity $unit';
  }
}

/// Tipos de itens de tesouro
enum TreasureItemType {
  platinum('PP'),
  gold('PO'),
  gems('Gemas'),
  valuableObjects('Objetos de Valor'),
  magicItem('Item Mágico');

  const TreasureItemType(this.abbreviation);
  final String abbreviation;
}

/// Representa um tesouro completo
class Treasure extends BaseModel {
  final List<TreasureItem> items;
  final bool isEmpty;

  const Treasure({
    required this.items,
    this.isEmpty = false,
  });

  /// Cria um tesouro vazio
  factory Treasure.empty() {
    return const Treasure(items: [], isEmpty: true);
  }

  /// Cria um tesouro com um único item
  factory Treasure.single(TreasureItem item) {
    return Treasure(items: [item]);
  }

  /// Cria um tesouro com múltiplos itens
  factory Treasure.multiple(List<TreasureItem> items) {
    return Treasure(items: items);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'isEmpty': isEmpty,
    };
  }

  @override
  Treasure copyWith<T extends BaseModel>() {
    return Treasure(
      items: items,
      isEmpty: isEmpty,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Treasure &&
        other.items == items &&
        other.isEmpty == isEmpty;
  }

  @override
  int get hashCode {
    return Object.hash(items, isEmpty);
  }

  @override
  String toString() {
    if (isEmpty) return 'Nenhum';
    return items.map((item) => item.toString()).join(' + ');
  }
}

/// Representa uma gema específica
class Gem extends BaseModel {
  final String category;
  final String value;
  final String description;

  const Gem({
    required this.category,
    required this.value,
    required this.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'value': value,
      'description': description,
    };
  }

  @override
  Gem copyWith<T extends BaseModel>() {
    return Gem(
      category: category,
      value: value,
      description: description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Gem &&
        other.category == category &&
        other.value == value &&
        other.description == description;
  }

  @override
  int get hashCode {
    return Object.hash(category, value, description);
  }

  @override
  String toString() {
    return '$category ($value)';
  }
}

/// Representa um objeto de valor
class ValuableObject extends BaseModel {
  final String type;
  final String item;
  final String description;

  const ValuableObject({
    required this.type,
    required this.item,
    required this.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'item': item,
      'description': description,
    };
  }

  @override
  ValuableObject copyWith<T extends BaseModel>() {
    return ValuableObject(
      type: type,
      item: item,
      description: description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValuableObject &&
        other.type == type &&
        other.item == item &&
        other.description == description;
  }

  @override
  int get hashCode {
    return Object.hash(type, item, description);
  }

  @override
  String toString() {
    return item;
  }
} 