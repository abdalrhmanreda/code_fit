import 'package:code_fit/blocked_and_maintance/data/models/app_status_model.dart';
import 'package:code_fit/core/api/api_services.dart';
import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';

class AppStatusRepo {
  final ApiServices _apiServices;

  AppStatusRepo(this._apiServices);

  Future<Either<String, AppStatusModel>> getAppStatus(int appId) async {
    try {
      final response = await _apiServices.getStatus(appId);
      return Right(response);
    } catch (error) {
      if (error is DioException) {
        return Left(
          error.response?.data['message'] ?? 'Network error occurred',
        );
      }
      return Left('An unexpected error occurred');
    }
  }

  Future<Either<String, AppStatusModel>> setAppStatus(
    int appId,
    bool isBlocked,
    bool isMaintainance,
  ) async {
    try {
      final response = await _apiServices.setStatus(
        appId,
        isBlocked,
        isMaintainance,
      );
      return Right(response);
    } catch (error) {
      if (error is DioException) {
        return Left(
          error.response?.data['message'] ?? 'Network error occurred',
        );
      }
      return Left('An unexpected error occurred');
    }
  }
}
