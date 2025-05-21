import 'package:flutter/material.dart';
import 'package:fmpglobalinc/features/parties/domain/entities/party.dart';
import 'package:intl/intl.dart';

class PartyBottomSheet extends StatelessWidget {
  final PartyEntity party;
  final VoidCallback onClose;

  const PartyBottomSheet({Key? key, required this.party, required this.onClose})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildPartyLogo(party.logoUrl),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        party.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEE, MMM d').format(party.date),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${party.startTime} - ${party.endTime}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 8),
                    Text(party.venue, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 16),
                    const Icon(Icons.music_note, size: 16),
                    const SizedBox(width: 8),
                    Text(party.genre, style: const TextStyle(fontSize: 16)),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${party.rating} (${party.reviewCount})',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      party.priceCategory,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(party.description, style: const TextStyle(fontSize: 14)),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      party.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.book),
                        label: const Text('Reserve'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyLogo(String logoPath) {
    if (logoPath.startsWith('http')) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(logoPath),
        backgroundColor: Colors.grey[200],
        onBackgroundImageError: (exception, stackTrace) {},
      );
    } else {
      return CircleAvatar(
        radius: 32,
        backgroundImage: AssetImage(logoPath),
        backgroundColor: Colors.grey[200],
      );
    }
  }
}
