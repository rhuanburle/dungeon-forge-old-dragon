// utils/valuable_object_resolver.dart

import 'dice_roller.dart';

/// Serviço para resolver objetos de valor específicos
class ValuableObjectResolver {
  /// Resolve uma quantidade de objetos de valor para itens específicos
  static String resolve(int count) {
    final objetos = <String>[];
    
    for (int i = 0; i < count; i++) {
      final tipoRoll = DiceRoller.roll(2, 6);
      final itemRoll = DiceRoller.roll(2, 6);
      
      final tipo = _getTipo(tipoRoll);
      final item = _getItem(tipo, itemRoll);
      
      objetos.add(item);
    }
    
    return objetos.join(', ');
  }

  /// Obtém o tipo do objeto baseado no roll
  static String _getTipo(int roll) {
    switch (roll) {
      case 2:
      case 3:
        return 'Obras de Arte';
      case 4:
      case 5:
        return 'Utensílios';
      case 6:
      case 7:
      case 8:
      case 9:
        return 'Mercadoria';
      case 10:
      case 11:
        return 'Louças';
      case 12:
        return 'Joias';
      default:
        return 'Mercadoria';
    }
  }

  /// Obtém o item específico baseado no tipo e roll
  static String _getItem(String tipo, int roll) {
    switch (tipo) {
      case 'Obras de Arte':
        return _getObraDeArte(roll);
      case 'Utensílios':
        return _getUtensilio(roll);
      case 'Mercadoria':
        return _getMercadoria(roll);
      case 'Louças':
        return _getLouca(roll);
      case 'Joias':
        return _getJoia(roll);
      default:
        return 'Item de Valor';
    }
  }

  /// Obtém uma obra de arte específica
  static String _getObraDeArte(int roll) {
    switch (roll) {
      case 2:
      case 3:
        return 'Móveis com Marchetaria';
      case 4:
      case 5:
        return 'Tapeçaria Fina';
      case 6:
      case 7:
        return 'Livro Raro';
      case 8:
      case 9:
        return 'Escultura';
      case 10:
      case 11:
        return 'Tela Pintada';
      default:
        return 'Estatueta em Bronze';
    }
  }

  /// Obtém um utensílio específico
  static String _getUtensilio(int roll) {
    switch (roll) {
      case 2:
      case 3:
        return 'Religiosos de Cobre';
      case 4:
      case 5:
        return 'Talheres de Prata';
      case 6:
      case 7:
        return 'Candelabros de Prata';
      case 8:
      case 9:
        return 'Cutelaria Fina';
      case 10:
      case 11:
        return 'Cálices de Ouro';
      default:
        return 'Religiosos de Ouro';
    }
  }

  /// Obtém uma mercadoria específica
  static String _getMercadoria(int roll) {
    switch (roll) {
      case 2:
      case 3:
        return 'Peles de Animais Raros';
      case 4:
      case 5:
        return 'Objetos de Marfim';
      case 6:
      case 7:
        return 'Sacas de Especiaria';
      case 8:
      case 9:
        return 'Sacas de Incenso';
      case 10:
      case 11:
        return 'Tecidos Nobres';
      default:
        return 'Metros de Fina Seda';
    }
  }

  /// Obtém uma louça específica
  static String _getLouca(int roll) {
    switch (roll) {
      case 2:
      case 3:
        return 'Objetos de Vidro Soprado';
      case 4:
      case 5:
        return 'Copos de Vidro e com Prata';
      case 6:
      case 7:
        return 'Baixelas de Louça';
      case 8:
      case 9:
        return 'Baixelas de Porcelana com ouro';
      case 10:
      case 11:
        return 'Vaso de Porcelana';
      default:
        return 'Cálices de Vidro com pedraria';
    }
  }

  /// Obtém uma joia específica
  static String _getJoia(int roll) {
    switch (roll) {
      case 2:
      case 3:
        return 'Cordão de Prata';
      case 4:
      case 5:
        return 'Brincos de Pérola';
      case 6:
      case 7:
        return 'Bracelete de Prata';
      case 8:
      case 9:
        return 'Pingente de Pedraria';
      case 10:
      case 11:
        return 'Camafeu de Ouro';
      default:
        return 'Tiara com Pedraria';
    }
  }
} 