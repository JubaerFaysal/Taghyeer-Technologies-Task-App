import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';

class PostController extends GetxController {
  final PostRepository postRepo = PostRepository();

  final RxList<PostModel> posts = <PostModel>[].obs;
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
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    errorMessage.value = '';
    skip = 0;
    posts.clear();

    try {
      final response = await postRepo.getPosts(skip: skip);
      posts.addAll(response.posts);
      total = response.total;
      skip += response.posts.length;
      hasMore.value = posts.length < total;
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
      final response = await postRepo.getPosts(skip: skip);
      posts.addAll(response.posts);
      skip += response.posts.length;
      hasMore.value = posts.length < total;
    } on AppException catch (e) {
      isPaginationError.value = true;
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isPaginationError.value = true;
      Get.snackbar('Error', 'Failed to load more posts.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isPaginationLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await fetchPosts();
  }
}
