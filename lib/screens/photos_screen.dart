import 'package:flutter/material.dart';
import 'package:photos_viewer_tutorial/models/models.dart';
import 'package:photos_viewer_tutorial/repositories/respositories.dart';
import 'package:photos_viewer_tutorial/widgets/widgets.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => new _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  String _query = 'computers';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: new Scaffold(
          appBar: AppBar(
            title: const Text('Photos'),
          ),
          body: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  fillColor: Colors.white,
                  filled: true,
                ),
                onSubmitted: (text) {
                  final searchPhrase = text.trim();

                  if (searchPhrase.isNotEmpty) {
                    setState(() {
                      _query = searchPhrase;
                    });
                  }
                },
              ),
              Expanded(
                child: FutureBuilder(
                    future: PhotosRepository()
                        .searchPhotos(query: _query, page: 1, perPage: 12),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final List<Photo> photos = snapshot.data;
                        print(photos);
                        return GridView.builder(
                          padding: const EdgeInsets.all(20.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7),
                          itemBuilder: (context, index) {
                            final photo = photos[index];
                            return PhotoCard(photo: photo);
                          },
                          itemCount: photos.length,
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              )
            ],
          )),
    );
  }
}
