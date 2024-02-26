import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

Future<bool> showAlertDialogResultAll(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return DialogAlertResultAllBox(
        // contentAlign: contentAlign,
      );
    },
  );
}

class DialogAlertResultAllBox extends StatefulWidget {

  const DialogAlertResultAllBox({
    Key key,
  }) : super(key: key);

  @override
  _DialogAlertResultAllBoxState createState() => _DialogAlertResultAllBoxState();
}

class _DialogAlertResultAllBoxState extends State<DialogAlertResultAllBox> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: const Alignment(0, 0),
        child: SizedBox(
          width:width*0.8,
          height: width*1.4,
          child: Material(
            color: Color(0x00000000),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LayoutBuilder(builder: (context, con) {
              return InkWell(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0x33000000),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {},
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color(0xaa555555),
                              boxShadow: [BoxShadow(color: Color(0x66555555), blurRadius: 33, offset: Offset(0, 0))],
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Color(0xffffffff), width: 2)),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              SizedBox(
                                width: con.maxWidth * 1,
                                height: con.maxHeight * 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, right: 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
