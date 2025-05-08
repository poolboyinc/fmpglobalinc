// lib/features/map/data/models/venue_model.dart
class VenueModel {
  final String id;
  final String name;
  final String logo;
  final double latitude;
  final double longitude;
  final String type;
  final String timeRange;
  final String priceRange;
  final double rating;
  final int reviews;
  final List<String> images;

  VenueModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.timeRange,
    required this.priceRange,
    required this.rating,
    required this.reviews,
    required this.images,
  });

  // Mock data
  static List<VenueModel> getMockVenues() {
    return [
      VenueModel(
        id: '1',
        name: 'Morrison Pub',
        logo: 'assets/images/morrison_logo.png',
        latitude: 44.786568,
        longitude: 20.448922,
        type: 'Balkan',
        timeRange: '23-03h',
        priceRange: '€€',
        rating: 4.5,
        reviews: 347,
        images: ['assets/images/morrison1.jpg'],
      ),
      // Add more mock venues
    ];
  }
}
