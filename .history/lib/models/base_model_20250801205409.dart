// models/base_model.dart

import 'dart:convert';

/// Classe base para todos os modelos da aplicação
abstract class BaseModel {
  /// Converte o modelo para um Map
  Map<String, dynamic> toMap();

  /// Cria um modelo a partir de um Map
  static T fromMap<T extends BaseModel>(Map<String, dynamic> map) {
    throw UnimplementedError('fromMap must be implemented by subclasses');
  }

  /// Converte o modelo para JSON
  String toJson() {
    return jsonEncode(toMap());
  }

  /// Cria um modelo a partir de JSON
  static T fromJson<T extends BaseModel>(String json) {
    return fromMap<T>(jsonDecode(json));
  }

  /// Cria uma cópia do modelo com novos valores
  T copyWith<T extends BaseModel>();

  /// Compara se dois modelos são iguais
  @override
  bool operator ==(Object other);

  /// Gera o hash code do modelo
  @override
  int get hashCode;

  /// Retorna uma representação em string do modelo
  @override
  String toString();
}

/// Mixin para adicionar funcionalidades de validação aos modelos
mixin Validatable {
  /// Lista de erros de validação
  List<String> get validationErrors;

  /// Verifica se o modelo é válido
  bool get isValid => validationErrors.isEmpty;

  /// Valida o modelo e retorna os erros
  List<String> validate();
}

/// Mixin para adicionar funcionalidades de serialização aos modelos
mixin Serializable {
  /// Converte o modelo para um Map
  Map<String, dynamic> toMap();

  /// Cria um modelo a partir de um Map
  static T fromMap<T extends Serializable>(Map<String, dynamic> map);
}
