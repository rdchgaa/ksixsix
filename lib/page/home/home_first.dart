import 'package:ima2_habeesjobs/net/api.dart';
import 'package:ima2_habeesjobs/page/home/home_first/xd_home_first.dart';
import 'package:ima2_habeesjobs/util/datetime.dart';
import 'package:ima2_habeesjobs/widget/app_bar.dart';
import 'package:ima2_habeesjobs/widget/app_content.dart';
import 'package:ima2_habeesjobs/widget/refres_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

class HomeFirst extends StatefulWidget {
  HomeFirst({Key key}) : super(key: key);

  @override
  _HomeFirstState createState() => _HomeFirstState();
}

class _HomeFirstState extends State<HomeFirst> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: XdHomeFirst(),
    );
  }
}
