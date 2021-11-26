import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'log.dart';
import 'logger_store.dart';

class VLoggerList extends StatefulWidget {
  final LoggerStore store;

  VLoggerList(this.store);

  @override
  _VLoggerListState createState() => _VLoggerListState(store);
}

class _VLoggerListState extends State<VLoggerList> {
  LoggerStore _store;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  _VLoggerListState(this._store);

  @override
  void initState() {
    super.initState();
    _store.reset();
    _controller.addListener(() {
      _store.filter = _controller.text;
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _store.atTop(true);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _store.atTop(false);
      }
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          _store.atTop(true);
        } else {
          _store.atTop(false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _headerWidget(),
          SizedBox(height: 8),
          Expanded(
            child: Observer(
              builder: (_) => Stack(
                children: [
                  ListView.builder(
                      controller: _scrollController,
                      itemCount: _store.filteredLogs.length,
                      itemBuilder: (context, index) {
                        return _logWidget(index);
                      }),
                  _positionedArrow(Icons.keyboard_arrow_down_rounded,
                      _store.showTopIndicator,
                      top: 0, onTap: () {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.bounceIn);
                      }),
                  _positionedArrow(Icons.keyboard_arrow_up_rounded,
                      _store.showBottomIndicator,
                      bottom: 0, onTap: () {
                        _scrollController.animateTo(
                            _scrollController.initialScrollOffset,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.bounceIn);
                      }),
                  _store.isCopying
                      ? Positioned(
                    top: 0,
                    right: 5,
                    child: SizedBox(
                      width: 200,
                      child: RippleCard(
                          elevation: 2,
                          color: Colors.white,
                          child: _copyingWidget()),
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _copyingWidget() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _copyOption("Copiar Requests", onTap: () {
            _store.copyRequests();
          }),
          Divider(height: 1),
          _copyOption("Copiar Responses", onTap: () {
            _store.copyResponses();
          }),
          Divider(height: 1),
          _copyOption("Copiar Errors", onTap: () {
            _store.copyErrors();
          })
        ]);
  }

  Widget _copyOption(String text, {GestureTapCallback? onTap}) {
    return RippleCard(
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: Theme.of(context).textTheme.button)),
        onTap: onTap);
  }

  Widget _positionedArrow(IconData icon, bool isHidden,
      {double? top, double? bottom, GestureTapCallback? onTap}) {
    return Positioned(
        top: top,
        bottom: bottom,
        right: 5,
        child: AnimatedOpacity(
            opacity: isHidden ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: RippleCard(
                color: Color.fromRGBO(50, 50, 50, 1),
                child: Icon(icon, color: Colors.white),
                onTap: onTap)));
  }

  Widget _headerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Pesquisa",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              onSubmitted: (text) {
                _store.filter = text;
              },
            ),
          ),
          SizedBox(width: 8),
          Row(
            children: [
              Row(
                  children: LogType.values
                      .map((value) => _typeItemWidget(value))
                      .toList()),
              Observer(
                builder: (_) => RippleCard(
                  color: _store.isCopying
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.copy),
                  ),
                  onTap: () {
                    _store.isCopying = !_store.isCopying;
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _typeItemWidget(LogType value) {
    return Observer(
      builder: (_) => RippleCard(
        color: _colorTypeItem(value),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: value.icon,
        ),
        onTap: () {
          _onTapTypeItem(value);
        },
      ),
    );
  }

  Color _colorTypeItem(LogType value) {
    switch (value) {
      case LogType.Debug:
        return _store.isDebug
            ? Colors.grey.withOpacity(0.1)
            : Colors.transparent;
      case LogType.Error:
        return _store.isError
            ? Colors.grey.withOpacity(0.1)
            : Colors.transparent;
      case LogType.Info:
        return _store.isInfo
            ? Colors.grey.withOpacity(0.1)
            : Colors.transparent;
    }
  }

  _onTapTypeItem(LogType value) {
    switch (value) {
      case LogType.Debug:
        _store.isDebug = !_store.isDebug;
        break;
      case LogType.Error:
        _store.isError = !_store.isError;
        break;
      case LogType.Info:
        _store.isInfo = !_store.isInfo;
        break;
    }
  }

  Widget _logWidget(int index) {
    if (_store.filteredLogs.length > index) {
      var log = _store.filteredLogs[index];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: RippleCard(
          elevation: 3,
          color: Colors.grey.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    log.type?.icon ?? LogType.Debug.icon,
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(log.title ?? "",
                          style: Theme.of(context).textTheme.headline5),
                    )
                  ],
                ),
                Flexible(
                  child: Text(log.message ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          onTap: () {
            Clipboard.setData(new ClipboardData(text: log.message));
            Fluttertoast.showToast(
              timeInSecForIosWeb: 4,
              msg: "Copiado para o teclado",
              backgroundColor: Colors.black87,
              gravity: ToastGravity.TOP,
            );
          },
        ),
      );
    }
    return Container();
  }
}

class RippleCard extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final BorderSide side;
  final BorderRadius borderRadius;
  final double? elevation;
  final GestureTapCallback? onTap;

  RippleCard(
      {@required this.child,
        this.onTap,
        this.elevation = 1,
        this.color = Colors.transparent,
        this.side = BorderSide.none,
        this.borderRadius = const BorderRadius.all(Radius.circular(8))});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          side: side,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
            borderRadius: borderRadius,
            child: InkWell(
                borderRadius: borderRadius,
                child: Ink(
                    decoration:
                    BoxDecoration(color: color, borderRadius: borderRadius),
                    child: child),
                onTap: onTap)));
  }
}
