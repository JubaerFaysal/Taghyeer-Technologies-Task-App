import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository productRepo = ProductRepository();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPaginationError = false.obs;
  int skip = 0;
  int total = 0;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    skip = 0;
    products.clear();

    try {
      final response = await productRepo.getProducts(skip: skip);
      products.addAll(response.products);
      total = response.total;
      skip += response.products.length;
      hasMore.value = products.length < total;
    } on AppException catch (e) {
      errorMessage.value = e.toString();
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isPaginationLoading.value || !hasMore.value) return;

    isPaginationLoading.value = true;
    isPaginationError.value = false;

    try {
      final response = await productRepo.getProducts(skip: skip);
      products.addAll(response.products);
      skip += response.products.length;
      hasMore.value = products.length < total;
    } on AppException catch (e) {
      isPaginationError.value = true;
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isPaginationError.value = true;
      Get.snackbar('Error', 'Failed to load more products.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isPaginationLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchProducts();
  }
}
