import 'dart:convert';
import 'dart:ui' as ui;

class QrImageCache {
  static final Map<String, ui.Image> _imageCache = {};

  static Future<ui.Image?> getQrImage(String base64String) async {
    final cacheKey = 'qr_$base64String.hashCode';

    if (_imageCache.containsKey(cacheKey)) {
      return _imageCache[cacheKey];
    }

    try {
      final bytes = base64Decode(base64String.split(',').last);
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      _imageCache[cacheKey] = image;
      return image;
    } catch (e) {
      return null;
    }
  }

  static void clear() {
    _imageCache.clear();
  }
}