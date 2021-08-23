import 'package:core_utils/core_utils.dart';
import 'package:tile/tile.dart';

class BackgroundWallpaperTileModel implements ITileModel {
  const BackgroundWallpaperTileModel({
    required this.minithumbnail,
    required this.thumbnailImageId,
  });

  final Minithumbnail? minithumbnail;
  final int? thumbnailImageId;
}
