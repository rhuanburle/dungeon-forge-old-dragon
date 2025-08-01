import '../models/dto/user_dto.dart';

class UserMapper {
  static UserDto fromJson(Map<String, dynamic> json) {
    return UserDto.fromJson(json);
  }

  static Map<String, dynamic> toJson(UserDto user) {
    return user.toJson();
  }

  static List<UserDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<UserDto> users) {
    return users.map((user) => toJson(user)).toList();
  }
}
