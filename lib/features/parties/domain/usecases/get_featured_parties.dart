import 'package:dartz/dartz.dart';
import 'package:fmpglobalinc/core/errors/failure.dart';
import 'package:fmpglobalinc/features/parties/domain/entities/party.dart';
import 'package:fmpglobalinc/features/parties/domain/repositories/party_repository.dart';

class GetFeaturedParties {
  final PartyRepository repository;

  GetFeaturedParties(this.repository);

  Future<Either<Failure, List<PartyEntity>>> call() async {
    return await repository.getFeaturedParties();
  }
}
