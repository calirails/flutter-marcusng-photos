import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photos_viewer_tutorial/widgets/widgets.dart';
import 'package:photos_viewer_tutorial/blocs/blocs.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => new _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  // String _query = 'computers'; // now encaspulated inside of (BLOC) PhotosState
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            context.read<PhotosBloc>().state.status !=
                PhotosStatus.paginating) {
          context.read<PhotosBloc>().add(PaginatePhotos());
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: new Scaffold(
          appBar: AppBar(
            title: const Text('Photos'),
          ),
          body: BlocConsumer<PhotosBloc, PhotosState>(
            listener: (context, state) {
              if (state.status == PhotosStatus.paginating) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: const Text('Loading more photos'),
                    duration: Duration(milliseconds: 200)));
              } else if (state.status == PhotosStatus.lastPageReached) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.orange,
                    content: const Text('Reached "The End" of photos'),
                    duration: Duration(milliseconds: 700)));
              } else if (state.status == PhotosStatus.error) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Search Error'),
                          content: Text(state.failure.message),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'))
                          ],
                        ));
              }
            },
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Column(
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
                            // get a reference to BLOC to trigger query
                            context
                                .read<PhotosBloc>()
                                .add(SearchPhotos(query: searchPhrase));
                          }
                        },
                      ),
                      // if (state.status == PhotosStatus.loaded)
                      Expanded(
                          child: state.photos.isNotEmpty
                              ? GridView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(20.0),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.7),
                                  itemBuilder: (context, index) {
                                    final photo = state.photos[index];
                                    return PhotoCard(
                                        photo: photo,
                                        photos: state.photos,
                                        currentIndex: index);
                                  },
                                  itemCount: state.photos.length,
                                )
                              : Center(
                                  child: const Text(
                                      'No results found. Please try other searches.')))
                    ],
                  ),
                  if (state.status == PhotosStatus.loading)
                    CircularProgressIndicator(),
                ], // children
              );
            },
          )),
    );
  }
}
