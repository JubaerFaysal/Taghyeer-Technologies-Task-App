import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<UserModel> login(String username, String password) async {
    final response = await _apiClient.post(
      ApiConstants.loginUrl,
      body: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    );
    return UserModel.fromJson(response);
  }
}
