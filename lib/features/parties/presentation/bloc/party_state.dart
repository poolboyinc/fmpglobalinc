import 'package:equatable/equatable.dart';
import 'package:fmpglobalinc/features/parties/domain/entities/party.dart';

abstract class PartyState extends Equatable {
  const PartyState();

  @override
  List<Object?> get props => [];
}

class PartyInitial extends PartyState {}

class PartyLoading extends PartyState {}

class PartiesLoaded extends PartyState {
  final List<PartyEntity> parties;

  const PartiesLoaded(this.parties);

  @override
  List<Object?> get props => [parties];
}

class PartyLoaded extends PartyState {
  final PartyEntity party;

  const PartyLoaded(this.party);

  @override
  List<Object?> get props => [party];
}

class FeaturedPartiesLoaded extends PartyState {
  final List<PartyEntity> parties;

  const FeaturedPartiesLoaded(this.parties);

  @override
  List<Object?> get props => [parties];
}

class PartiesByDateLoaded extends PartyState {
  final List<PartyEntity> parties;
  final DateTime date;

  const PartiesByDateLoaded(this.parties, this.date);

  @override
  List<Object?> get props => [parties, date];
}

class PartyError extends PartyState {
  final String message;

  const PartyError(this.message);

  @override
  List<Object?> get props => [message];
}
