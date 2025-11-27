import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  /// Open URL in external browser
  static Future<bool> openExternal(String url) async {
    final uri = Uri.parse(url);
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Open URL in a new tab (Web only)
  static Future<bool> openInNewTab(String url) async {
    final uri = Uri.parse(url);
    return await launchUrl(uri, webOnlyWindowName: '_blank');
  }
}