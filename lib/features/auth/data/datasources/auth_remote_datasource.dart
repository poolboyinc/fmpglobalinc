// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple_sign_in;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
  });

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign In was canceled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
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

      final userCredential =
          await firebaseAuth.signInWithCredential(oauthCredential);
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw Exception('Failed to sign in with Apple: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw Exception('Failed to sign in with email: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with name
      await userCredential.user?.updateDisplayName(name);

      // Reload user to get updated profile
      await userCredential.user?.reload();
      final updatedUser = firebaseAuth.currentUser;

      return UserModel.fromFirebaseUser(updatedUser!);
    } catch (e) {
      throw Exception('Failed to sign up with email: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }
}
