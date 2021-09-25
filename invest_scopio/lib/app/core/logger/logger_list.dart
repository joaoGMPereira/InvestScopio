import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:invest_scopio/app/UI/DesignSystemWidgets/ripple_card.dart';
import 'package:invest_scopio/app/core/logger/log.dart';
import 'logger_controller.dart';

class LoggerList extends GetView<LoggerController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _headerWidget(),
          SizedBox(height: 8),
          Expanded(
            child: Obx(
              () => Stack(
                children: [
                  ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.filteredLogs.length,
                      itemBuilder: (context, index) {
                        return _logWidget(index);
                      }),
                  _positionedArrow(Icons.keyboard_arrow_down_rounded,
                      controller.showTopIndicator.value,
                      top: 0, onTap: () {
                    controller.scrollController.animateTo(
                        controller.scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.bounceIn);
                  }),
                  _positionedArrow(Icons.keyboard_arrow_up_rounded,
                      controller.showBottomIndicator.value, bottom: 0,
                      onTap: () {
                    controller.scrollController.animateTo(
                        controller.scrollController.initialScrollOffset,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.bounceIn);
                  }),
                  controller.isCopying.value
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
            controller.copyRequests();
          }),
          Divider(height: 1),
          _copyOption("Copiar Responses", onTap: () {
            controller.copyResponses();
          }),
          Divider(height: 1),
          _copyOption("Copiar Errors", onTap: () {
            controller.copyErrors();
          })
        ]);
  }

  Widget _copyOption(String text, {GestureTapCallback? onTap}) {
    return RippleCard(
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: Get.theme.textTheme.button)),
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
              controller: controller.textEditingController,
              decoration: InputDecoration(
                hintText: "Pesquisa",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              onSubmitted: (text) {
                controller.filter.value = text;
              },
            ),
          ),
          SizedBox(width: 8),
          Row(
            children: [
              Row(
                  children: VLogType.values
                      .map((value) => _typeItemWidget(value))
                      .toList()),
              Obx(
                () => RippleCard(
                  color: controller.isCopying.value
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.copy),
                  ),
                  onTap: () {
                    controller.isCopying.value = !controller.isCopying.value;
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _typeItemWidget(VLogType value) {
    return Obx(
      () => RippleCard(
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

  Color _colorTypeItem(VLogType value) {
    switch (value) {
      case VLogType.Debug:
        return controller.isDebug.value
            ? Colors.grey.withOpacity(0.1)
            : Colors.transparent;
      case VLogType.Error:
        return controller.isError.value
            ? Colors.grey.withOpacity(0.1)
            : Colors.transparent;
      case VLogType.Info:
        return controller.isInfo.value
            ? Colors.grey.withOpacity(0.1)
            : Colors.transparent;
    }
  }

  _onTapTypeItem(VLogType value) {
    switch (value) {
      case VLogType.Debug:
        controller.isDebug.value = !controller.isDebug.value;
        break;
      case VLogType.Error:
        controller.isError.value = !controller.isError.value;
        break;
      case VLogType.Info:
        controller.isInfo.value = !controller.isInfo.value;
        break;
    }
  }

  Widget _logWidget(int index) {
    if (controller.filteredLogs.length > index) {
      var log = controller.filteredLogs[index];
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
                    log.type?.icon ?? VLogType.Debug.icon,
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(log.title ?? "",
                          style: Get.theme.textTheme.headline5),
                    )
                  ],
                ),
                Flexible(
                  child: Text(log.message ?? "",
                      style: Get.theme.textTheme.caption
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
