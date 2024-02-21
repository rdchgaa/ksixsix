import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';

///判断页面是否必须登录
///使用的页面，只需继承这个类
class MustLogin {}

extension PageNavigator on StatefulWidget {
  Future<T> pushAndRemoveUntil<T extends Object>(BuildContext context, RoutePredicate predicate, {bool rootNavigator = true}) async {
    if (!await checkLogin(context)) {
      return null;
    }
    return await Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => this,
        settings: RouteSettings(
          name: runtimeType.toString(),
          arguments: this,
        ),
      ),
      predicate,
    );
  }

  Future<T> pushReplacement<T extends Object>(BuildContext context, {bool rootNavigator = true}) async {
    if (!await checkLogin(context)) {
      return null;
    }
    return await Navigator.of(context, rootNavigator: rootNavigator).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => this,
        settings: RouteSettings(
          name: runtimeType.toString(),
          arguments: this,
        ),
      ),
    );
  }

  Future<T> push<T extends Object>(BuildContext context, {bool rootNavigator = true}) async {
    if (!await checkLogin(context)) {
      return null;
    }
    return await Navigator.of(context, rootNavigator: rootNavigator).push(
      CupertinoPageRoute(
        builder: (context) => this,
        settings: RouteSettings(
          name: runtimeType.toString(),
          arguments: this,
        ),
      ),
    );
  }

  Future checkLogin(BuildContext context) async {
    if (this is! MustLogin) {
      return true;
    }

    // if (!context.read<SerAccount>().isGuest) {
    //   return true;
    // }
    //
    // await const PageLogin().push(context);

    ///游客触发登录操作后，成功登录不触发到下一步操作，停留在触发页面（所有的触发登录）
    // if (!context.read<SerAccount>().isGuest) {
    //   return true;
    // }

    return false;
  }
}
