import '../../models/dto/user_dto.dart';

abstract class UserRepository {
  Future<UserDto?> getUser(String id);
  Future<List<UserDto>> getUsers();
  Future<UserDto> createUser(UserDto user);
  Future<UserDto> updateUser(UserDto user);
  Future<void> deleteUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserDto?> getUser(String id) async {
    // Implementation would go here
    throw UnimplementedError();
  }

  @override
  Future<List<UserDto>> getUsers() async {
    // Implementation would go here
    throw UnimplementedError();
  }

  @override
  Future<UserDto> createUser(UserDto user) async {
    // Implementation would go here
    throw UnimplementedError();
  }

  @override
  Future<UserDto> updateUser(UserDto user) async {
    // Implementation would go here
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(String id) async {
    // Implementation would go here
    throw UnimplementedError();
  }
} 