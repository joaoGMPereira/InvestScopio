import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invest_scopio/app/core/logger/logger.dart';
import 'package:invest_scopio/app/core/logger/logger_controller.dart';

class LoggerButton extends GetView<LoggerController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isEnabled.value
          ? Positioned(
              top: controller.yPosition.value,
              left: controller.xPosition.value,
              child: GestureDetector(
                onPanUpdate: (tapInfo) {
                  controller.xPosition.value += tapInfo.delta.dx;
                  controller.yPosition.value += tapInfo.delta.dy;
                },
                child: FloatingActionButton(
                  child: Text(
                    "Logs",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                  onPressed: () {
                    VLogger.showLogList(context);
                  },
                ),
              ),
            )
          : Container(),
    );
  }
}
