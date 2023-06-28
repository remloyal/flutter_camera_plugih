import 'package:video_camera/player_controller.dart';
import 'package:flutter/material.dart';

class PlayerControlBar extends StatefulWidget {

  final PlayerController controller;

  //清晰度菜单
  final List<MenuItem> definitions;

  //模式菜单
  final List<MenuItem> modes;

  const PlayerControlBar({
    super.key,
    required this.controller,
    this.definitions = const <MenuItem>[],
    this.modes = const <MenuItem>[],
  });

  @override
  State<StatefulWidget> createState() => _PlayerControlBarState();
}

class _PlayerControlBarState extends State<PlayerControlBar> {

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  void _refresh() {
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (widget.controller.status) {
      case PlayerStatus.uninitialized:
      case PlayerStatus.loading:
        content = const Center(
          child: CircularProgressIndicator(color: Colors.white,),
        );
        break;
      case PlayerStatus.initialized:
      case PlayerStatus.completed:
      case PlayerStatus.playing:
        content = InkWell(
          onTap: widget.controller.handlePlay,
          child: Container(
            child: widget.controller.playing ? null : _buildIcon(Icons.play_circle_outline, 50),
          ),
        );
        break;
      case PlayerStatus.error:
        content = InkWell(
          onTap: widget.controller.handlePlay,
          child: const Center(
            child: Text('播放失败，请重试', style: TextStyle(color: Colors.white),),
          ),
        );
        break;
    }

    Widget toolbar = Container(
      color: Colors.white54,
      // height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: widget.controller.handlePlay,
                child: widget.controller.status == PlayerStatus.playing
                    ? _buildIcon(Icons.pause_circle_outline)
                    : _buildIcon(Icons.play_circle_outline),
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  widget.controller.handleAudio();
                },
                child: widget.controller.mute
                    ? _buildIcon(Icons.volume_off)
                    : _buildIcon(Icons.volume_up),
              ),
              _PlayerPopupMenuButton(
                text: '清晰度',
                items: widget.definitions,
                initialIndex: widget.controller.definitionIndex,
              ),
              _PlayerPopupMenuButton(
                text: '模式',
                items: widget.modes,
                initialIndex: widget.controller.modeIndex,
              )
            ],
          )
        ],
      ),
    );

    return Column(
      children: [
        Expanded(
          child: content,
        ),
        toolbar
      ],
    );
  }

  Widget _buildIcon(IconData data, [double? size]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Icon(data, color: Colors.white, size: size,),
    );
  }

  Widget _buildMask(Widget? child) {
    return InkWell(
      onTap: widget.controller.handlePlay,
      child: child,
    );
  }
}

class _PlayerPopupMenuButton extends StatelessWidget {

  final String text;

  final List<MenuItem> items;

  final int? initialIndex;

  const _PlayerPopupMenuButton({required this.text, required this.items, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (items.isEmpty) return;
        _showPlayerMenu(context, items, initialIndex);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showPlayerMenu(BuildContext context, List<MenuItem> items, int? initialIndex) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double maxWidth = MediaQuery.of(context).size.width;

    //计算弹出菜单的偏移
    const double hSpace = 10.0;
    const double vSpace = 5.0;
    double width = 2 * hSpace;
    double height = 0;
    final List<Widget> menus = List<Widget>.generate(items.length, (index) {
      MenuItem item = items[index];
      TextPainter painter = _calculate(context, item.text);
      if (width < painter.width) width = painter.width + 2 * hSpace;
      height = height + painter.height + 2 * vSpace;
      return _buildItem(context, hSpace, vSpace, item, index == initialIndex);
    });

    double left = offset.dx + renderBox.size.width / 2 - width / 2;
    if (left + width > maxWidth) {
      left = maxWidth - width;
    }

    double top = offset.dy - height;

    showDialog(
        useSafeArea: false,
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: Stack(
              children: [
                Container(),
                Positioned(
                  top: top,
                  left: left,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: menus,
                    ),
                  ),
                )

              ],
            ),
          );
        });
  }

  //计算文本布局的宽高
  TextPainter _calculate(BuildContext context, String text) {
    TextPainter painter = TextPainter(
        locale: Localizations.localeOf(context),
        maxLines: 1,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: text
        )
    )..layout(maxWidth: double.infinity);
    return painter;
  }

  Widget _buildItem(BuildContext context, double hSpace, double vSpace, MenuItem item, bool selected) {
    Color selectedColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        item.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hSpace, vertical: vSpace),
        alignment: Alignment.center,
        color: selected ? selectedColor : Colors.white54,
        child: Text(item.text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class MenuItem {
  VoidCallback onTap;
  String text;

  MenuItem({required this.onTap, required this.text});
}