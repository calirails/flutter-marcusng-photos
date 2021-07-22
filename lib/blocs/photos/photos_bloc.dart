import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:photos_viewer_tutorial/blocs/blocs.dart';
import 'package:photos_viewer_tutorial/models/models.dart';
import 'package:photos_viewer_tutorial/repositories/respositories.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepository _repository;

  PhotosBloc({@required PhotosRepository repository})
      : _repository = repository,
        super(PhotosState.initial());

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }

  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    try {
      if (event is SearchPhotos) {
        print(event.query);
        yield* _mapSearchPhotosToState(event);
      }

      if (event is PaginatePhotos) {
        yield* _mapPaginatePhotos(event);
      }
    } catch (_, stackTrace) {
      developer.log('$_', name: 'PhotosBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }

  Stream<PhotosState> _mapSearchPhotosToState(SearchPhotos event) async* {
    yield state.copyWith(query: event.query, status: PhotosStatus.loading);

    try {
      final photos = await _repository.searchPhotos(query: event.query);
      yield state.copyWith(photos: photos, status: PhotosStatus.loaded);
    } catch (err) {
      print(
          '[[ PhotosBloc::_mapSearchPhotosToState ]] failed with error: $err');
      yield state.copyWith(
          failure: Failure(message: 'Search failed. Try again?'),
          status: PhotosStatus.error);
    }
  }

  Stream<PhotosState> _mapPaginatePhotos(PaginatePhotos event) async* {
    yield state.copyWith(status: PhotosStatus.paginating);

    try {
      final photos = List<Photo>.from(state.photos);

      List<Photo> nextPhotos = [];
      // NOTE: here 12 is equivalent to value of Number Per Page set on original query
      // This value should be configurable and maintained as its own query metadata state
      const int PHOTOS_PER_PAGE = 12;
      if (photos.length >= PHOTOS_PER_PAGE) {
        nextPhotos = await _repository.searchPhotos(
          query: state.query,
          page: state.photos.length ~/ PHOTOS_PER_PAGE + 1,
        );
      }

      yield state.copyWith(
          photos: photos..addAll(nextPhotos),
          status: nextPhotos.isNotEmpty
              ? PhotosStatus.loaded
              : PhotosStatus.lastPageReached);
    } catch (err) {
      print(
          '[[ PhotosBloc::_mapSearchPhotosToState ]] failed with error: $err');
      yield state.copyWith(
          failure: Failure(message: 'Search failed. Try again?'),
          status: PhotosStatus.error);
    }
  }
}
