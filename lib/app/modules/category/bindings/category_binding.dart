import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {Get.lazyPut<HomeController>(
        () => HomeController(),
  );
    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );
    Get.lazyPut<CategoriesController>(
      () => CategoriesController(),
    );
  }
}
