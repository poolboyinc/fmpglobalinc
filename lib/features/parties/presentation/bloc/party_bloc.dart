import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fmpglobalinc/features/parties/domain/usecases/get_featured_parties.dart';
import 'package:fmpglobalinc/features/parties/domain/usecases/get_parties.dart';
import 'package:fmpglobalinc/features/parties/domain/usecases/get_parties_by_date.dart';
import 'package:fmpglobalinc/features/parties/domain/usecases/get_party_by_id.dart';
import 'package:fmpglobalinc/features/parties/presentation/bloc/party_event.dart';
import 'package:fmpglobalinc/features/parties/presentation/bloc/party_state.dart';

class PartyBloc extends Bloc<PartyEvent, PartyState> {
  final GetParties getParties;
  final GetPartyById getPartyById;
  final GetPartiesByDate getPartiesByDate;
  final GetFeaturedParties getFeaturedParties;

  PartyBloc({
    required this.getParties,
    required this.getPartyById,
    required this.getPartiesByDate,
    required this.getFeaturedParties,
  }) : super(PartyInitial()) {
    on<GetPartiesEvent>(_onGetPartiesEvent);
    on<GetPartyByIdEvent>(_onGetPartyByIdEvent);
    on<GetPartiesByDateEvent>(_onGetPartiesByDateEvent);
    on<GetFeaturedPartiesEvent>(_onGetFeaturedPartiesEvent);
    on<ClearPartiesEvent>(_onClearPartiesEvent);
  }

  void _onGetPartiesEvent(
    GetPartiesEvent event,
    Emitter<PartyState> emit,
  ) async {
    emit(PartyLoading());
    final result = await getParties();
    result.fold(
      (failure) => emit(PartyError(failure.message)),
      (parties) => emit(PartiesLoaded(parties)),
    );
  }

  void _onGetPartyByIdEvent(
    GetPartyByIdEvent event,
    Emitter<PartyState> emit,
  ) async {
    emit(PartyLoading());
    final result = await getPartyById(event.id);
    result.fold(
      (failure) => emit(PartyError(failure.message)),
      (party) => emit(PartyLoaded(party)),
    );
  }

  void _onGetPartiesByDateEvent(
    GetPartiesByDateEvent event,
    Emitter<PartyState> emit,
  ) async {
    emit(PartyLoading());
    final result = await getPartiesByDate(event.date);
    result.fold(
      (failure) => emit(PartyError(failure.message)),
      (parties) => emit(PartiesByDateLoaded(parties, event.date)),
    );
  }

  void _onGetFeaturedPartiesEvent(
    GetFeaturedPartiesEvent event,
    Emitter<PartyState> emit,
  ) async {
    emit(PartyLoading());
    final result = await getFeaturedParties();
    result.fold(
      (failure) => emit(PartyError(failure.message)),
      (parties) => emit(FeaturedPartiesLoaded(parties)),
    );
  }

  void _onClearPartiesEvent(ClearPartiesEvent event, Emitter<PartyState> emit) {
    emit(PartyInitial());
  }
}
