import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryItem {
  final Object id;
  final ImageProvider image;

  GalleryItem({this.id, this.image});
}

Future showPhotoViewDialog(BuildContext context, {Decoration backgroundDecoration, List<GalleryItem> gallery = const [], int initialPage = 0}) {
  return showDialog(
    context: context,
    builder: (context) {
      return PhotoViewDialog(
        gallery: gallery,
        backgroundDecoration: backgroundDecoration,
        initialPage: initialPage,
      );
    },
  );
}

class PhotoViewDialog extends StatefulWidget {
  final Decoration backgroundDecoration;

  final List<GalleryItem> gallery;

  final PageController pageController;

  final int initialPage;

  const PhotoViewDialog({
    Key key,
    this.backgroundDecoration,
    this.gallery,
    this.pageController,
    this.initialPage = 0,
  }) : super(key: key);

  @override
  _PhotoViewDialogState createState() => _PhotoViewDialogState();
}

class _PhotoViewDialogState extends State<PhotoViewDialog> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = widget.pageController ?? PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: PhotoViewGallery.builder(
              pageController: _pageController,
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: widget.gallery[index].image,
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.gallery[index].id),
                );
              },
              itemCount: widget.gallery.length,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : (event?.cumulativeBytesLoaded??0) / (event?.expectedTotalBytes??1),
                  ),
                ),
              ),
              backgroundDecoration: widget.backgroundDecoration,
            ),
          ),
          Positioned(
            right: 0,
            child: CloseButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
