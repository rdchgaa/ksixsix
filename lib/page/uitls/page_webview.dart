import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_selector/file_selector.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog.dart';
import 'package:ima2_habeesjobs/dialog/select_image_dialog.dart';
import 'package:ima2_habeesjobs/util/app_cache_manager.dart';
import 'package:ima2_habeesjobs/util/language.dart';
import 'package:ima2_habeesjobs/util/other.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:head_image_cropper/head_image_cropper.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class _ControlWebView extends RouterDataNotifier {
  String title;
  String url;

  WebViewController _controller;

  int _progress = 0;

  _ControlWebView({this.title, this.url});

  init(BuildContext context) {
    value = true;
  }
}

class PageWebView extends RouterDataWidget<_ControlWebView> {
  final Map<String, dynamic> param;

  PageWebView({Key key, this.param}) : super(key: key);

  @override
  _PageWebViewState createState() => _PageWebViewState();

  @override
  initData(BuildContext context) {
    return _ControlWebView(
      title: param["title"],
      url: param["url"],
    );
  }
}

class _PageWebViewState extends RouterDataWidgetState<PageWebView> {
  @override
  Widget buildContent(BuildContext context) {
    return AutoRoutePopScope(
      onWillPop: () async {
        if (await widget.data._controller.canGoBack()) {
          await widget.data._controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: MyAppBar(
          leading: BackButton(
            onPressed: () async {
              if (await widget.data._controller.canGoBack()) {
                await widget.data._controller.goBack();
              } else {
                AutoRouter.of(context).pop();
              }
            },
          ),
          title: Text(widget.data.title ?? ""),
          actions: [
            CloseButton(
              onPressed: () {
                AutoRouter.of(context).pop();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: widget.data._progress.toDouble(),
            ),
            Expanded(
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                initialUrl: widget.data.url,
                onWebViewCreated: (controller) {
                  widget.data._controller = controller;
                },
                navigationDelegate: (navigation) async {
                  return NavigationDecision.prevent;
                },
                onProgress: (progress) {
                  widget.data._progress = progress;
                  widget.data.notifyListeners();
                },
                onPageStarted: (title) async {
                  widget.data.title = await widget.data._controller.getTitle();
                  widget.data.notifyListeners();
                },
                onPageFinished: (title) async {
                  widget.data.title = await widget.data._controller.getTitle();
                  widget.data.notifyListeners();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
