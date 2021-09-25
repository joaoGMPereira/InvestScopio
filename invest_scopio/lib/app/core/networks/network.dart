import 'package:dio/dio.dart';
import 'package:invest_scopio/app/core/logger/logger_interceptor.dart';
import 'package:invest_scopio/app/core/storage/storage_repository.dart';
import 'base_interceptors.dart';
import 'base_network.dart';

class Network extends BaseNetwork {
  Network(Dio dio) : super(dio);

  factory Network.create(
          String baseUrl,
          StorageRepository storageRepository,
          LoggerInterceptor loggerInterceptor) =>
      Network(Dio(BaseOptions(baseUrl: baseUrl))
        ..interceptors.add(TokenInterceptor(storageRepository))
        ..interceptors.add(LoggingInterceptor(loggerInterceptor)));
}
