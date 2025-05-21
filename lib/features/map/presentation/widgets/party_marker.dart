import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart' hide Size;
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PartyMarker {
  static Future<PointAnnotationOptions> create({
    required String logoPath,
    required Point geometry,
  }) async {
    // Draw custom marker directly using Canvas
    final Uint8List? markerImage = await _drawCustomMarker(logoPath);

    if (markerImage == null) {
      throw Exception('Failed to create marker image');
    }

    // Create marker options
    final options = PointAnnotationOptions(
      geometry: geometry,
      image: markerImage,
      iconSize: 1.0,
      iconAnchor: IconAnchor.BOTTOM,
    );

    return options;
  }

  static Future<Uint8List?> _drawCustomMarker(String logoPath) async {
    try {
      // Load logo image - handle both assets and network URLs
      ui.Image logoImage;

      if (logoPath.startsWith('http')) {
        // Load from network URL
        final completer = Completer<ui.Image>();
        final imageProvider = NetworkImage(logoPath);

        imageProvider
            .resolve(const ImageConfiguration())
            .addListener(
              ImageStreamListener(
                (info, _) {
                  completer.complete(info.image);
                },
                onError: (error, stackTrace) {
                  print('Error loading logo image: $error');
                  completer.completeError(
                    'Failed to load network image: $error',
                  );
                },
              ),
            );

        try {
          logoImage = await completer.future;
        } catch (e) {
          print('Using fallback image due to error: $e');
          // Load fallback image from assets if network image fails
          final ByteData logoData = await rootBundle.load(
            'assets/images/party_default.png',
          );
          final ui.Codec logoCodec = await ui.instantiateImageCodec(
            logoData.buffer.asUint8List(),
          );
          final ui.FrameInfo logoFrame = await logoCodec.getNextFrame();
          logoImage = logoFrame.image;
        }
      } else {
        // Load from assets
        try {
          final ByteData logoData = await rootBundle.load(logoPath);
          final ui.Codec logoCodec = await ui.instantiateImageCodec(
            logoData.buffer.asUint8List(),
          );
          final ui.FrameInfo logoFrame = await logoCodec.getNextFrame();
          logoImage = logoFrame.image;
        } catch (e) {
          print('Error loading asset logo, using default: $e');
          // Load default image if specified asset doesn't exist
          final ByteData logoData = await rootBundle.load(
            'assets/images/party_default.png',
          );
          final ui.Codec logoCodec = await ui.instantiateImageCodec(
            logoData.buffer.asUint8List(),
          );
          final ui.FrameInfo logoFrame = await logoCodec.getNextFrame();
          logoImage = logoFrame.image;
        }
      }

      // Create a recorder and canvas
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      final ui.Size size = ui.Size(120, 120);

      // Draw purple circle with white border
      final Paint circlePaint = Paint()..color = Colors.purple;
      final Paint borderPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      final Offset center = Offset(size.width / 2, size.height / 2);
      final double circleRadius = 55;

      // Draw circle and border
      canvas.drawCircle(center, circleRadius, circlePaint);
      canvas.drawCircle(center, circleRadius, borderPaint);

      // Draw shadow
      final Paint shadowPaint =
          Paint()
            ..color = Colors.black.withOpacity(0.3)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);

      canvas.drawCircle(center.translate(0, 2), circleRadius + 2, shadowPaint);

      // Draw logo in center
      final double logoSize = 70;
      final Rect logoRect = Rect.fromCenter(
        center: center,
        width: logoSize,
        height: logoSize,
      );

      // Clip to circular shape for logo
      canvas.save();
      final Path clipPath =
          Path()..addOval(Rect.fromCircle(center: center, radius: 35));
      canvas.clipPath(clipPath);

      // Draw logo
      canvas.drawImageRect(
        logoImage,
        Rect.fromLTWH(
          0,
          0,
          logoImage.width.toDouble(),
          logoImage.height.toDouble(),
        ),
        logoRect,
        Paint(),
      );

      canvas.restore();

      // Get the picture and convert to image
      final ui.Picture picture = recorder.endRecording();
      final ui.Image image = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      // Clean up
      logoImage.dispose();
      image.dispose();

      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error creating marker image: $e');
      return null;
    }
  }
}
