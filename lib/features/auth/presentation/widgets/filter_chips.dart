// lib/features/menu/presentation/widgets/filter_chips.dart
import 'package:flutter/material.dart';
import 'package:fmpglobalinc/core/config/theme.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = ['Top Rated ⭐', 'Sort by', 'Price', 'Promotions'];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filters[index],
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppTheme.primaryPurple.withOpacity(0.3),
              onSelected: (bool selected) {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
