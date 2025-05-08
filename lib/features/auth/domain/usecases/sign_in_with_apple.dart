// lib/features/auth/domain/usecases/sign_in_with_apple.dart
import 'package:dartz/dartz.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple_sign_in;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';

class SignInWithApple {
  final AuthRepository repository;

  SignInWithApple(this.repository);

  Future<Either<Failure, User>> call() async {
    try {
      final appleCredential =
          await apple_sign_in.SignInWithApple.getAppleIDCredential(
        scopes: [
          apple_sign_in.AppleIDAuthorizationScopes.email,
          apple_sign_in.AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential =
          firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await firebase_auth.FirebaseAuth.instance
          .signInWithCredential(oauthCredential);

      final displayName = appleCredential.givenName != null
          ? '${appleCredential.givenName} ${appleCredential.familyName}'
          : userCredential.user?.displayName;

      final user = User(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: displayName,
        photoUrl: userCredential.user!.photoURL,
      );

      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
