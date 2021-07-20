import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photos_viewer_tutorial/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<Photo> photos;
  final int currentIndex;

  const PhotoViewerScreen(
      {Key key, @required this.photos, @required this.currentIndex})
      : super(key: key);

  @override
  _PhotoViewerScreenState createState() => new _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    this._pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Text('Photo Viewer'),
      ),
      body: PageView.builder(
          controller: _pageController,
          itemCount: widget.photos.length,
          itemBuilder: (context, index) {
            final photo = widget.photos[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: photo.url,
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, err) => Center(
                      child: const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50.0,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 11.0, horizontal: 11.0),
                  child: Column(
                    children: [
                      Text('(No: ${index + 1} of ${widget.photos.length})'),
                      const SizedBox(
                        height: 21.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            photo.description,
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 21.0,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.grey[100],
                            backgroundImage: CachedNetworkImageProvider(
                                photo.user.profileImageUrl),
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final avatarUrl = photo.user.profileUrl;
                              if (await canLaunch(avatarUrl)) {
                                await launch(avatarUrl);
                              }
                            },
                            child: Text(photo.user.name,
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
