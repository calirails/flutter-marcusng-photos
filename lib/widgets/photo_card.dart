import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photos_viewer_tutorial/models/models.dart';
import 'package:photos_viewer_tutorial/screens/screens.dart';

class PhotoCard extends StatelessWidget {
  final Photo photo;
  final List<Photo> photos;
  final int currentIndex;

  const PhotoCard({
    Key key,
    @required this.photo,
    @required this.photos,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PhotoViewerScreen(
              photos: this.photos, currentIndex: this.currentIndex))),
      child: Hero(
        tag: Key('${this.currentIndex}_${this.photo.id}'),
        child: new Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(1.2),
            boxShadow: const [
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
        ),
      ),
    );
  }
}
