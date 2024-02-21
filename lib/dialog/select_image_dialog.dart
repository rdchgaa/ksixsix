import 'package:ima2_habeesjobs/util/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/util/navigator.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource> showSelectImageSourceDialog(BuildContext context) {
  // return AutoRouter.of(context).pushNamed("/dialog_select_image");
  return DialogSelectImageSourceBox().push(context);
}

class _ControlSelectImageSourceBox extends RouterDataNotifier {
  _ControlSelectImageSourceBox();

  init(BuildContext context) {
    value = true;
  }
}

class DialogSelectImageSourceBox extends RouterDataWidget<_ControlSelectImageSourceBox> implements PageSize {
  DialogSelectImageSourceBox();

  @override
  State<DialogSelectImageSourceBox> createState() => _DialogSelectImageSourceBoxState();

  @override
  _ControlSelectImageSourceBox initData(BuildContext context) {
    return _ControlSelectImageSourceBox();
  }

  @override
  SizePage get size => SizePage(279, 182);
}

class _DialogSelectImageSourceBoxState extends State<DialogSelectImageSourceBox> {
  var buttonStyle = ButtonStyle(
    visualDensity: VisualDensity(),
    minimumSize: MaterialStateProperty.all(Size(297, 57)),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, con) {
        return Material(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  // AutoRouter.of(context).pop(ImageSource.camera);
                  Navigator.pop(context,ImageSource.camera);
                },
                child: Text(Languages.of(context).photographersText,style: TextStyle(color: Color(0xFF21A27C)),),
                style: buttonStyle,
              ),
              Divider(height: 1),
              TextButton(
                onPressed: () {
                  // AutoRouter.of(context).pop(ImageSource.gallery);
                  Navigator.pop(context,ImageSource.gallery);
                },
                child: Text(Languages.of(context).phoneSelPicture,style: TextStyle(color: Color(0xFF21A27C)),),
                style: buttonStyle,
              ),
              ColoredBox(
                color: Theme.of(context).dividerColor,
                child: SizedBox(height: 8,width: double.infinity,),
              ),
              TextButton(
                onPressed: () {
                  AutoRouter.of(context).pop();
                },
                child: Text(Languages.of(context).cancelButtonLabel,style: TextStyle(color: Color(0xFF21A27C)),),
                style: buttonStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}
