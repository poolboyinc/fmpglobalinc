import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fmpglobalinc/core/errors/exceptions.dart';
import 'package:fmpglobalinc/features/parties/data/models/party_model.dart';

abstract class PartyRemoteDataSource {
  Future<List<PartyModel>> getParties();
  Future<PartyModel> getPartyById(String id);
  Future<List<PartyModel>> getPartiesByDate(DateTime date);
  Future<List<PartyModel>> getFeaturedParties();
}

class PartyRemoteDataSourceImpl implements PartyRemoteDataSource {
  final FirebaseFirestore firestore;

  PartyRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PartyModel>> getParties() async {
    try {
      final partiesCollection = await firestore.collection('parties').get();

      if (partiesCollection.docs.isEmpty) {
        return PartyModel.getMockParties();
      }

      return partiesCollection.docs
          .map((doc) => PartyModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<PartyModel> getPartyById(String id) async {
    try {
      final partyDoc = await firestore.collection('parties').doc(id).get();

      if (!partyDoc.exists) {
        throw NotFoundException();
      }

      return PartyModel.fromJson({...partyDoc.data()!, 'id': partyDoc.id});
    } catch (e) {
      if (e is NotFoundException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<List<PartyModel>> getPartiesByDate(DateTime date) async {
    try {
      final startDate = DateTime(date.year, date.month, date.day);
      final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final partiesCollection =
          await firestore
              .collection('parties')
              .where(
                'date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              )
              .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
              .get();

      if (partiesCollection.docs.isEmpty) {
        return PartyModel.getMockParties()
            .where(
              (party) =>
                  party.date.year == date.year &&
                  party.date.month == date.month &&
                  party.date.day == date.day,
            )
            .toList();
      }

      return partiesCollection.docs
          .map((doc) => PartyModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<PartyModel>> getFeaturedParties() async {
    try {
      final partiesCollection =
          await firestore
              .collection('parties')
              .where('isFeatured', isEqualTo: true)
              .get();

      if (partiesCollection.docs.isEmpty) {
        return PartyModel.getMockParties()
            .where((party) => party.isFeatured)
            .toList();
      }

      return partiesCollection.docs
          .map((doc) => PartyModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }
}
