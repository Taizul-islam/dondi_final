import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/const.dart';


class WebViewScreen extends StatefulWidget {
  final int type;

  WebViewScreen(this.type);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params = const PlatformWebViewControllerCreationParams();


    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(getWebUrl()));

    // #docregion platform_features

    // #enddocregion platform_features

    _controller = controller;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Platform.isAndroid?Brightness.dark:Brightness.light,
          statusBarBrightness: Platform.isAndroid?Brightness.dark:Brightness.light,
          statusBarColor: Colors.white
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 55,
                child: Stack(
                  children: [
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        getTitle(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.3,
                color: colorTextLight,
              ),
              Expanded(
                child: WebViewWidget(controller: _controller,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTitle() {
    String title = 'Help';
    if (widget.type == 2) {
      title = 'Terms of use';
    } else if (widget.type == 3) {
      title = 'Privacy Policy';
    }
    return title;
  }

  String getWebUrl() {
    String title = ConstRes.helpUrl;
    if (widget.type == 2) {
      title = ConstRes.termsOfUseUrl;
    } else if (widget.type == 3) {
      title = ConstRes.privacyUrl;
    }
    return title;
  }
}
