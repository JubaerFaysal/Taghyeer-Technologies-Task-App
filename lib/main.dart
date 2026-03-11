import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/storage_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  Get.put(ThemeController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode.value;
        return GetMaterialApp(
          key: ValueKey(isDark),
          title: 'Taghyeer Technologies',
          debugShowCheckedModeBanner: false,
          theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          initialRoute:
              StorageService.isLoggedIn() ? AppRoutes.home : AppRoutes.login,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
