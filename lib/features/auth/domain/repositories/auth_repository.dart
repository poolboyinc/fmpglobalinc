// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithApple();
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, void>> signOut();
  Future<User?> getCurrentUser();
  Stream<User?> get authStateChanges;
}
