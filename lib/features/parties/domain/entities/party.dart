import 'package:equatable/equatable.dart';

class PartyEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String venue;
  final String genre;
  final double latitude;
  final double longitude;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String imageUrl;
  final String logoUrl;
  final double rating;
  final int reviewCount;
  final String priceCategory;
  final List<String> tags;
  final bool isFeatured;

  const PartyEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.venue,
    required this.genre,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.imageUrl,
    required this.logoUrl,
    required this.rating,
    required this.reviewCount,
    required this.priceCategory,
    required this.tags,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    venue,
    latitude,
    longitude,
    date,
    startTime,
    endTime,
    imageUrl,
  ];
}
