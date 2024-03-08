import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/page/home/home_first/xd_home_first.dart';

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
