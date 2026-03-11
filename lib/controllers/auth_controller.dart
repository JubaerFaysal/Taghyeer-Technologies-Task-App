import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../core/utils/storage_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository authRepo = AuthRepository();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCachedUser();
  }

  void loadCachedUser() {
    final userData = StorageService.getUser();
    if (userData != null) {
      user.value = UserModel.fromJson(userData);
    }
  }

  bool get isLoggedIn => StorageService.isLoggedIn();

  Future<void> login(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      errorMessage.value = 'Please enter both username and password';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await authRepo.login(username.trim(), password);
      user.value = result;
      await StorageService.saveUser(result.toJson());
      Get.offAllNamed(AppRoutes.home);
    } on UnauthorizedException catch (e) {
      errorMessage.value = e.message;
    } on NetworkException catch (e) {
      errorMessage.value = e.message;
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await StorageService.clearUser();
    user.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
