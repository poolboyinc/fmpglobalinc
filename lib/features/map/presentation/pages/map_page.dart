import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fmpglobalinc/core/services/service_locator.dart';
import 'package:fmpglobalinc/features/map/data/models/venue_model.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:fmpglobalinc/core/config/mapbox_config.dart';
import 'package:fmpglobalinc/features/map/presentation/widgets/map_search_bar.dart';
import 'package:fmpglobalinc/features/map/presentation/widgets/venue_bottom_sheet.dart';
import 'package:fmpglobalinc/features/map/presentation/widgets/party_bottom_sheet.dart';
import 'package:fmpglobalinc/features/map/presentation/widgets/party_marker.dart';
import 'package:fmpglobalinc/features/map/presentation/widgets/venue_marker.dart';
import 'package:fmpglobalinc/features/parties/domain/entities/party.dart';
import 'package:fmpglobalinc/features/parties/presentation/bloc/party_bloc.dart';
import 'package:fmpglobalinc/features/parties/presentation/bloc/party_event.dart';
import 'package:fmpglobalinc/features/parties/presentation/bloc/party_state.dart';

class MapPage extends StatefulWidget {
  final void Function(int index) onNavigateToTab;

  const MapPage({Key? key, required this.onNavigateToTab}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapboxMap? mapboxMap;
  VenueModel? selectedVenue;
  PartyEntity? selectedParty;
  bool isLoadingPartyMarkers = false;
  bool isLoadingVenueMarkers = false;
  bool isMapReady = false;
  bool isPreloadingData = true;

  List<VenueModel> venues = [];
  List<PartyEntity> parties = [];

  List<Map<String, dynamic>>? _preparedPartyData;
  List<Map<String, dynamic>>? _preparedVenueData;

  late PartyBloc _partyBloc;

  @override
  void initState() {
    super.initState();
    _partyBloc = sl<PartyBloc>();
    _preloadData();
  }

  Future<void> _preloadData() async {
    await Future.delayed(Duration.zero);

    await _loadVenueData();

    _partyBloc.add(const GetPartiesEvent());

    _preparedVenueData = await compute(_prepareVenueData, venues);

    setState(() {
      isPreloadingData = false;
    });

    if (isMapReady && mapboxMap != null) {
      _addVenueMarkers();
    }
  }

  Future<void> _loadVenueData() async {
    venues = VenueModel.getMockVenues();
  }

  Future<void> _onMapCreated(MapboxMap map) async {
    print("⏳ Map widget created, initializing...");
    final startTime = DateTime.now();

    mapboxMap = map;

    mapboxMap?.loadStyleURI(MapboxConfig.styleUrl).then((_) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print("✅ Map style loaded in ${duration.inMilliseconds}ms");

      setState(() {
        isMapReady = true;
      });

      if (!isPreloadingData && _preparedVenueData != null) {
        _addVenueMarkers();
      }

      if (parties.isNotEmpty && _preparedPartyData != null) {
        _addPartyMarkers();
      }
    });
  }

  static List<Map<String, dynamic>> _preparePartyData(
    List<PartyEntity> parties,
  ) {
    print("⏳ Processing party data in background");
    final startTime = DateTime.now();

    final result =
        parties.map((party) {
          return {
            'id': party.id,
            'latitude': party.latitude,
            'longitude': party.longitude,
            'logoPath': party.logoUrl,
          };
        }).toList();

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    print("✅ Party data processed in ${duration.inMilliseconds}ms");

    return result;
  }

  static List<Map<String, dynamic>> _prepareVenueData(List<VenueModel> venues) {
    print("⏳ Processing venue data in background");
    final startTime = DateTime.now();

    final result =
        venues.map((venue) {
          return {
            'id': venue.id,
            'latitude': venue.latitude,
            'longitude': venue.longitude,
            'logoPath': venue.logo,
          };
        }).toList();

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    print("✅ Venue data processed in ${duration.inMilliseconds}ms");

    return result;
  }

