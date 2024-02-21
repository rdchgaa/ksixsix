// @dart = 2.18

import 'dart:io' as io;

import 'package:ima2_habeesjobs/util/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kItemExtent = 32.0;

typedef ToTextCall<T> = String Function(T value);

Future<T?> showImPopPicker<T>(
    BuildContext context, {
      required List<T> list,
      required ToTextCall<T> toText,
    }) {
  return showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return PopImPickerPage<T>(toText: toText, list: list);
      });
}

class PopImPickerPage<T> extends StatefulWidget {
  final ToTextCall<T> toText;

  final List<T> list;

  const PopImPickerPage({super.key, required this.toText, required this.list});

  @override
  State<PopImPickerPage<T>> createState() => _PopImPickerPageState<T>();
}

class _PopImPickerPageState<T> extends State<PopImPickerPage<T>> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Stack(
                children: [
                  Positioned(
                    left: 15,
                    bottom: 5,
                    child: TextButton(
                      child: Text(
                        Languages.of(context).cancelButtonLabel,
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
                    child: TextButton(
                      child: Text(
                        Languages.of(context).okButtonLabel, 
                        style: TextStyle(color: Color(0xFF21A27C), fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context, widget.list[_index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: ImDesktopCupertinoPicker(
                  magnification: 1.0,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: _kItemExtent,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  children: [
                    for (var item in widget.list) Text(widget.toText(item)),
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

class ImDesktopCupertinoPicker extends StatefulWidget {
  final double itemExtent;
  final List<Widget> children;
  final ValueChanged<int> onSelectedItemChanged;
  final double magnification;
  final bool useMagnifier;
  final double squeeze;
  final int value;

  const ImDesktopCupertinoPicker({
    super.key,
    required this.itemExtent,
    required this.children,
    required this.onSelectedItemChanged,
    this.magnification = 1.0,
    this.useMagnifier = false,
    this.squeeze = 1.45,
    this.value = 0,
  });

  @override
  State<ImDesktopCupertinoPicker> createState() => _ImDesktopCupertinoPickerState();
}

class _ImDesktopCupertinoPickerState extends State<ImDesktopCupertinoPicker> {
  int previousIndex = 0;
  bool isScrollUp = false;
  bool isScrollDown = true;
  FixedExtentScrollController? controller;

  @override
  void initState() {
    controller = FixedExtentScrollController(initialItem: widget.value);
    if (io.Platform.isWindows) {
      controller?.addListener(_manageScroll);
    }
    super.initState();
  }

  void _manageScroll() {
    if (previousIndex != controller!.selectedItem) {
      isScrollDown = previousIndex < controller!.selectedItem;
      isScrollUp = previousIndex > controller!.selectedItem;
      if (isScrollUp) {
        previousIndex--;
      } else if (isScrollDown) {
        previousIndex++;
      }
      controller?.jumpToItem(previousIndex);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: widget.itemExtent,
      children: widget.children,
      onSelectedItemChanged: widget.onSelectedItemChanged,
      magnification: widget.magnification,
      useMagnifier: widget.useMagnifier,
      squeeze: widget.squeeze,
    );
  }
}

enum ImDatePickerFormat {
  year,
  month,
  day,
  hour,
  minute,
  second,
}

Future<DateTime?> showImDatePicker(BuildContext context, {DateTime? initValue, DateTime? maxDateTime, Set<ImDatePickerFormat>? format}) {
  return showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return PopImDatePicker(
          initValue: initValue ?? DateTime.now(),
          maxDateTime: maxDateTime ?? DateTime(3000),
          format: format ??
              {
                ImDatePickerFormat.year,
                ImDatePickerFormat.month,
                ImDatePickerFormat.day,
              },
        );
      });
}

class PopImDatePicker extends StatefulWidget {
  final DateTime initValue;

  final DateTime maxDateTime;

  final Set<ImDatePickerFormat> format;


  const PopImDatePicker({super.key, required this.initValue,required this.maxDateTime ,required this.format});

  @override
  State<PopImDatePicker> createState() => _PopImDatePickerState();
}

class _PopImDatePickerState extends State<PopImDatePicker> {
  int _year = 0;
  int _month = 0;
  int _day = 0;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;

  @override
  void initState() {
    _year = widget.initValue.year;
    _month = widget.initValue.month;
    _day = widget.initValue.day;
    _hour = widget.initValue.hour;
    _minute = widget.initValue.minute;
    _second = widget.initValue.second;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var item in widget.format) {
      if (item == ImDatePickerFormat.year) {
        children.add(
          Expanded(
            child: ImDesktopCupertinoPicker(
              magnification: 1.0,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: _kItemExtent,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _year = widget.maxDateTime.year - index;
                });
              },
              value: widget.maxDateTime.year - _year,
              children: [
                for (var i = widget.maxDateTime.year; i > 1970; i--) Text(i.toString()),
              ],
            ),
          ),
        );
      } else if (item == ImDatePickerFormat.month) {
        children.add(
          Expanded(
            child: ImDesktopCupertinoPicker(
              magnification: 1.0,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: _kItemExtent,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _month = 12- index;
                });
              },
              value: 12 - _month,
              children: [
                for (var i = 11; i >= 0; i--) Text((i + 1).toString()),
              ],
            ),
          ),
        );
      } else if (item == ImDatePickerFormat.day) {
        var maxDay = [1, 3, 5, 7, 8, 10, 12].contains(_month + 1) ? 31 : 30;
        children.add(
          Expanded(
            child: ImDesktopCupertinoPicker(
              magnification: 1.0,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: _kItemExtent,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _day = maxDay - index;
                });
              },
              value: maxDay - _day,
              children: [
                for (var i = maxDay; i > 0; i--) Text(i.toString()),
              ],
            ),
          ),
        );
      } else if (item == ImDatePickerFormat.hour) {
        children.add(
          Expanded(
            child: ImDesktopCupertinoPicker(
              magnification: 1.0,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: _kItemExtent,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _hour = index;
                });
              },
              value: 60 - _hour,
              children: [
                for (var i = 60; i > 0; i--) Text(i.toString()),
              ],
            ),
          ),
        );
      } else if (item == ImDatePickerFormat.minute) {
        children.add(
          Expanded(
            child: ImDesktopCupertinoPicker(
              magnification: 1.0,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: _kItemExtent,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _minute = index;
                });
              },
              value: 60 - _minute,
              children: [
                for (var i = 60; i > 0; i--) Text(i.toString()),
              ],
            ),
          ),
        );
      } else if (item == ImDatePickerFormat.second) {
        children.add(
          Expanded(
            child: ImDesktopCupertinoPicker(
              magnification: 1.0,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: _kItemExtent,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _second = index;
                });
              },
              value: 60 - _second,
              children: [
                for (var i = 60; i > 0; i--) Text(i.toString()),
              ],
            ),
          ),
        );
      }
    }
    return Material(
      child: Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Stack(
                children: [
                  Positioned(
                    left: 15,
                    bottom: 5,
                    child: TextButton(
                      child: Text(
                        Languages.of(context).cancelButtonLabel,
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
                    child: TextButton(
                      child: Text(
                        Languages.of(context).okButtonLabel,
                        style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context, DateTime(_year, _month, _day, _hour, _minute, _second));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Row(
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
