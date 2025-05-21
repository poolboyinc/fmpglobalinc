import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fmpglobalinc/core/network/network_info.dart';
import 'package:fmpglobalinc/features/parties/data/datasources/party_remote_datasource.dart';
import 'package:fmpglobalinc/features/parties/data/repositories/party_repository_impl.dart';
import 'package:fmpglobalinc/features/parties/domain/repositories/party_repository.dart';
import 'package:fmpglobalinc/features/parties/domain/usecases/get_featured_parties.dart';
import 'package:fmpglobalinc/features/parties/domain/usecases/get_parties.dart';
import 'package:fmpglobalinc/features/parties/domain/usecases/get_parties_by_date.dart';
import 'package:fmpglobalinc/features/parties/domain/usecases/get_party_by_id.dart';
import 'package:fmpglobalinc/features/parties/presentation/bloc/party_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fmpglobalinc/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fmpglobalinc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fmpglobalinc/features/auth/domain/repositories/auth_repository.dart';
import 'package:fmpglobalinc/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:fmpglobalinc/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:fmpglobalinc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );

  sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  sl.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<PartyRemoteDataSource>(
    () => PartyRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<PartyRepository>(
    () => PartyRepositoryImpl(
      remoteDataSource: sl<PartyRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton(() => SignInWithGoogle(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithApple(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetParties(sl<PartyRepository>()));
  sl.registerLazySingleton(() => GetPartyById(sl<PartyRepository>()));
  sl.registerLazySingleton(() => GetPartiesByDate(sl<PartyRepository>()));
  sl.registerLazySingleton(() => GetFeaturedParties(sl<PartyRepository>()));

  sl.registerFactory(
    () => AuthBloc(
      signInWithGoogle: sl<SignInWithGoogle>(),
      signInWithApple: sl<SignInWithApple>(),
      authRepository: sl<AuthRepository>(),
    ),
  );
  sl.registerFactory(
    () => PartyBloc(
      getParties: sl<GetParties>(),
      getPartyById: sl<GetPartyById>(),
      getPartiesByDate: sl<GetPartiesByDate>(),
      getFeaturedParties: sl<GetFeaturedParties>(),
    ),
  );
}
