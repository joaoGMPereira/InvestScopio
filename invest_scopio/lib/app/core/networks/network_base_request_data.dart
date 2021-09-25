import 'package:equatable/equatable.dart';

abstract class NetworkBaseRequestData extends Equatable {
  Map<String, dynamic> toJson();

  @override
  List<Object> get props;
}
