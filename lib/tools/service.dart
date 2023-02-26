import 'package:dio/dio.dart';
import 'package:quiz_app/common/app_config.dart';

class ApiClient {
  Future getData(String path) async {
    try {
      final response = await Dio(
        BaseOptions(baseUrl: AppConfig.baseUrl)
      ).get(path);

      return response.data;
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}