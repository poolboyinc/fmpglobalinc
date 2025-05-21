import 'package:dartz/dartz.dart';
import 'package:fmpglobalinc/core/errors/failure.dart';
import 'package:fmpglobalinc/features/parties/domain/entities/party.dart';

abstract class PartyRepository {
  Future<Either<Failure, List<PartyEntity>>> getParties();
  Future<Either<Failure, PartyEntity>> getPartyById(String id);
  Future<Either<Failure, List<PartyEntity>>> getPartiesByDate(DateTime date);
  Future<Either<Failure, List<PartyEntity>>> getFeaturedParties();
}
