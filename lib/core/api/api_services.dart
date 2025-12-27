import 'package:code_fit/features/login/data/models/login_request_model.dart';
import 'package:code_fit/features/login/data/models/login_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart'; // Ensure this is imported instead of just 'http.dart'

import 'api_constant.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: ApiConstant.baseUrl)
abstract class ApiServices {
  // The factory constructor is required for Retrofit to generate the implementation
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @POST(ApiConstant.loginEndpoint)
  Future<LoginResponseModel> login(@Body() LoginRequestModel loginRequestBody);
}
