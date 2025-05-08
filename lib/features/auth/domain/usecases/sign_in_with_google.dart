import 'package:dartz/dartz.dart';
import 'package:fmpglobalinc/core/errors/failure.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<Either<Failure, User>> call() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return const Left(AuthFailure('Google Sign In was canceled'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.AuthCredential credential = firebase_auth
          .GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth
          .instance
          .signInWithCredential(credential);

      final user = User(
        id: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName,
        photoUrl: userCredential.user!.photoURL,
      );

      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
