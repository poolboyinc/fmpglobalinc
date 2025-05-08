import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fmpglobalinc/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fmpglobalinc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fmpglobalinc/features/auth/domain/repositories/auth_repository.dart';
import 'package:fmpglobalinc/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:fmpglobalinc/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithApple(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInWithGoogle: sl(),
      signInWithApple: sl(),
      authRepository: sl(),
    ),
  );
}
