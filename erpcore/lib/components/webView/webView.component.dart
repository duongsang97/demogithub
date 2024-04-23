import 'dart:collection';
import 'dart:io';

import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewComponent extends StatefulWidget {
  const WebViewComponent({super.key,required this.url,this.controller,this.onWebViewCreated,this.headers,this.onLoadStart,this.onLoadStop,this.userAgent=""});
  final Uri url;
  final InAppWebViewController? controller;
  final Function(InAppWebViewController)? onWebViewCreated;
  final Map<String, String>? headers;
  final Function(InAppWebViewController controller, Uri? uri)? onLoadStop;
  final Function(InAppWebViewController controller, Uri? uri)? onLoadStart;
  final String userAgent;
  @override
  State<WebViewComponent> createState() => _WebViewComponentState();
}

class _WebViewComponentState extends State<WebViewComponent> {
  PullToRefreshController pullToRefreshController = PullToRefreshController();
  InAppWebViewSettings settings = InAppWebViewSettings();
  
  @override
  void initState() {
    try{
      pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(
          color: Colors.blue,
        ),
        onRefresh: () async {
          if (defaultTargetPlatform == TargetPlatform.android) {
            widget.controller?.reload();
          } else if (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS) {
            widget.controller?.loadUrl(urlRequest:URLRequest(url: await widget.controller?.getUrl()));
          }
        },
      );
      settings = InAppWebViewSettings(
        userAgent: widget.userAgent,
        useShouldOverrideUrlLoading:true,
        useHybridComposition: true,
        allowsInlineMediaPlayback: true,
        isInspectable: kDebugMode,
        mediaPlaybackRequiresUserGesture: false,
        iframeAllow: "camera; microphone",
        iframeAllowFullscreen: true
      );
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "initState WebViewComponent");
    }
    //initWebPage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //  Future<void> initWebPage() async{
  //   if (Platform.isAndroid) {
  //     var swAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
  //     var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
  //     if (swAvailable && swInterceptAvailable) {
  //       AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();
  //     await serviceWorkerController.setServiceWorkerClient(AndroidServiceWorkerClient(
  //       shouldInterceptRequest: (request) async {
  //         return null;
  //       },));
  //     }
  //   }
  //}
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialSettings: settings,
      pullToRefreshController: pullToRefreshController,
      initialUserScripts: UnmodifiableListView<UserScript>([]),
      onWebViewCreated: (controller) async{
        if(widget.onWebViewCreated != null){
          widget.onWebViewCreated!(controller);
        }
        // if(widget.url.path.isNotEmpty){
        //   controller.loadUrl(urlRequest: URLRequest(url: WebUri.uri(widget.url),headers: widget.headers));
        // }
      },
      onLoadStart: widget.onLoadStart,
      onLoadStop: widget.onLoadStop,
      initialUrlRequest: URLRequest(url: WebUri.uri(widget.url),headers: widget.headers),
      onPermissionRequest: (controller, request) async {
        return PermissionResponse(resources: request.resources,action: PermissionResponseAction.GRANT);
      },
      shouldOverrideUrlLoading:(controller, navigationAction) async {
        var uri = navigationAction.request.url!;
        if (!["http","https","file","chrome","data","javascript","about"].contains(uri.scheme)) {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri,);
            return NavigationActionPolicy.CANCEL;
          }
        }
        return NavigationActionPolicy.ALLOW;
      },
      onReceivedError: (controller, request, error) {
        pullToRefreshController.endRefreshing();
      },
    );
  }
}