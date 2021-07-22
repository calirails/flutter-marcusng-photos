import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:photos_viewer_tutorial/models/models.dart';

enum PhotosStatus {
  initial,
  loading,
  loaded,
  paginating,
  lastPageReached,
  error
}

class PhotosState extends Equatable {
  final String query;
  final List<Photo> photos;
  final PhotosStatus status;
  final Failure failure;

  const PhotosState({
    @required this.query,
    @required this.photos,
    @required this.status,
    @required this.failure,
  });

  factory PhotosState.initial() {
    return PhotosState(
        query: '', photos: [], status: PhotosStatus.initial, failure: null);
  }

  @override
  List<Object> get props => [query, photos, status, failure];

  PhotosState copyWith({
    String query,
    List<Photo> photos,
    PhotosStatus status,
    Failure failure,
  }) {
    return PhotosState(
        query: query ?? this.query,
        photos: photos ?? this.photos,
        status: status ?? this.status,
        failure: failure ?? this.failure);
  }
}
