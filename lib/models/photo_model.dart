import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:photos_viewer_tutorial/models/user_model.dart';

class Photo extends Equatable {
  final String id;
  final String url;
  final String description;
  final User user;

  const Photo({
    @required this.id,
    @required this.description,
    @required this.url,
    @required this.user,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Photo(
      id: map['id'],
      url: map['urls']['regular'],
      description: map['description'] ?? 'None',
      user: User.fromMap(map['user']),
    );
  }

  @override
  List<Object> get props => [id, url, description, user];

  @override
  bool get stringify => true;
}
