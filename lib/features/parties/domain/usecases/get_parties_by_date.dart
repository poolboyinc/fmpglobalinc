import 'package:dartz/dartz.dart';
import 'package:fmpglobalinc/core/errors/failure.dart';
import 'package:fmpglobalinc/features/parties/domain/entities/party.dart';
import 'package:fmpglobalinc/features/parties/domain/repositories/party_repository.dart';

class GetPartiesByDate {
  final PartyRepository repository;

  GetPartiesByDate(this.repository);

  Future<Either<Failure, List<PartyEntity>>> call(DateTime date) async {
    return await repository.getPartiesByDate(date);
  }
}
