import 'package:code_fit/core/api/api_services.dart';
import 'package:code_fit/features/login/data/models/login_request_model.dart';
import 'package:code_fit/features/login/data/models/login_response_model.dart';
import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_error_model.dart';

class LoginRepo {
  final ApiServices apiServices;

  LoginRepo(this.apiServices);

  Future<Either<ApiErrorModel, LoginResponseModel>> login(
    LoginRequestModel loginRequestBody,
  ) async {
    try {
      // final response = await apiServices.login(loginRequestBody);
      final response = LoginResponseModel(token: 'token', userId: '');
      return Right(response);
    } catch (error) {
      if (error is DioException) {
        // Dio error → extract real JSON error
        final data = error.response?.data;

        if (data is Map<String, dynamic>) {
          return Left(ApiErrorModel.fromJson(data));
        }

        // no real JSON
        return Left(
          ApiErrorModel.fromStatusCode(
            error.response?.statusCode ?? -1,
            customMessage: error.message,
          ),
        );
      }

      // Any other error
      return Left(
        ApiErrorModel.fromStatusCode(-1, customMessage: error.toString()),
      );
    }
  }
}
