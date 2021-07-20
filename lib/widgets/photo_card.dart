import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photos_viewer_tutorial/models/models.dart';

class PhotoCard extends StatelessWidget {
  final Photo photo;

  const PhotoCard({
    Key key,
    @required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          )
        ],
        image: DecorationImage(
          image: CachedNetworkImageProvider(photo.url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
