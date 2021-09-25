import 'package:equatable/equatable.dart';

abstract class NetworkBaseRequestQuery extends Equatable{
  Map<String, dynamic> toQueryParameters();

  @override
  List<Object> get props;
}
