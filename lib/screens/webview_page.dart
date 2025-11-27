import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  const WebviewPage({super.key, required this.url});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late final WebViewController _controller;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    // For Android, initialize Hybrid Composition (if needed) - webview_flutter handles this internally in recent versions.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() => _progress = progress / 100.0);
          },
          onPageStarted: (url) {},
          onPageFinished: (url) {
            setState(() => _progress = 0);
          },
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);

              _launchExternal(uri);
              return NavigationDecision.prevent;
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {
          setState(() => _progress = progress / 100.0);
        },
        onPageStarted: (url) {
          // ignore: avoid_print
          print('Page started loading: \$url');
        },
        onPageFinished: (url) {
          setState(() => _progress = 0);
        },
        onNavigationRequest: (request) {
          // Example: open external links in external browser
          final uri = Uri.parse(request.url);
          _launchExternal(uri);
          return NavigationDecision.prevent;
        },
        onWebResourceError: (error) {
          // handle errors
          // ignore: avoid_print
          print('Web resource error: \${error.description}');
        },
      ),
    );
  }

  Future<void> _launchExternal(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: avoid_print
      print('Could not launch external: \$uri');
    }
  }

  Future<void> _reload() async {
    if (!kIsWeb) {
      await _controller.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Embedded webview on Flutter web is complex. Provide a helpful fallback.
      return Scaffold(
        appBar: AppBar(title: const Text('Web (fallback)')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Web builds cannot use native WebView. Open the site in a new tab.'),
              ),
              ElevatedButton(
                onPressed: () => _launchExternal(Uri.parse(widget.url)),
                child: const Text('Open in New Tab'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('WebView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
            tooltip: 'Reload',
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => _launchExternal(Uri.parse(widget.url)),
            tooltip: 'Open in external browser',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_progress > 0)
            SizedBox(height: 3, child: LinearProgressIndicator(value: _progress, minHeight: 3)),
          if (_progress > 0)Expanded(child: Container(color: Colors.white, child: Center(child: SizedBox(height: 200, width: 200, child: Image(image: const AssetImage('assets/icons/logo.png')))))),
          if (_progress <= 0)Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.arrow_back),
      //   onPressed: () async {
      //     if (await _controller.canGoBack()) {
      //       await _controller.goBack();
      //       return;
      //     }
      //     if (Platform.isAndroid || Platform.isIOS) {
      //       // pop the screen
      //       if (mounted) Navigator.of(context).pop();
      //     }
      //   },
      // ),
    );
  }
}
