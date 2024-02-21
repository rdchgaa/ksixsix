import 'package:flutter/material.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


//选择图片弹窗
Future<String> showSelectImageDialog(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    // barrierColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return const DialogSelectImageBox();
    },
  );
}

class DialogSelectImageBox extends StatefulWidget {
  final String title;
  final String content;
  final String buttonOk;
  final String buttonCancel;

  const DialogSelectImageBox({
    Key key,
    this.title,
    this.content,
    this.buttonOk,
    this.buttonCancel,
  }) : super(key: key);

  @override
  _DialogSelectImageBoxState createState() => _DialogSelectImageBoxState();
}

class _DialogSelectImageBoxState extends State<DialogSelectImageBox> {
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return UiModalBottomMenuLayout(children: [
      TextButton(
        onPressed: () async {
          await _onGallery(context);
        },
        style: menuItemStyle64,
        child: Text('相册'),
      ),
      Divider(height: 1),
      TextButton(
        onPressed: () async {
          await _onCamera(context);
        },
        style: menuItemStyle64,
        child: Text('拍照'),
      ),
    ]);
  }

  Future<void> _onGallery(BuildContext context) async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    if (await Permission.storage.isDenied) {
      showAlertDialog(context,
          title: "", content: '请允许访问相册', buttonOk: '确定', buttonCancel: '取消');
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop(pickedFile.path);
  }

  Future<void> _onCamera(BuildContext context) async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    if (await Permission.camera.isDenied) {
      showAlertDialog(context,
          title: "", content: '请允许访问相机',  buttonOk: '确定', buttonCancel: '取消');
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop(pickedFile.path);
  }
}

//修改图片弹窗
Future<String> showChangeImageDialog(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return const DialogChangeImage();
    },
  );
}

class DialogChangeImage extends StatefulWidget {
  const DialogChangeImage({Key key}) : super(key: key);

  @override
  State<DialogChangeImage> createState() => _DialogChangeImageState();
}

class _DialogChangeImageState extends State<DialogChangeImage> {
  @override
  Widget build(BuildContext context) {
    return UiModalBottomMenuLayout(children: [
      TextButton(
        onPressed: () async {
          Navigator.of(context).pop("edit");
        },
        style: menuItemStyle64,
        child: Text('修改图片'),
      ),
      Divider(height: 1),
      TextButton(
        onPressed: () async {
          Navigator.of(context).pop("del");
        },
        style: menuItemStyle64,
        child: Text('删除'),
      ),
      Divider(height: 1),
    ]);
  }
}


//  //底部弹窗带取消按钮
class UiModalBottomMenuLayout extends StatelessWidget {
  final List<Widget> children;
  final UiModalBottomMenuLayoutStyle style;

  const UiModalBottomMenuLayout({Key key, this.children, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = this.style ?? UiModalBottomMenuLayoutStyle(
      borderRadius: BorderRadius.circular(12),
      shadowColor: Color(0xff000000),
      color: Color(0xff131530),
      elevation: 4,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            borderRadius: style.borderRadius,
            color: style.color,
            shadowColor: style.shadowColor,
            elevation: style.elevation,
            child: ClipRRect(
              borderRadius: style.borderRadius,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 16),
            child: Material(
              borderRadius: style.borderRadius,
              color: style.color,
              shadowColor: style.shadowColor,
              child: ClipRRect(
                borderRadius: style.borderRadius,
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  // style: UiTheme.of(context).menuItemStyle64,
                  child: Text('取消'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UiModalBottomMenuLayoutStyle {
  final BorderRadius borderRadius;
  final Color color;
  final Color shadowColor;
  final double elevation;

  UiModalBottomMenuLayoutStyle({
    this.borderRadius,
    this.color,
    this.shadowColor,
    this.elevation,
  });

  UiModalBottomMenuLayoutStyle copyWith({
    BorderRadius borderRadius,
    Color color,
    Color shadowColor,
    double elevation,
  }) {
    return UiModalBottomMenuLayoutStyle(
      borderRadius: borderRadius ?? this.borderRadius,
      color: color ?? this.color,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
    );
  }
}

Color buttonForegroundColor = Colors.white;
Color buttonBackgroundColorColor = Color(0xff191c38);
//按钮（大）
ButtonStyle get buttonBig => ButtonStyle(
  minimumSize: MaterialStateProperty.all(Size(60, 50)),
  maximumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
  // shape: MaterialStateProperty.all(buttonBorder),
  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
  foregroundColor: MaterialStateProperty.all(buttonForegroundColor),
  backgroundColor: MaterialStateProperty.all(buttonBackgroundColorColor),
  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14, horizontal: 16)),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);
//菜单按钮样式
ButtonStyle get menuItemStyle64 => buttonBig.copyWith(
  shape: MaterialStateProperty.all(RoundedRectangleBorder()),
  minimumSize: MaterialStateProperty.all(Size(double.infinity, 65)),
  maximumSize: MaterialStateProperty.all(Size(double.infinity, 65)),
  backgroundColor: MaterialStateProperty.all(Colors.transparent),
);