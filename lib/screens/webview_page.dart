import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


class WebviewPage extends StatefulWidget {
  final String url;

  const WebviewPage({
    super.key,
    required this.url,
  });

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late final WebViewController _controller;
  late final Uri _baseUri;

  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _baseUri = Uri.parse(widget.url);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(_navigationDelegate)
      ..loadRequest(_baseUri);
  }

  // ------------------ NAVIGATION LOGIC ------------------ //

  NavigationDelegate get _navigationDelegate => NavigationDelegate(
    onProgress: (progress) {
      setState(() => _progress = progress / 100);
    },
    onPageFinished: (_) {
      setState(() => _progress = 0);
    },
    onNavigationRequest: (request) {
      final uri = Uri.parse(request.url);

      // Special schemes -> external apps
      if (_isSpecialScheme(uri)) {
        _launchExternal(uri);
        return NavigationDecision.prevent;
      }

      // Same domain -> stay inside WebView
      if (_isSameDomain(uri)) {
        return NavigationDecision.navigate;
      }

      // Everything else -> open browser
      _launchExternal(uri);
      return NavigationDecision.prevent;
    },
    onWebResourceError: (error) {
      debugPrint('WebView error: ${error.description}');
    },
  );

  bool _isSameDomain(Uri uri) {
    return uri.host.isNotEmpty &&
        (_baseUri.host.contains(uri.host) ||
            uri.host.contains(_baseUri.host));
  }

  bool _isSpecialScheme(Uri uri) {
    return [
      'tel',
      'mailto',
      'intent',
      'upi',
      'whatsapp',
      'sms',
    ].contains(uri.scheme);
  }

  // ------------------ HELPERS ------------------ //

  Future<void> _launchExternal(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch url: $uri');
    }
  }

  Future<void> _reload() async {
    await _controller.reload();
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  // ------------------ UI ------------------ //

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              if (_progress > 0)
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 2,
                ),
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(
                        controller: _controller
                    ),
                    if (_progress > 0)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
