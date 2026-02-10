import 'package:code_fit/blocked_and_maintance/data/models/app_status_model.dart';
import 'package:dio/dio.dart';

import 'api_constant.dart';

class ApiServices {
  final Dio _dio;

  ApiServices(this._dio);

  Future<AppStatusModel> getStatus(int appId) async {
    try {
      final response = await _dio.get(
        ApiConstant.getStatusEndpoint,
        queryParameters: {'appId': appId},
      );
      return AppStatusModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppStatusModel> setStatus(
    int appId,
    bool isBlocked,
    bool isMaintainance,
  ) async {
    try {
      final response = await _dio.get(
        ApiConstant.setStatusEndpoint,
        queryParameters: {
          'appId': appId,
          'isBlocked': isBlocked,
          'isMantainance': isMaintainance,
        },
      );
      return AppStatusModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
