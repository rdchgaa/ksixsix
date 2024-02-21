import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';


const double _kItemExtent = 32.0;
final double KScreenWidth = window.physicalSize.width;
final double KScreenHeight = window.physicalSize.height;

typedef _CallBack = void Function(String yearStr, String monthStr);
typedef _CallBackTime = void Function(String yearStr, String monthStr);
final GlobalKey globalKey = GlobalKey();


class PopPickerPage extends StatefulWidget {
  final _CallBack callback;

  const PopPickerPage({Key key, this.callback}) : super(key: key);

  // final void Function(String ) onChange;
  @override
  State<PopPickerPage> createState() => _PopPickerPageState();
}

class _PopPickerPageState extends State<PopPickerPage> {
  final List<String> _fruitNames = <String>[];

  static const List<String> _monthName = <String>[
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];

  static const List<String> _onlyOne = <String>[
    '至今',
  ];

  List<String> _monthArr = _onlyOne;

  int _selectedMonth = 0;
  int _selectedYear = 0;

  var _currentYear = '';
  var _currentMonth = '';

  var _width = 0.0;
  var _height = 0.0;

  @override
  void initState() {
    super.initState();
    _fruitNames.add("至今");

    DateTime now = DateTime.now();
    print('当前时间：${now.year}');
    var yearstr = '${now.year}';
    var year = int.parse(yearstr);
    for (var i = year; i >= 1990; i--) {
      _fruitNames.add("$i");
    }
    _fruitNames.add("1990之前");

    // 1.系统提供的方法
    // 这个方法可以得到当前控件的宽，高
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        key: globalKey,

        height: 300,
        // width: 90,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: Column(
          children: [
            SizedBox(
              width: KScreenHeight,
              height: 50,

              child: Stack(
                children: [
                  Positioned(
                    left: 15,
                    bottom: 5,
                    child: TextButton(
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.black26, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 5,
                    child:  TextButton(
                        child: const Text(
                          '确定',
                          style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                        ),
                        onPressed: () {
                          widget.callback(_currentYear,_currentMonth);
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                height: 210,
                child: Row(
                  children: [
                    Expanded(
                        child: CupertinoPicker(
                          magnification: 1.0,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: _kItemExtent,
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              if (selectedItem == 0) {
                                _monthArr = _onlyOne;
                                _selectedMonth = 0;
                              } else {
                                _monthArr = _monthName;
                              }
                              _currentYear = _fruitNames[selectedItem];

                              _selectedYear = selectedItem;
                            });
                          },
                          children: List<Widget>.generate(_fruitNames.length, (int index) {
                            return Center(
                              child: Text(
                                _fruitNames[index],
                              ),
                            );
                          }),
                        )),
                    Expanded(
                        child: CupertinoPicker(
                          magnification: 1.0,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: _kItemExtent,
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              _selectedMonth = selectedItem;
                              _currentMonth = _monthName[selectedItem];
                            });
                          },
                          children: List<Widget>.generate(_monthArr.length, (int index) {
                            return Center(
                              child: Text(
                                _monthArr[index],
                              ),
                            );
                          }),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
