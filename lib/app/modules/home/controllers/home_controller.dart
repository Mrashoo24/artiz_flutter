import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';

enum CategoryFilter { ALL, FEATURED, }


class HomeController extends GetxController {
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;
  EProviderRepository _eProviderpository;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;
  final eServices = <EService>[].obs;

  List<EProvider> eProviderList = [EProvider()].obs;
  final categories = <Category>[].obs;

  final featured = <Category>[].obs;

  ///For catcontrolller
  final category = new Category().obs;
  final subcategory = new Category().obs;

  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  // EProviderRepository _eServiceRepository;
  ScrollController scrollController = ScrollController();


  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
    _eProviderpository = new EProviderRepository();

  }

  @override
  Future<void> onInit() async {
   print('checkArgs = ${Get.arguments}');

    category.value = Get.arguments as Category;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadEServicesOfCategory(

            // category.value.id,
            filter: selected.value
        );
      }
    });
    await refreshHome();
    await refreshEServices();
    super.onInit();
  }

  Future<bool> refreshHome({bool showMessage = false}) async {
    await getSlider();
    await getCategories();
    await getEProviderAll();
    await getFeatured();
    await getRecommendedEServices();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
    return true;
  }

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<List<EProvider>> getEProviderAll() async {
    print('previousList = ${eProviderList.length}');
    eProviderList.clear();
    print('currentList = ${eProviderList.length}');
    eProviderList = await _eProviderpository.getAll();
    // eProviderList.assignAll(await _eProviderpository.getAll()) ;
    print('final List = ${eProviderList.length}');

    // try {
    //   eProviderList.assignAll(await _eProviderpository.getAll()) ;
    // } catch (e) {
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    // }
    return eProviderList;
  }






  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    toggleSelected(selected.value);
    await loadEServicesOfCategory(
        // category.value.id,
        filter: selected.value
    );
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.eProviderList.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadEServicesOfCategory(
      // String categoryId,
      {CategoryFilter filter}
      ) async {
    try {
      print("elementFilter1 = ${filter}");

      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EProvider> _eServices = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _eServices = await _eProviderpository.getAll();
          break;
        case CategoryFilter.FEATURED:

          _eServices = _eServices.where((element) {
            print("elementFilter = ${element.featured}");
            return element.featured;}).toList();

          print('featirerunning ${_eServices}');
          // await _eServiceRepository.getFeatured(categoryId, page: this.page.value);
          break;
      // case CategoryFilter.POPULAR:
      //   _eServices =
      //   await _eServiceRepository.getPopular(categoryId, page: this.page.value);
      //   break;
        // case CategoryFilter.RATING:
        //   _eServices = await _eServiceRepository.getMostRated(categoryId, page: this.page.value);
        //   break;
      // case CategoryFilter.AVAILABILITY:
      //   _eServices = await _eServiceRepository.getAvailable(categoryId, page: this.page.value);
      //   break;
        default:
          _eServices = await _eProviderpository.getAll();
      }
      if (_eServices.isNotEmpty) {
        this.eProviderList.addAll(_eServices);
        update();
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

}
