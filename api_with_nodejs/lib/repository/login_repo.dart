import 'package:api_with_nodejs/data/network/base_api_services.dart';
import 'package:api_with_nodejs/data/network/network_api_services.dart';

class LoginRepo {
  BaseApiService baseApiService = NetworkApiService();

  Future<dynamic> login(dynamic body) async {
    dynamic response = await baseApiService.getPostApiResponse(
        "http://10.0.2.2:8000/api/login", body);
    return response;
  }
}
