// lib/features/map/presentation/widgets/venue_bottom_sheet.dart
import 'package:flutter/material.dart';
import '../../data/models/venue_model.dart';

class VenueBottomSheet extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback onClose;

  const VenueBottomSheet({
    Key? key,
    required this.venue,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A0B2E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Image.asset(
                venue.images.first,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                      onPressed: onClose,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      venue.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            venue.rating.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(Icons.star, color: Colors.white, size: 16),
                          Text(
                            '(${venue.reviews})',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${venue.type} | ${venue.timeRange} | ${venue.priceRange}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
