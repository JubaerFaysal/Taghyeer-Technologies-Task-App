import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/post_model.dart';

class PostRepository {
  final ApiClient _apiClient = ApiClient();

  Future<PostResponse> getPosts({int skip = 0}) async {
    final url =
        '${ApiConstants.postsUrl}?limit=${ApiConstants.pageLimit}&skip=$skip';
    final response = await _apiClient.get(url);
    return PostResponse.fromJson(response);
  }
}
