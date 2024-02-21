import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heqian_flutter_utils/heqian_flutter_utils.dart';
import 'package:ima2_habeesjobs/app.dart';
import 'package:ima2_habeesjobs/dao/manage_dao.dart';
import 'package:ima2_habeesjobs/dialog/alert_dialog.dart';
import 'package:ima2_habeesjobs/service/preferences.dart';
import 'package:ima2_habeesjobs/service/ser_base.dart';
import 'package:ima2_habeesjobs/service/ser_user.dart';
import 'package:ima2_habeesjobs/widget/my_image.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class HomeMy extends StatefulWidget {
  HomeMy({Key key}) : super(key: key);

  @override
  _HomeMyState createState() => _HomeMyState();
}

class _HomeMyState extends State<HomeMy> with SingleTickerProviderStateMixin {
  List<String> filesPath = [];

  @override
  void initState() {
    initFilesData();
    super.initState();
  }

  initFilesData() {
    filesPath = getFilesPath();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<SerUser>();
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20),
        children: <Widget>[
          SafeArea(child: SizedBox()),
          Padding(
            padding: EdgeInsets.only(top: 32, left: 0, right: 0),
            child: GestureDetector(
              onTap: () {
                if (getUserId() == null || getUserId() == 0) {
                  // AutoRouter.of(context).pushNamedAndRemoveUntil("/login_username", predicate: (routerData) => true);
                  AutoRouter.of(context).pushNamed("/login_username");
                } else {
                  AutoRouter.of(context).pushNamed(
                    "/my_edit_info",
                  );
                }
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 66,
                          height: 66,
                          child: HeadImage.network(
                            user.info.avatar ?? '',
                            width: 66,
                            height: 66,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Hello,',
                                  style: TextStyle(
                                    fontFamily: 'Source Han Sans CN',
                                    fontSize: 16,
                                    color: const Color(0xff0e0f0f),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    (getUserId() == null || getUserId() == 0) ? 'Please log in' : (user.info.name + ' ' + user.uesrname),
                                    style: TextStyle(
                                      fontFamily: 'Source Han Sans CN',
                                      fontSize: 16,
                                      color: const Color(0xff0e0f0f),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xfff5f9fb),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 14,
                        child: SvgPicture.string(
                          _svg_ed5kmq,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text(
              'Resume',
              style: TextStyle(
                fontFamily: 'Source Han Sans CN',
                fontSize: 20,
                color: const Color(0xff0e0f0f),
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 14.0,
                  height: 14.0,
                  child: SvgPicture.string(
                    _svg_o1mex8,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'You can upload your attached resume or your work.',
                    style: TextStyle(
                      fontFamily: 'Source Han Sans CN',
                      fontSize: 13,
                      color: const Color(0xff0e0f0f),
                      height: 1.3846153846153846,
                    ),
                    textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                  ),
                ),
              ],
            ),
          ),
          getPdfBuild(),
          getUpdateBuild(),
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 10),
            child: Text(
              'More',
              style: TextStyle(
                fontFamily: 'Source Han Sans CN',
                fontSize: 20,
                color: const Color(0xff0e0f0f),
                fontWeight: FontWeight.w700,
              ),
              softWrap: false,
            ),
          ),
          getMoreButtom('My Collection', () {
            if (getUserId() == null || getUserId() == 0) {
              // AutoRouter.of(context).pushNamedAndRemoveUntil("/login_username", predicate: (routerData) => true);
              AutoRouter.of(context).pushNamed("/login_username");
              return;
            }
            AutoRouter.of(context).pushNamed('/my_collection');
          }),
          getMoreButtom('Check version', () {
            showToast(context, "It's the latest version", alignment: Alignment(0, 0.8));
          }),
          getMoreButtom('Privacy Policy', () {
            AutoRouter.of(context).pushNamed("/user_privacy_policy");
          }),
          getMoreButtom('About Habees', () {
            AutoRouter.of(context).pushNamed('/home/aboutus');
          }),
          if (!(getUserId() == null || getUserId() == 0))
            InkWell(
              onTap: () async {
                var value = await showAlertDialog(
                  context,
                  content: 'Are you sure you want to log out?',
                  buttonCancel: 'No',
                  buttonOk: 'Yes',
                );
                if (true == value) {
                  _onExit(context);
                } else {}
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xff21a27c),
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x33b3b3b3),
                      offset: Offset(0, 0),
                      blurRadius: 24,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Exit',
                  style: TextStyle(
                    fontFamily: 'Source Han Sans CN',
                    fontSize: 16,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: false,
                ),
              ),
            ),
        ],
      ),
    );
  }

  getMoreButtom(String text, Function onTap) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0x33b3b3b3),
                offset: Offset(0, 0),
                blurRadius: 24,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Source Han Sans CN',
                    fontSize: 14,
                    color: const Color(0xFF0E0F0F),
                  ),
                  softWrap: false,
                ),
              ),
              SvgPicture.string(
                '<svg viewBox="219.1 164.2 4.8 9.3" ><path transform="translate(-1473.66, -1466.59)" d="M 1692.78369140625 1630.767333984375 L 1697.546630859375 1635.463012695312 L 1692.78369140625 1640.111083984375" fill="none" stroke="#9e9e9e" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" /></svg>',
                allowDrawingOutsideViewBox: true,
                fit: BoxFit.fill,
              )
            ],
          ),
        ),
      ),
    );
  }

  _onExit(BuildContext context) async {
    print('1');
    setChannel(null);
    setUserId(null);
    setToken(null);
    App.of(context).setTitle("Chat Me");
    await context.read<SerBase>().close();
    await ManageDao.close();

    AutoRouter.of(context).pushNamedAndRemoveUntil(
      "/",
      predicate: (router) => true,
      params: {
        "isCheckVersion": "false",
      },
    );
  }

  selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (filesPath.length >= 3) {
      showToast(context, 'You have uploaded 3 resumes');
      return;
    }
    if (result != null) {
      File file = File(result.files.single.path);
      setFilesPath(file.path);
      initFilesData();
    } else {
      // User canceled the picker
    }
  }

  openFile(String path) {
    OpenFile.open(path);
  }

  getUpdateBuild() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          if (getUserId() == null || getUserId() == 0) {
            // AutoRouter.of(context).pushNamedAndRemoveUntil("/login_username", predicate: (routerData) => true);
            AutoRouter.of(context).pushNamed("/login_username");
            return;
          }
          selectFile();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xffffebef),
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(width: 1.0, color: const Color(0xfff24444)),
          ),
          alignment: Alignment.center,
          child: SizedBox(
            // width: 165,
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 24,
                  height: 19,
                  child: SvgPicture.string(
                    '<svg viewBox="51.1 266.0 23.7 18.0" ><path transform="translate(51.13, 266.0)" d="M 18.19155120849609 9.415406227111816 C 18.01468467712402 9.592889785766602 17.77442932128906 9.692651748657227 17.52386283874512 9.692651748657227 C 17.2732982635498 9.692651748657227 17.03304290771484 9.592889785766602 16.85617637634277 9.415406227111816 L 15.06071281433105 7.60872220993042 L 15.06071281433105 14.0836067199707 C 15.06071281433105 14.60419940948486 14.63868808746338 15.02622509002686 14.1180944442749 15.02622509002686 C 13.59750270843506 15.02622509002686 13.17547702789307 14.60420036315918 13.17547702789307 14.0836067199707 L 13.17547702789307 7.608722686767578 L 11.36879444122314 9.415406227111816 C 11.00004005432129 9.784159660339355 10.40217208862305 9.784160614013672 10.03341865539551 9.415407180786133 C 9.664664268493652 9.046653747558594 9.664664268493652 8.448784828186035 10.03341770172119 8.080031394958496 L 13.39990901947021 4.713540554046631 C 13.57677745819092 4.536056995391846 13.81703186035156 4.436295986175537 14.06759643554688 4.436295986175537 C 14.3181619644165 4.436295986175537 14.55841636657715 4.536056995391846 14.73528480529785 4.713541030883789 L 18.10177803039551 8.080031394958496 C 18.29438591003418 8.242938995361328 18.41267585754395 8.477005004882812 18.42959785461426 8.728697776794434 C 18.4465160369873 8.980392456054688 18.36061859130859 9.228185653686523 18.19155120849609 9.415407180786133 Z M 22.80364418029785 8.293242454528809 C 22.35132598876953 7.609889984130859 21.7723388671875 7.019473075866699 21.09795761108398 6.553887844085693 C 21.04873847961426 5.808096885681152 20.87423324584961 5.075926303863525 20.58175849914551 4.388113021850586 C 20.21121978759766 3.543715953826904 19.67729377746582 2.780964374542236 19.0107307434082 2.143785715103149 C 18.34795570373535 1.444494128227234 17.55005264282227 0.8871065974235535 16.66540718078613 0.5054264664649963 C 15.79789447784424 0.1615415513515472 14.87167644500732 -0.009980848990380764 13.93854904174805 0.0004527647979557514 C 12.52496910095215 -0.01111439056694508 11.1406831741333 0.4033890664577484 9.966091156005859 1.189945816993713 C 9.309941291809082 1.627422690391541 8.729944229125977 2.169509172439575 8.249179840087891 2.794638156890869 C 7.882101058959961 2.703691959381104 7.505188941955566 2.6584632396698 7.12701416015625 2.659980535507202 C 5.969903469085693 2.645954132080078 4.855045795440674 3.09432053565979 4.029842376708984 3.905582666397095 C 3.082402229309082 4.833106517791748 2.614701271057129 6.14515209197998 2.761797904968262 7.462841987609863 C 2.198121070861816 7.800862789154053 1.697013974189758 8.233636856079102 1.280542254447937 8.742107391357422 C 0.4317120611667633 9.748134613037109 -0.02288641594350338 11.02819061279297 0.001274677691981196 12.34425354003906 C -0.01413299515843391 13.86241245269775 0.6040005683898926 15.31827926635742 1.706963181495667 16.36159706115723 C 2.243374824523926 16.88541793823242 2.875882387161255 17.30074119567871 3.569756269454956 17.58475494384766 C 4.282992839813232 17.87039756774902 5.045862197875977 18.01152992248535 5.814083576202393 17.99995613098145 L 17.34992599487305 17.99995803833008 C 19.03119468688965 18.00706100463867 20.64619636535645 17.34490966796875 21.83858108520508 16.15961074829102 C 22.44420623779297 15.57993507385254 22.92863082885742 14.88571739196777 23.26372718811035 14.11727142333984 C 23.58634757995605 13.34617805480957 23.75045204162598 12.51803207397461 23.74625778198242 11.68217754364014 C 23.77743148803711 10.47163391113281 23.44520378112793 9.279511451721191 22.79241943359375 8.259578704833984 L 22.80364418029785 8.293242454528809 Z" fill="#f24444" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 8,),
                Text(
                  'Upload Attachment',
                  style: TextStyle(
                    fontFamily: 'Source Han Sans CN',
                    fontSize: 14,
                    color: const Color(0xfff24444),
                    fontWeight: FontWeight.w700,
                  ),
                  softWrap: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getPdfBuild() {
    List<Widget> build = [];
    for (var i = 0; i < filesPath.length; i++) {
      var path = filesPath[i];
      build.add(Padding(
        padding: EdgeInsets.only(top: 10),
        child: InkWell(
          onTap: () {
            openFile(path);
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 11, bottom: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x33b3b3b3),
                  offset: Offset(0, 0),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    if (path.endsWith('pdf') || path.endsWith('ppt'))
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            'assets/images/icon_pdf.png',
                            width: 24,
                            height: 24,
                          )),
                    if (path.endsWith('.doc') || path.endsWith('.docx') || path.endsWith('.xml') || path.endsWith('.xls') || path.endsWith('.xlsx'))
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            'assets/images/icon_word.png',
                            width: 24,
                            height: 24,
                          )),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'Resume ' + (i + 1).toString(),
                        style: TextStyle(
                          fontFamily: 'Source Han Sans CN',
                          fontSize: 14,
                          color: const Color(0xFF0E0F0F),
                        ),
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    var value = await showAlertDialog(
                      context,
                      content: 'Do you want to delete this resume ?',
                      buttonCancel: 'No',
                      buttonOk: 'Yes',
                    );
                    if (true == value) {
                      removeFilesPath(path);
                      initFilesData();
                    } else {}
                  },
                  child: SvgPicture.string(
                    '<svg viewBox="303.0 14.5 16.0 16.0" ><path transform="translate(248.6, -39.8)" d="M 57.89650726318359 65.87456512451172 L 59.82540130615234 65.87456512451172 L 67.73651123046875 57.96345138549805 L 65.85206604003906 56.07900238037109 L 57.89650726318359 64.01678466796875 L 57.89650726318359 65.87456512451172 Z M 67.10540008544922 54.8256721496582 L 68.98984527587891 56.71011734008789 C 69.32367706298828 57.04357147216797 69.51124572753906 57.49605941772461 69.51124572753906 57.96789169311523 C 69.51124572753906 58.43972778320312 69.32367706298828 58.89221572875977 68.98984527587891 59.22566986083984 L 61.07873153686523 67.13677978515625 C 60.74686431884766 67.47063446044922 60.2961311340332 67.65924835205078 59.82540130615234 67.66123199462891 L 57.49650955200195 67.66123199462891 C 57.13370513916016 67.67333984375 56.78164291381836 67.53699493408203 56.52162933349609 67.28368377685547 C 56.2616081237793 67.03038024902344 56.11611175537109 66.6820068359375 56.11873245239258 66.31900787353516 L 56.11873245239258 64.01678466796875 C 56.12071990966797 63.54605102539062 56.30931854248047 63.09531021118164 56.64317321777344 62.76344680786133 L 64.55429077148438 54.85233688354492 C 64.88545989990234 54.50396347045898 65.34356689453125 54.30453491210938 65.82420349121094 54.29950714111328 C 66.30484008789062 54.29448699951172 66.76702880859375 54.48429489135742 67.10540008544922 54.82566833496094 Z M 55.29206466674805 70.30123138427734 C 54.8011474609375 70.30123138427734 54.40317535400391 69.90325927734375 54.40317535400391 69.41233825683594 C 54.40317535400391 68.92141723632812 54.8011474609375 68.52344512939453 55.29206466674805 68.52344512939453 L 69.5142822265625 68.52344512939453 C 70.00520324707031 68.52344512939453 70.40317535400391 68.92141723632812 70.40317535400391 69.41233825683594 C 70.40317535400391 69.90325927734375 70.00520324707031 70.30123138427734 69.5142822265625 70.30123138427734 L 55.29206466674805 70.30123138427734 Z" fill="#9e9e9e" stroke="#ffffff" stroke-width="0.20000000298023224" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
          ),
        ),
      ));
    }
    return Column(
      children: build,
    );
  }
}

