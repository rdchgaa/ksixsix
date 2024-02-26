import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';

Future<bool> showAlertDialogRule(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return DialogAlertRuleBox(
        // contentAlign: contentAlign,
      );
    },
  );
}

class DialogAlertRuleBox extends StatefulWidget {

  const DialogAlertRuleBox({
    Key key,
  }) : super(key: key);

  @override
  _DialogAlertRuleBoxState createState() => _DialogAlertRuleBoxState();
}

class _DialogAlertRuleBoxState extends State<DialogAlertRuleBox> {

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
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text('牌的大小',style: TextStyle(fontSize: 14,color: Color(0xffffffff)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text('除了大小王（A和K）以外，其他牌都按照其点数大小排列，A为最低点数，而K为最高点数。 JQK都为10。',style: TextStyle(fontSize: 12,color: Color(0xffcccccc)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text('牌型比较',style: TextStyle(fontSize: 14,color: Color(0xffffffff)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text('玩家需要将自己的手牌分成两组，一组是三张牌，另一组是两张牌。三张牌中的任意一张与其他两张牌组合成的牌型需要进行比较，决定胜负。',style: TextStyle(fontSize: 12,color: Color(0xffcccccc)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text('牌型分类',style: TextStyle(fontSize: 14,color: Color(0xffffffff)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text('无牛：三张牌中没有组合成10的倍数。'
                                            '\n有牛：三张牌中有组合成10的倍数的牌型。剩下两张牌和余10后的点数就是几牛。'
                                            '\n牛牛：三张牌中有组合成10的倍数的牌型，并且剩余的两张牌中也恰好是10的倍数。'
                                            '\n五小：5张牌牌点总数小于或者等于10。'
                                            '\n炸弹：四张牌点一样的牌。'
                                            '\n金牛：五张十以上的花牌组成的“斗牛”。'
                                            '\n银牛：十和十以上的花牌组成的“斗牛”。',style: TextStyle(fontSize: 12,color: Color(0xffcccccc)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text('比牌',style: TextStyle(fontSize: 14,color: Color(0xffffffff)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text('先比牌型，牌型一样比单牌大小， 牌一样比花色， 完全一样庄家胜。'
                                            '\n各牌型间的大小：炸弹>五小>金牛>银牛>牛牛>有牛>没牛。'
                                            '\n单牌的大小为：K>Q>J>10>9>8>7>6>5>4>3>2>A。'
                                            '\n花色大小：黑桃>红桃>梅花>方块。'
                                            '\n（没牛的情况：庄家和闲家最大点数小于等于10，那么庄家胜）',style: TextStyle(fontSize: 12,color: Color(0xffcccccc)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text('赔率',style: TextStyle(fontSize: 14,color: Color(0xffffffff)),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0,bottom: 10),
                                        child: Text('炸弹：3倍'
                                            '\n五小：3倍'
                                            '\n金牛：3倍'
                                            '\n银牛：3倍'
                                            '\n牛牛：3倍'
                                            '\n有牛：7,8,9点2倍，其他点数1倍'
                                            '\n没牛：1倍',style: TextStyle(fontSize: 12,color: Color(0xffcccccc)),),
                                      ),
                                    ],
                                  ),
                                ),
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
