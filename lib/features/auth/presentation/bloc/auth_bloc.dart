import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final AuthRepository authRepository;

  AuthBloc({
    required this.signInWithGoogle,
    required this.signInWithApple,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<EmailSignUpRequested>(_onEmailSignUpRequested);
    on<EmailSignInRequested>(_onEmailSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await signInWithGoogle();
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (user) => emit(Authenticated(user)),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await signInWithApple();
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (user) => emit(Authenticated(user)),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onEmailSignUpRequested(
    EmailSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.signUpWithEmail(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (user) => emit(Authenticated(user)),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onEmailSignInRequested(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (user) => emit(Authenticated(user)),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentUser = await authRepository.getCurrentUser();
    if (currentUser != null) {
      emit(Authenticated(currentUser));
    } else {
      emit(Unauthenticated());
    }
  }
}
