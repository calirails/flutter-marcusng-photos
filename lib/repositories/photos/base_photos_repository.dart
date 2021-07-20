import 'package:photos_viewer_tutorial/models/models.dart';
import 'package:photos_viewer_tutorial/repositories/respositories.dart';

abstract class BasePhotoRepository extends BaseRepository {
  Future<List<Photo>> searchPhotos({String query, int page});
}
