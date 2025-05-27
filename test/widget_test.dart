import 'package:flutter_test/flutter_test.dart';
import 'package:app_template_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:app_template_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_template_flutter/features/auth/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('LoginUseCase Tests', () {
    late LoginUseCase loginUseCase;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(mockAuthRepository);
    });

    test('should return User when login is successful', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const user = User(
        id: '1',
        email: email,
        name: 'Test User',
      );

      when(mockAuthRepository.login(email, password))
          .thenAnswer((_) async => user);

      // Act
      final result = await loginUseCase(email, password);

      // Assert
      expect(result, equals(user));
      verify(mockAuthRepository.login(email, password)).called(1);
    });

    test('should throw ArgumentError when email is empty', () async {
      // Arrange
      const email = '';
      const password = 'password123';

      // Act & Assert
      expect(
        () => loginUseCase(email, password),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError when password is empty', () async {
      // Arrange
      const email = 'test@example.com';
      const password = '';

      // Act & Assert
      expect(
        () => loginUseCase(email, password),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError when email format is invalid', () async {
      // Arrange
      const email = 'invalid-email';
      const password = 'password123';

      // Act & Assert
      expect(
        () => loginUseCase(email, password),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError when password is too short', () async {
      // Arrange
      const email = 'test@example.com';
      const password = '123';

      // Act & Assert
      expect(
        () => loginUseCase(email, password),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
