abstract class BaseModel {
  Map<String, dynamic> toJson();
  
  static BaseModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson must be implemented in subclasses');
  }
  
  BaseModel copyWith();
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseModel && other.runtimeType == runtimeType;
  }
  
  @override
  int get hashCode => runtimeType.hashCode;
} 