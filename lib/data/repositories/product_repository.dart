import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ProductResponse> getProducts({int skip = 0}) async {
    final url =
        '${ApiConstants.productsUrl}?limit=${ApiConstants.pageLimit}&skip=$skip';
    final response = await _apiClient.get(url);
    return ProductResponse.fromJson(response);
  }
}
