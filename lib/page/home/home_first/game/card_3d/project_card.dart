import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:ima2_habeesjobs/page/home/home_first/card_build.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/card_3d/delete_project_dialog.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/card_3d/project_card_constants.dart';
import 'package:ima2_habeesjobs/page/home/home_first/game/card_3d/shader_helper.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    Key key,
    this.child,
    this.onOpen,
    this.width,
    this.height,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onOpen;
  final double width;
  final double height;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with TickerProviderStateMixin {
  final double cornerRadius = 16.0;

  AnimationController _animation;
  AudioPlayer _audioPlayer;
  double _width;

  bool _isPlaying = false;
  bool _isDialogShown = false;

  double pianyiliang = 0.0;


  var backShader,backImage, backSize, backCanvas;
  @override
  void initState() {
    super.initState();
    _animation = AnimationController.unbounded(
      vsync: this,
      duration: ProjectCardConstants.animationDuration,
    );
    _animation.value = 0.0;
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playPauseAudio() async {
    if (!_isPlaying) {
      await _audioPlayer.seek(ProjectCardConstants.seekAudioDuration);
      await _audioPlayer.play(AssetSource(ProjectCardConstants.audioAsset));
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _showCupertinoDialog() async {
    setState(() {
      _isDialogShown = true;
    });
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteProjectDialog(
          onCancel: _handleCancel,
          onDelete: _handleDelete,
        );
      },
    );
    setState(() {
      _isDialogShown = false;
    });
  }

  Future<void> _handleCancel() async {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop();
    await _animation.animateTo(
      0,
      duration: ProjectCardConstants.pauseAnimationDuration,
    );
  }

  Future<void> _handleDelete() async {
    //震动，振动
    HapticFeedback.heavyImpact();
    // Navigator.of(context).pop();
    widget.onOpen();
    await _animation.animateTo(
      0,
      duration: ProjectCardConstants.deleteAnimationDuration,
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _width = context.size.width;
    final double newPointer = _animation.value + details.primaryDelta * _width / 200;
    _animation.value = newPointer;
    final double value = _animation.value + _width;

    setState(() {
      pianyiliang = newPointer;
    });
    if (value < -ProjectCardConstants.dialogThreshold && !_isDialogShown) {
      // widget.onOpen();
      _handleDelete();
      // _showCupertinoDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (_) => _playPauseAudio(),
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: (_) => _stopAudioAndReset(),
      onHorizontalDragCancel: _resetAnimation,
      child: AnimatedBuilder(
        animation: _animation,
        builder: _buildAnimatedCard,
      ),
    );
  }

  Widget _buildAnimatedCard(BuildContext context, Widget child) {
    var pokerWidth = widget.height / 8.7 * 5.7 - 40;
    var pokerHeight = pokerWidth / 5.7 * 8.7;
    return Stack(
      // alignment: Alignment.centerRight,
      children: [
        ShaderBuilder(
          (context, shader, _) {
            return AnimatedSampler(
              (image, size, canvas) {
                ShaderHelper.configureShader(shader, size, image, _animation.value);
                ShaderHelper.drawShaderRect(shader, size, canvas);
                // if(backShader!=null && backCanvas!=null){
                //   // ShaderHelper.drawShaderRect(shader, size, backCanvas);
                //   ShaderHelper.configureShader(shader, size, backImage, _animation.value);
                // }else{
                //   ShaderHelper.configureShader(shader, size, image, _animation.value);
                // }
                // ShaderHelper.drawShaderRect(shader, size, canvas);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: ProjectCardConstants.cornerRadius,
                ),
                child: widget.child,
              ),
            );
          },
          assetKey: ProjectCardConstants.shaderAssetKey,
        ),
        // ShaderBuilder(
        //       (context, shader, _) {
        //     return AnimatedSampler(
        //           (image, size, canvas) {
        //             setState(() {
        //               backShader = shader;
        //               backImage = image;
        //               backSize = size;
        //               backCanvas = canvas;
        //             });
        //         ShaderHelper.configureShader(shader, size, image, _animation.value);
        //         ShaderHelper.drawShaderRect(shader, size, canvas);
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(
        //           vertical: ProjectCardConstants.cornerRadius,
        //         ),
        //         child: ClipRRect(
        //           borderRadius: BorderRadius.circular(10),
        //           clipBehavior: Clip.hardEdge,
        //           child: Stack(
        //             children: [
        //               Positioned.fill(
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(),
        //                   child: Align(
        //                     alignment: Alignment.centerRight,
        //                     child: getCardBackBuild(width: pokerWidth,),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        //   assetKey: ProjectCardConstants.shaderAssetKey,
        // ),

        // ShaderBuilder(
        //       (context, shader, _) {
        //     return AnimatedSampler(
        //           (image, size, canvas) {
        //         ShaderHelper.configureShader(shader, size, image, _animation.value);
        //         ShaderHelper.drawShaderRect(shader, size, canvas);
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(
        //           vertical: ProjectCardConstants.cornerRadius,
        //         ),
        //         child: getCardBackBuild(width: pokerWidth-0),
        //       ),
        //     );
        //   },
        //   assetKey: ProjectCardConstants.shaderAssetKey,
        // ),

        // Positioned(
        //   child: Container(
        //     width: pokerWidth,
        //     height: pokerHeight,
        //     alignment: Alignment.centerLeft,
        //     child: Builder(
        //       builder: (context) {
        //         var animationvalue = _animation.value;
        //         animationvalue = animationvalue*0.5;
        //         if(-animationvalue>=pokerWidth){
        //           animationvalue = -pokerWidth;
        //         }
        //         var width = pokerWidth + animationvalue;
        //         return Container(
        //           width: width,
        //           height: pokerHeight,
        //           alignment: Alignment.centerRight,
        //           child: ListView(
        //             physics: NeverScrollableScrollPhysics(),
        //             scrollDirection: Axis.horizontal,
        //             children: [Center(child: getCardBackBuild(width: pokerWidth-0))],
        //           ),
        //         );
        //       }
        //     ),
        //   ),
        // )
      ],
    );
  }

  Future<void> _stopAudioAndReset() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
    if (!_isDialogShown) {
      _resetAnimation();
    }
  }

  void _resetAnimation() {
    // HapticFeedback.selectionClick();
    // if (!_isDialogShown) {
    //   _animation.animateTo(0);
    // }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animation.dispose();
    super.dispose();
  }
}
