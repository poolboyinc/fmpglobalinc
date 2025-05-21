import 'package:dartz/dartz.dart';
import 'package:fmpglobalinc/core/errors/failure.dart';
import 'package:fmpglobalinc/features/parties/domain/entities/party.dart';
import 'package:fmpglobalinc/features/parties/domain/repositories/party_repository.dart';

class GetPartyById {
  final PartyRepository repository;

  GetPartyById(this.repository);

  Future<Either<Failure, PartyEntity>> call(String id) async {
    return await repository.getPartyById(id);
  }
}
