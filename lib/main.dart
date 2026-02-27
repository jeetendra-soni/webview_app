import 'package:flutter/material.dart';
import 'package:webview_app/screens/webview_page.dart';
import 'package:webview_app/screens/webview_screen.dart';

import 'core/const/app_strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  WebviewPage(url: AppString.appUrl),
    );
  }
}