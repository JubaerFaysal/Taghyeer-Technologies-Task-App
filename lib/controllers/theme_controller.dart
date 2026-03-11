import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/storage_service.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = StorageService.getThemeMode();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    StorageService.saveThemeMode(isDarkMode.value);
    update();
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
}
