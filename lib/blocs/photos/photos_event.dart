import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PhotosEvent extends Equatable {
  const PhotosEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SearchPhotos extends PhotosEvent {
  final String query;

  const SearchPhotos({@required this.query});

  @override
  List<Object> get props => [query];
}

class PaginatePhotos extends PhotosEvent {}
