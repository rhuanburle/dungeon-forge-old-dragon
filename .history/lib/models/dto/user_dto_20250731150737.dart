import '../base_model.dart';

class UserDto extends BaseModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  UserDto({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  static UserDto fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  @override
  UserDto copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
  }) {
    return UserDto(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
} 