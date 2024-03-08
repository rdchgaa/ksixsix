import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xxc_flutter_utils/xxc_flutter_utils.dart';
import 'package:ima2_habeesjobs/app.dart';
import 'package:ima2_habeesjobs/page/home/home_first.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';

class EventHomeIndex {
  int index;

  EventHomeIndex({
    this.index,
  });
}

class PageHome extends StatefulWidget {
  final String message;

  const PageHome({Key key, this.message}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> with AutomaticKeepAliveClientMixin{

  StreamSubscription _subscription;
  int currentIndex = 0;
  PageController _pageController;
  var _pageKey = GlobalKey();

  init(BuildContext context) async {
    await LoadingCall.of(context).call((state, controller) async {
      _subscription = App.of(context).on<EventHomeIndex>().listen((event) {
        currentIndex = event.index;
        // _pageController.jumpToPage(
        //   event.index,
        // );
      });
      _pageController = PageController(initialPage: currentIndex);
    });
  }

  void onIndexChange(BuildContext context, int index) {
    AutoRouter.of(context).popUntil((routerData) => routerData.path.startsWith("/home/"));
    currentIndex = index;
    _pageController.jumpToPage(
      index,
    );
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  void _onState() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Loading(
      child: LoadingCall(
          onInitLoading: _onInitLoading,
          emptyBuilder: (context) {
            return UiEmptyView(type: EmptyType.data);
          },
          errorBuilder: (context, error) {
            return UiEmptyView(type: EmptyType.network, onPressed: () => _onInitLoading(context));
          },
          builder: (context) {
          return ColoredBox(
            color: Colors.white,
            child: LayoutBuilder(
              builder: (context, value) {
                return Scaffold(
                  body: HomeFirst(),
                );
              },
            ),
          );
        }
      ),
    );
  }

  Future<bool> _onInitLoading(BuildContext context) async {
    init(context);
    return true;
  }

  @override
  bool get wantKeepAlive => true;

}
