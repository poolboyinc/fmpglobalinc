import 'package:dartz/dartz.dart';
import 'package:fmpglobalinc/core/errors/exceptions.dart';
import 'package:fmpglobalinc/core/errors/failure.dart';
import 'package:fmpglobalinc/core/network/network_info.dart';
import 'package:fmpglobalinc/features/parties/data/datasources/party_remote_datasource.dart';
import 'package:fmpglobalinc/features/parties/domain/entities/party.dart';
import 'package:fmpglobalinc/features/parties/domain/repositories/party_repository.dart';

class PartyRepositoryImpl implements PartyRepository {
  final PartyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PartyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PartyEntity>>> getParties() async {
    if (await networkInfo.isConnected) {
      try {
        final parties = await remoteDataSource.getParties();
        return Right(parties);
      } on ServerException {
        return Left(ServerFailure("Server responded incorrectly."));
      }
    } else {
      return Left(NetworkFailure("Network not found."));
    }
  }

  @override
  Future<Either<Failure, PartyEntity>> getPartyById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final party = await remoteDataSource.getPartyById(id);
        return Right(party);
      } on ServerException {
        return Left(ServerFailure("Server responded incorrectly."));
      } on NotFoundException {
        return Left(NetworkFailure("Network not found."));
      }
    } else {
      return Left(NetworkFailure("Network not found."));
    }
  }

  @override
  Future<Either<Failure, List<PartyEntity>>> getPartiesByDate(
    DateTime date,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final parties = await remoteDataSource.getPartiesByDate(date);
        return Right(parties);
      } on ServerException {
        return Left(ServerFailure("Server responded incorrectly."));
      }
    } else {
      return Left(NetworkFailure("Network not found."));
    }
  }

  @override
  Future<Either<Failure, List<PartyEntity>>> getFeaturedParties() async {
    if (await networkInfo.isConnected) {
      try {
        final parties = await remoteDataSource.getFeaturedParties();
        return Right(parties);
      } on ServerException {
        return Left(ServerFailure("Server responded incorrectly."));
      }
    } else {
      return Left(NetworkFailure("Network not found."));
    }
  }
}
