import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/src/photo_view_wrappers.dart';

class ImageViewGallery extends StatefulWidget {
  final List<GalleryImageItem> images;

  final PageController pageController;

  final void Function() onInit;

  const ImageViewGallery({Key key, this.images, this.pageController, this.onInit}) : super(key: key);

  @override
  _ImageViewGalleryState createState() => _ImageViewGalleryState();
}

class _ImageViewGalleryState extends State<ImageViewGallery> {
  PageController _pageController;

  bool _isInit = false;

  @override
  void initState() {
    _pageController = widget.pageController ?? PageController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ImageViewGallery oldWidget) {
    if (null != widget.pageController) {
      _pageController = widget.pageController;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: PhotoViewGestureDetectorScope(
            axis: Axis.horizontal,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                var item = widget.images[index];
                return _ItemImage(
                    key: item.key,
                    item: item,
                    controller: _pageController,
                    onInit: () {
                      if (!_isInit) {
                        _isInit = true;
                        if (null == widget.onInit) {
                          setState(() {});
                        } else {
                          widget.onInit();
                        }
                      }
                    });
              },
            ),
          ),
        ),
        if (_pageController.hasClients)
          Align(
            alignment: Alignment.centerLeft,
            child: ClipOval(
              child: Material(
                color: Color(0x30000000),
                child: IconButton(
                  onPressed: (_pageController.page?.toInt() ?? 0) > 0
                      ? () {
                          _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                        }
                      : null,
                  icon: Icon(Icons.chevron_left),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (_pageController.hasClients)
          Align(
            alignment: Alignment.centerRight,
            child: ClipOval(
              child: Material(
                color: Color(0x30000000),
                child: IconButton(
                  onPressed: (_pageController?.page?.toInt() ?? 0) < (widget.images.length - 1)
                      ? () {
                          _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                        }
                      : null,
                  icon: Icon(Icons.chevron_right),
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class GalleryImageItem {
  ImageProvider image;
  ImageProvider thumbnail;
  double width;
  double height;
  Object key;

  GalleryImageItem({
    this.image,
    this.key,
    this.thumbnail,
    this.width,
    this.height,
  });
}

class _ItemImage extends StatefulWidget {
  final PageController controller;

  final Function() onInit;

  final ValueChanged<PhotoViewScaleState> scaleStateChangedCallback;

  final GalleryImageItem item;

  const _ItemImage({
    Key key,
    @required this.item,
    this.controller,
    this.onInit,
    this.scaleStateChangedCallback,
  }) : super(key: key);

  @override
  State<_ItemImage> createState() => _ItemImageState();
}

class _ItemImageState extends State<_ItemImage> {
  bool _controlledController;
  PhotoViewControllerBase _controller;
  bool _controlledScaleStateController;
  PhotoViewScaleStateController _scaleStateController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onInit();
    });

    _controlledController = true;
    _controller = PhotoViewController();
    _controlledScaleStateController = true;
    _scaleStateController = PhotoViewScaleStateController();
    _scaleStateController.outputScaleStateStream.listen(scaleStateListener);
  }

  @override
  void dispose() {
    if (_controlledController) {
      _controller.dispose();
    }
    if (_controlledScaleStateController) {
      _scaleStateController.dispose();
    }
    super.dispose();
  }

  void scaleStateListener(PhotoViewScaleState scaleState) {
    if (widget.scaleStateChangedCallback != null) {
      widget.scaleStateChangedCallback(_scaleStateController.scaleState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        var temp = event as PointerScrollEvent;
        print(temp.scrollDelta);
        if (0 < temp.scrollDelta.dy) {
          _controller.scale = min(6, _controller.scale + 0.1);
        } else if (0 > temp.scrollDelta.dy) {
          _controller.scale = max(0.5, _controller.scale - 0.1);
        }
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return ImageWrapper(
          imageProvider: widget.item.image,
          loadingBuilder: null == widget.item.thumbnail
              ? null
              : (context, event) {
                  return Image(
                    image: widget.item.thumbnail,
                    width: widget.item.width.toDouble(),
                    height: widget.item.height.toDouble(),
                  );
                },
          maxScale: PhotoViewComputedScale.contained * 6,
          minScale: PhotoViewComputedScale.contained * 0.5,
          gaplessPlayback: false,
          enableRotation: false,
          outerSize: constraints.biggest,
          controller: _controller,
          scaleStateController: _scaleStateController,
        );
      }),
    );
  }
}
