# webview_app
# Flutter WebView App

A clean, production-ready Flutter application that displays any website inside a WebView on Android/iOS and provides a graceful fallback on Flutter Web.

This project uses:

* **webview_flutter** for Android & iOS
* **url_launcher** for external browser support
* A **web fallback** (open in new tab) since Flutter Web does not support native WebView

---

## 🚀 Features

* Load any URL inside the app using WebView
* Progress indicator while page loads
* Back navigation support
* Reload webview
* Automatic external-link detection
* Open links in external browser
* Graceful Flutter Web fallback (opens URL in a new tab)
* Global URL launcher helper function

---

## 📂 Project Structure

```
lib/
 ├── main.dart
 ├── webview_page.dart
 └── utils/
      └── url_launcher_helper.dart
```

---

## 📦 Dependencies

Add these in **pubspec.yaml**:

```yaml
dependencies:
  webview_flutter: ^4.0.7
  url_launcher: ^6.1.7
```

Run:

```sh
flutter pub get
```

---

## 🛠️ Android Setup

Add Internet permission in **android/app/src/main/AndroidManifest.xml**:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

Add WebView metadata inside `<application>`:

```xml
<meta-data android:name="io.flutter.embedding.android.WebView" android:value="true"/>
```

### Minimum SDK

Ensure in `android/app/build.gradle`:

```gradle
minSdkVersion 19
```

---

## 🍎 iOS Setup

If your URL is HTTP (not HTTPS), add this to `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

> ⚠️ Recommended: Always use HTTPS.

---

## 💻 Web Support

Flutter Web doesn't support `webview_flutter` natively.
Instead, this project automatically:

* Detects `kIsWeb`
* Opens the requested URL in a **new browser tab**

If you want iframe-based WebView, I can add it.

---

## ▶️ Running the App

### Android/iOS

```sh
flutter run
```

### Web

```sh
flutter run -d chrome
```

> The URL will open in a new tab (web fallback).

---

## 📘 How It Works

### WebView Initialization

Uses latest recommended syntax:

```dart
_controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(...)
  ..loadRequest(Uri.parse(widget.url));
```

### Handling external links

If a link's host differs from the main domain, it is opened externally.

### Global URL Launcher Helper

```dart
UrlLauncherHelper.openExternal(url);
UrlLauncherHelper.openInNewTab(url);
```

---

## 🧪 Customization Ideas

* Pull-to-refresh
* JS → Flutter communication
* Custom headers & user-agent
* Navigation buttons (forward/back)
* Error UI for 404 / no internet

---

## 🤝 Contributing

Feel free to request enhancements — I can:

* Add iframe embedding for web
* Convert to a full GitHub-style project
* Add dark mode
* Add safe-area handling and custom loading UI

---

## 📄 License

This template is free for personal and commercial use.

---

If you'd like, I can **export the entire project as a ZIP** or **create a GitHub-ready folder structure**. Just tell me!

## 📸 Screenshots

(Add your app screenshots here)

---

## 🛡️ Badges

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📂 Folder Structure

```
lib/
 ├── main.dart
 ├── core/
 │    ├── utils/
 │    │     └── url_launcher.dart
 ├── webview/
 │    ├── webview_screen.dart
 │    └── controller.dart
 assets/
   └── icons/
```

---

## 🎞️ Demo GIF

(Add a GIF showing the app in action)

---

## 📌 Version History

### v1.0.0

* Initial release
* Added WebView
* Added global URL launcher
* Added navigation handling

---

## 🤝 Contributing

Pull Requests are welcome!

---

## 📜 License

This project is licensed under the MIT License.

