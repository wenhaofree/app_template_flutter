import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 用户数据模型
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? name,
    String? avatar,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// 扩展方法：将模型转换为实体
extension UserModelX on UserModel {
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// 扩展方法：将实体转换为模型
extension UserX on User {
  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
