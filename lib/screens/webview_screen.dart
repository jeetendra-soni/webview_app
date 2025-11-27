import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_app/core/const/app_strings.dart';
import 'package:webview_app/screens/webview_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatelessWidget {
  const WebviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.appName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Open website inside the app (WebView on mobile). On web, a fallback will open the page in a new tab.', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Open in WebView'),
                onPressed: () {
                  if (kIsWeb) {
                    // On web, open in new tab as embedded WebView isn't supported the same way
                    _openInNewTab(AppString.appUrl);
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => WebviewPage(url: AppString.appUrl)));
                  }
                },
              ),
              const SizedBox(height: 12),
              TextButton.icon(icon: const Icon(Icons.open_in_new), label: const Text('Open in external browser'), onPressed: () => _launchExternal(AppString.appUrl)),
            ],
          ),
        ),
      ),
    );
  }

  void _openInNewTab(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, webOnlyWindowName: '_blank')) {
      // ignore: avoid_print
      print('Could not launch \$url');
    }
  }

  void _launchExternal(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: avoid_print
      print('Could not launch external browser for \$url');
    }
  }
}
