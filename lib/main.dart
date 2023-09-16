import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await Permission.storage.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World South Africa Pageants',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = "https://www.wsap.africa";
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: WillPopScope(
        onWillPop: () async {
          if (await _webViewController.canGoBack()) {
            _webViewController.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              _webViewController = controller;
            },
            navigationDelegate: (NavigationRequest request) async {
              if (request.url
                  .startsWith('https://api.whatsapp.com/send?phone')) {
                String phone = "27781892545";
                String message = "Hi";

                final url = "https://wa.me/$phone/?text=${Uri.parse(message)}";
                //"whatsapp://send?phone='27781892545'&text=${Uri.parse("Hi,")}";
                await openBrowserUrl(url: url, inApp: false);
                return NavigationDecision.prevent;
              }

              if (request.url.startsWith('https://www.instagram.com/')) {
                final url =
                    "https://www.instagram.com/worldsouthafricapageants/";
                await openBrowserUrl(url: url, inApp: false);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      ),
    );
  }
}

Future openBrowserUrl({
  required String url,
  bool inApp = false,
}) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }
}

Future openBrowserUrlwsap({
  required String url,
  bool inApp = true,
}) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(
      url,
      mode: LaunchMode.inAppWebView,
    );
  }
}

_launchurl(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'could not launch $url';
  }
}
/*

                List<String> urlsplitted = request.url.split("&text=");

                String phone = "27781892545";
                String message =
                    urlsplitted.last.toString().replaceAll("%20", " ");

                await _launchurl(
                  "whatsapp://send?phone=$phone&text=${Uri.parse(message)}",
                );
                */