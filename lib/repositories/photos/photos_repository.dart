import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:photos_viewer_tutorial/models/photo_model.dart';
import 'package:photos_viewer_tutorial/repositories/respositories.dart';
import 'package:http/http.dart' as http;
import 'package:photos_viewer_tutorial/.env.dart';

class PhotosRepository extends BasePhotoRepository {
  static const String _unsplashBaseUrl = 'https://api.unsplash.com';
  final http.Client _httpClient;

  PhotosRepository({http.Client httpClient})
      : _httpClient = httpClient ?? new http.Client();

  @override
  void dispose() {
    _httpClient.close();
  }

  @override
  Future<List<Photo>> searchPhotos(
      {@required String query, int page = 1, int perPage = 12}) async {
    final url =
        '$_unsplashBaseUrl/search/photos?client_id=$UnpsplashApiKey&query=$query&page=$page&per_page=$perPage';
    final response = await _httpClient.get(Uri.tryParse(url));

    if (response.statusCode != 200) {
      return [];
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List results = data['results'];
    final List<Photo> photos =
        results.map((photo) => Photo.fromMap(photo)).toList();

    return photos;
  }
}
