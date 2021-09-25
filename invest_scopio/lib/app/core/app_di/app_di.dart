import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:invest_scopio/app/core/logger/logger_interceptor.dart';
import 'package:invest_scopio/app/core/logger/logger.dart';
import 'package:invest_scopio/app/core/logger/logger_controller.dart';
import 'package:invest_scopio/app/core/networks/network.dart';
import 'package:invest_scopio/app/core/storage/storage_repository.dart';
import 'package:invest_scopio/app/main/app_config.dart';
import 'package:invest_scopio/app/main/main.dart';
import 'package:kotlin_flavor/scope_functions.dart';

Future<void> setupDI(AppConfig? appConfig) async {
  // Logger:----------------------------------------------------------------
  Get.lazyPut<LoggerController>(() => LoggerController());
  Get.lazyPut<VLogger>(() => VLogger(Get.find()));
  Get.lazyPut<LoggerInterceptor>(() => LoggerInterceptor(Get.find()));

  // network:----------------------------------------------------------------
  appConfig?.let((appConfig) {
    Get.lazyPut<AppConfig>(() => appConfig);
    appConfig.baseUrl?.let((baseUrl) {

      Get.lazyPut<StorageRepository>(() => StorageRepositoryImpl(GetStorage()));
      Get.lazyPut<Network>(() => Network.create(baseUrl, Get.find(), Get.find()));
    });
  });
}
