import 'package:equatable/equatable.dart';

abstract class PartyEvent extends Equatable {
  const PartyEvent();

  @override
  List<Object?> get props => [];
}

class GetPartiesEvent extends PartyEvent {
  const GetPartiesEvent();
}

class GetPartyByIdEvent extends PartyEvent {
  final String id;

  const GetPartyByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetPartiesByDateEvent extends PartyEvent {
  final DateTime date;

  const GetPartiesByDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class GetFeaturedPartiesEvent extends PartyEvent {
  const GetFeaturedPartiesEvent();
}

class ClearPartiesEvent extends PartyEvent {
  const ClearPartiesEvent();
}
