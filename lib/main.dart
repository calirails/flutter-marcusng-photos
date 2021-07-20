import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photos_viewer_tutorial/screens/screens.dart';

void main() {
  runApp(MyApp());
  EquatableConfig.stringify = kDebugMode;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        title: 'Photos Viewer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: PhotoScreen(),
      ),
    );
  }
}
