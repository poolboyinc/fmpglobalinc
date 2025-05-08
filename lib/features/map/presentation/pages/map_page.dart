// lib/features/map/presentation/pages/map_page.dart
import 'package:fmpglobalinc/core/config/mapbox_config.dart';
import 'package:fmpglobalinc/features/map/data/models/venue_model.dart';
import 'package:fmpglobalinc/features/map/presentation/widgets/map_search_bar.dart';
import 'package:fmpglobalinc/features/map/presentation/widgets/venue_bottom_sheet.dart';
import 'package:fmpglobalinc/features/map/presentation/widgets/venue_marker.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final void Function(int index) onNavigateToTab;

  const MapPage({Key? key, required this.onNavigateToTab}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapboxMap? mapboxMap;
  VenueModel? selectedVenue;
  final venues = VenueModel.getMockVenues();

  _onMapCreated(MapboxMap map) async {
    mapboxMap = map;
    await mapboxMap?.loadStyleURI(MapboxConfig.styleUrl);
    _addVenueMarkers();
  }

  Future<void> _addVenueMarkers() async {
    final pointAnnotationManager =
        await mapboxMap?.annotations.createPointAnnotationManager();

    for (final venue in venues) {
      // Create Point geometry correctly
      final geometry = Point(
        coordinates: Position(venue.longitude, venue.latitude),
      );

      // Create custom marker
      final markerOptions = await VenueMarker.create(
        logoPath: venue.logo,
        geometry: geometry,
      );

      await pointAnnotationManager?.create(markerOptions);

      pointAnnotationManager?.addOnPointAnnotationClickListener(
        (annotation) {
              final venueIndex = venues.indexWhere(
                (v) =>
                    v.latitude == annotation.point.coordinates[1] &&
                    v.longitude == annotation.point.coordinates[0],
              );
              if (venueIndex != -1) {
                setState(() => selectedVenue = venues[venueIndex]);
              }
              return true;
            }
            as OnPointAnnotationClickListener,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            styleUri: MapboxConfig.styleUrl,
            key: const ValueKey("mapWidget"),
            mapOptions: MapOptions(
              contextMode: ContextMode.UNIQUE,
              pixelRatio: MediaQuery.of(context).devicePixelRatio,
            ),
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(
                  MapboxConfig.initialLongitude,
                  MapboxConfig.initialLatitude,
                ),
              ),
              zoom: MapboxConfig.initialZoom,
            ),
            onMapCreated: _onMapCreated,
          ),
          const MapSearchBar(),
          if (selectedVenue != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VenueBottomSheet(
                venue: selectedVenue!,
                onClose: () => setState(() => selectedVenue = null),
              ),
            ),
        ],
      ),
    );
  }
}
