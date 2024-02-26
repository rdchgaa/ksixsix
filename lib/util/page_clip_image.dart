import 'dart:math';

import 'package:flutter/material.dart';
import 'package:head_image_cropper/head_image_cropper.dart';

class PageClipImage extends StatefulWidget {
  final double outWidth;

  final double outHeight;

  final ImageProvider image;

  const PageClipImage({Key key, this.image, this.outWidth = 1080, this.outHeight = 1080}) : super(key: key);

  @override
  _PageClipImageState createState() => _PageClipImageState();
}

class _PageClipImageState extends State<PageClipImage> {
  final _controller = CropperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CropperImage(
              widget.image,
              outHeight: widget.outHeight,
              outWidth: widget.outWidth,
              controller: _controller,
              round: 0,
              backBoxColor0: Colors.black,
              backBoxColor1: Colors.black,
            ),
          ),
          Positioned(
            child: const BackButton(
              color: Colors.white,
            ),
            top: MediaQuery.of(context).padding.top,
            left: 0,
          ),
          Positioned(
            child: TextButton(
              onPressed: () async {
                await _onSave(context);
              },
              child: Text(
                '确定',
                style: TextStyle(fontSize: 16),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(const Color(0xffF96A6A)),
                minimumSize: MaterialStateProperty.all(const Size(78, 30)),
                shape: MaterialStateProperty.all(const StadiumBorder()),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            bottom: max(MediaQuery.of(context).padding.bottom, 10),
            right: 12,
          ),
        ],
      ),
    );
  }

  _onSave(BuildContext context) {
    _controller.outImage().then((image) async {
      Navigator.pop(context, image);
    });
  }
}
