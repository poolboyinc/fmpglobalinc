import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_chips.dart';
import '../widgets/party_card.dart';

class MenuPage extends StatelessWidget {
  final void Function(int index) onNavigateToTab;

  const MenuPage({Key? key, required this.onNavigateToTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No Scaffold here, just return the content
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          const CustomSearchBar(),
          const FilterChips(),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSection('Popping tonight 🔥'),
                  _buildPartyList(context),
                  const SizedBox(height: 20),
                  _buildSection('Your favorites'),
                  _buildPartyList(context),
                  const SizedBox(height: 20),
                  _buildSection('Nearby'),
                  _buildPartyList(context),
                  // Add extra bottom padding to account for nav bar
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPartyList(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder:
            (context, index) => GestureDetector(
              onTap: () => onNavigateToTab(0), // ← go to map tab
              child: const PartyCard(),
            ),
      ),
    );
  }
}