  Future<void> _addVenueMarkers() async {
    if (venues.isEmpty || _preparedVenueData == null) return;

    setState(() {
      isLoadingVenueMarkers = true;
    });

    try {
      print("⏳ Starting venue marker creation");
      final startTime = DateTime.now();

      final pointAnnotationManager =
          await mapboxMap?.annotations.createPointAnnotationManager();

      final batchSize = 5;
      final venueInfo = _preparedVenueData!;

      for (int i = 0; i < venueInfo.length; i += batchSize) {
        final end =
            (i + batchSize < venueInfo.length)
                ? i + batchSize
                : venueInfo.length;
        final batch = venueInfo.sublist(i, end);

        if (i > 0) {
          await Future.delayed(const Duration(milliseconds: 10));
        }

        for (final info in batch) {
          final geometry = Point(
            coordinates: Position(info['longitude'], info['latitude']),
          );

          final markerOptions = await VenueMarker.create(
            logoPath: info['logoPath'],
            geometry: geometry,
          );

          await pointAnnotationManager?.create(markerOptions);
        }
      }

      pointAnnotationManager?.addOnPointAnnotationClickListener(
        _VenueClickListener(
          venues: venues,
          onVenueSelected: (VenueModel venue) {
            setState(() {
              selectedVenue = venue;
              selectedParty = null;
            });
          },
        ),
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print(
        "✅ Completed venue marker creation in ${duration.inMilliseconds}ms",
      );
    } catch (e) {
      print('Error adding venue markers: $e');
    } finally {
      setState(() {
        isLoadingVenueMarkers = false;
      });
    }
  }

  Future<void> _addPartyMarkers() async {
    if (parties.isEmpty || _preparedPartyData == null) return;

    setState(() {
      isLoadingPartyMarkers = true;
    });

    try {
      print("⏳ Starting party marker creation");
      final startTime = DateTime.now();

      final pointAnnotationManager =
          await mapboxMap?.annotations.createPointAnnotationManager();

      final batchSize = 5;
      final partyInfo = _preparedPartyData!;

      for (int i = 0; i < partyInfo.length; i += batchSize) {
        final end =
            (i + batchSize < partyInfo.length)
                ? i + batchSize
                : partyInfo.length;
        final batch = partyInfo.sublist(i, end);

        if (i > 0) {
          await Future.delayed(const Duration(milliseconds: 10));
        }

        for (final info in batch) {
          final geometry = Point(
            coordinates: Position(info['longitude'], info['latitude']),
          );

          final markerOptions = await PartyMarker.create(
            logoPath: info['logoPath'],
            geometry: geometry,
          );

          await pointAnnotationManager?.create(markerOptions);
        }
      }

      pointAnnotationManager?.addOnPointAnnotationClickListener(
        _PartyClickListener(
          parties: parties,
          onPartySelected: (PartyEntity party) {
            setState(() {
              selectedParty = party;
              selectedVenue = null;
            });
          },
        ),
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print(
        "✅ Completed party marker creation in ${duration.inMilliseconds}ms",
      );
    } catch (e) {
      print('Error adding party markers: $e');
    } finally {
      setState(() {
        isLoadingPartyMarkers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PartyBloc, PartyState>(
      bloc: _partyBloc,
      listener: (context, state) {
        if (state is PartiesLoaded) {
          print(
            "✅ Parties loaded from Firestore: ${state.parties.length} parties",
          );
          setState(() {
            parties = state.parties;
          });

          compute(_preparePartyData, parties).then((data) {
            setState(() {
              _preparedPartyData = data;
            });

            if (isMapReady && mapboxMap != null) {
              _addPartyMarkers();
            }
          });
        } else if (state is PartyError) {
          print("❌ Error loading parties: ${state.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading parties: ${state.message}')),
          );
        } else if (state is PartyLoading) {
          print("⏳ Loading parties from Firestore...");
        }
      },
      child: Stack(
        children: [
          MapWidget(
            styleUri: MapboxConfig.styleUrl,
            key: const ValueKey("mapWidget"),
            mapOptions: MapOptions(
              constrainMode: ConstrainMode.HEIGHT_ONLY,
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

          if (!isMapReady)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    const Text("Loading map..."),
                  ],
                ),
              ),
            ),

          const MapSearchBar(),

          if (isLoadingPartyMarkers || isLoadingVenueMarkers)
            Positioned(
              top: 100,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Loading markers...',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

          if (selectedVenue != null)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: VenueBottomSheet(
                venue: selectedVenue!,
                onClose: () => setState(() => selectedVenue = null),
              ),
            ),

          if (selectedParty != null)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: PartyBottomSheet(
                party: selectedParty!,
                onClose: () => setState(() => selectedParty = null),
              ),
            ),
        ],
      ),
    );
  }
}

class _PartyClickListener extends OnPointAnnotationClickListener {
  final List<PartyEntity> parties;
  final Function(PartyEntity) onPartySelected;

  _PartyClickListener({required this.parties, required this.onPartySelected});

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    final Point? point = annotation.geometry;

    if (point != null) {
      final Position coordinates = point.coordinates;

      final partyIndex = parties.indexWhere(
        (p) =>
            (p.latitude - coordinates.lat).abs() < 0.0001 &&
            (p.longitude - coordinates.lng).abs() < 0.0001,
      );

      if (partyIndex != -1) {
        onPartySelected(parties[partyIndex]);
      }
    }

    return true;
  }
}

class _VenueClickListener extends OnPointAnnotationClickListener {
  final List<VenueModel> venues;
  final Function(VenueModel) onVenueSelected;

  _VenueClickListener({required this.venues, required this.onVenueSelected});

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    final Point? point = annotation.geometry;

    if (point != null) {
      final Position coordinates = point.coordinates;

      final venueIndex = venues.indexWhere(
        (v) =>
            (v.latitude - coordinates.lat).abs() < 0.0001 &&
            (v.longitude - coordinates.lng).abs() < 0.0001,
      );

      if (venueIndex != -1) {
        onVenueSelected(venues[venueIndex]);
      }
    }

    return true;
  }
}
