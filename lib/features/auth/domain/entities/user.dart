import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// 用户实体
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? name,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;
}