const String _svg_ed5kmq =
    '<svg viewBox="328.0 101.8 22.1 14.4" ><path transform="translate(327.31, 101.79)" d="M 14.31990051269531 14.02560043334961 C 13.76640033721924 13.50270080566406 13.76640033721924 12.65220069885254 14.31990051269531 12.12839984893799 L 18.10659790039062 8.550000190734863 L 2.064599990844727 8.550000190734863 C 1.307700037956238 8.550000190734863 0.6920999884605408 7.948800086975098 0.6920999884605408 7.209000110626221 C 0.6920999884605408 6.468300342559814 1.307700037956238 5.867100238800049 2.064599990844727 5.867100238800049 L 18.10659790039062 5.867100238800049 L 14.31990051269531 2.288700103759766 C 13.76640033721924 1.765799999237061 13.76640033721924 0.9153000116348267 14.31990051269531 0.3923999965190887 C 14.87340068817139 -0.131400004029274 15.77340030670166 -0.131400004029274 16.32690048217773 0.3923999965190887 L 22.347900390625 6.082200050354004 C 22.67008781433105 6.386576175689697 22.80465316772461 6.801939010620117 22.75175476074219 7.19909143447876 C 22.81170845031738 7.60207986831665 22.67802429199219 8.025944709777832 22.35060119628906 8.335800170898438 L 16.32690048217773 14.02560043334961 C 16.05014991760254 14.28705024719238 15.68677520751953 14.41777515411377 15.32340049743652 14.41777515411377 C 14.96002578735352 14.41777515411377 14.59665012359619 14.28705024719238 14.31990051269531 14.02560043334961 Z" fill="#0e0f0f" stroke="#f5f9fb" stroke-width="0.30000001192092896" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_o1mex8 =
    '<svg viewBox="20.0 462.5 14.0 14.0" ><path transform="translate(20.0, 580.0)" d="M 7.000100135803223 -103.5002059936523 C 3.140232086181641 -103.5002059936523 1.358032193365943e-07 -106.6404418945312 1.358032193365943e-07 -110.5003051757812 C 1.358032193365943e-07 -114.3601760864258 3.140232086181641 -117.5004043579102 7.000100135803223 -117.5004043579102 C 10.8599681854248 -117.5004043579102 14.00020027160645 -114.3601760864258 14.00020027160645 -110.5003051757812 C 14.00020027160645 -106.6404418945312 10.8599681854248 -103.5002059936523 7.000100135803223 -103.5002059936523 Z M 7.000100135803223 -107.4778747558594 C 6.524186611175537 -107.4778747558594 6.136998176574707 -107.09033203125 6.136998176574707 -106.6139755249023 C 6.136998176574707 -106.1380615234375 6.524186611175537 -105.7508850097656 7.000100135803223 -105.7508850097656 C 7.47645092010498 -105.7508850097656 7.863988876342773 -106.1380615234375 7.863988876342773 -106.6139755249023 C 7.863988876342773 -107.09033203125 7.47645092010498 -107.4778747558594 7.000100135803223 -107.4778747558594 Z M 7.000100135803223 -115.2489318847656 C 6.614005565643311 -115.2489318847656 6.251194953918457 -115.0790176391602 6.004698276519775 -114.7827453613281 C 5.757729053497314 -114.4860610961914 5.656413078308105 -114.0979995727539 5.726710319519043 -113.7180328369141 L 6.136998176574707 -109.2048645019531 C 6.136998176574707 -108.7970275878906 6.506109237670898 -108.3409805297852 7.000100135803223 -108.3409805297852 C 7.494537353515625 -108.3409805297852 7.863988876342773 -108.7970733642578 7.863988876342773 -109.2048645019531 L 8.273489952087402 -113.7180328369141 C 8.34357738494873 -114.0968475341797 8.242251396179199 -114.4845886230469 7.995501518249512 -114.7819519042969 C 7.747806072235107 -115.078727722168 7.384995937347412 -115.2489318847656 7.000100135803223 -115.2489318847656 Z" fill="#383838" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
