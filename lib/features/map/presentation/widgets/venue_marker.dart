// lib/features/map/presentation/widgets/venue_marker.dart
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class VenueMarker {
  static Future<PointAnnotationOptions> create({
    required String logoPath,
    required Point geometry, // Change the type to Point
    double size = 48.0,
  }) async {
    // Create a circular bitmap with the venue logo
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()
      ..color = Colors.purple.shade800
      ..style = PaintingStyle.fill;

    // Draw circle background
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    // Draw border
    paint
      ..color = Colors.purple.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2 - 1,
      paint,
    );

    // Convert to image
    final ui.Image image = await recorder.endRecording().toImage(
          size.toInt(),
          size.toInt(),
        );
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List bytes = byteData!.buffer.asUint8List();

    // Create annotation options
    return PointAnnotationOptions(
      geometry: geometry,
      image: bytes,
      iconSize: 1.0,
      iconOffset: [0, -size / 2],
    );
  }
}
