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

class PageEditImage extends StatefulWidget {
  final String url;

  const PageEditImage({
    Key key, this.url,
  }) : super(key: key);

  @override
  _PageEditImageState createState() => _PageEditImageState();
}

class _PageEditImageState extends State<PageEditImage> {

  var _controller = CropperController();

  final _picker = ImagePicker();

  String _imageFile;


  Future<void> _getImageByGallery(BuildContext context) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'gif', 'webp', 'bmp', 'jfif']);
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (null == file) return;
      _imageFile = file.path;
      setState(() {
      });
      return;
    }

    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    if (await Permission.storage.isDenied) {
      showAlertDialog(context, title: "", content: "", buttonOk: Languages.of(context).okButtonLabel);
      return;
    }

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = pickedFile.path;
      setState(() {
      });
    }
  }

  Future<void> _getImageByCamera(BuildContext context) async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    if (await Permission.camera.isDenied) {
      showAlertDialog(context, title: "", content: "", buttonOk: Languages.of(context).okButtonLabel);
      return;
    }

    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _imageFile = pickedFile.path;
      setState(() {
      });
    }
  }

  _onSave(BuildContext context) {
    Navigator.pop(context, _imageFile);
    // _controller.outImage().then((image) async {
    //   var bytes = (await (image.toByteData(format: ImageByteFormat.png))).buffer.asUint8List();
    //   Navigator.pop(context, bytes);
    // });
  }


  @override
  void initState() {
    super.initState();
    onSelectImage(context);
  }

  Future<void> onSelectImage(BuildContext context) async {
    var value = await showSelectImageSourceDialog(context);
    if (ImageSource.gallery == value) {
      _getImageByGallery(context);
    } else if (ImageSource.camera == value) {
      _getImageByCamera(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: true,
        title: Text(
          '图片',
          style: TextStyle(fontSize: 18, color: Color(0xFF292929), fontWeight: FontWeight.w800),
        ),
        actions: <Widget>[_buildActions(context)],
      ),
      body: CropperImage(
        // null == widget._imageFile
        CachedNetworkImageProvider(widget.url ?? "", cacheManager: AppCacheManager()),
        // ? FileImage(File(widget.data.url ?? ""))
        // : FileImage(File(widget.data._imageFile)),
        outHeight: 512,
        outWidth: 512,
        controller: _controller,
        isArc: true,
        onLoadError: _onLoadError,
      ),
    );
  }

  _buildActions(BuildContext context) {
    if (null != _imageFile) {
      return TextButton(
        child: Text(Languages.of(context).saveText),
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(isPc(context) ? null : Color(0xff333333))),
        onPressed: () => _onSave(context),
      );
    }
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      return TextButton(
        child: Text(Languages.of(context).openText),
        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(isPc(context) ? null : Color(0xff333333))),
        onPressed: () => _getImageByGallery(context),
      );
    }

    return IconButton(
      onPressed: () {
        onSelectImage(context);
      },
      icon: Icon(Icons.adaptive.more,color: Color(0xff333333),),
    );
  }

  void _onLoadError(BuildContext context, Object exception, StackTrace stackTrace) {
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      _getImageByGallery(context);
    } else {
      // widget.data.onSelectImage(context);
    }
  }
}
