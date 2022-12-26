import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/e_service_repository.dart';

class SearchController extends GetxController {
  final heroTag = "".obs;
  final categories = <Category>[].obs;
  final selectedCategories = <String>[].obs;
  TextEditingController textEditingController;
  final eProviders = <EProvider>[].obs;
  // final eServices = <EService>[].obs;
  EProviderRepository _eServiceRepository;
  // EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;

  List<EProvider>  get eproviderNew=> eProviders;

  SearchController() {
    _eServiceRepository = new EProviderRepository();
    // _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    textEditingController = new TextEditingController();
  }

  // @override
  // void onClose() {
  //    categories.value = [];
  //    selectedCategories.value = [];
  //    textEditingController.clear();
  //    update();
  //   super.onClose();
  // }

  @override
  void onInit() async {
    await refreshSearch();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments as String;
    super.onReady();
  }

  Future refreshSearch({bool showMessage}) async {
    await getCategories();
    await searchEServices();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  Future searchEServices({String keywords}) async {
    print('itsupdateing');
    update();
    // try {
    //   var newEprovider = eProviders.toList();
    //   if (selectedCategories.isEmpty) {
    //
    //     eproviderNew.where((e) { print('itsworkgin '); return e.name.contains(keywords);}).toList();
    //     eProviders.assignAll(
    //
    //         eproviderNew.where((e) { print('itsworkgin '); return e.name.contains(keywords);}).toList()
    //
    //
    //         // await _eServiceRepository.search(keywords, categories.map((element) => element.id).toList())
    //     );
    //     print('checlesearch = ${eProviders.length}');
    //   } else {
    //     eProviders.assignAll(
    //         eProviders.where((e) => e.name.contains(keywords)).toList()
    //       // await _eServiceRepository.search(keywords, categories.map((element) => element.id).toList())
    //     );
    //     // eProviders.assignAll(await _eServiceRepository.search(keywords, selectedCategories.toList()));
    //   }
    // } catch (e) {
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    // }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelectedCategory(Category category) {
    return selectedCategories.contains(category.id);
  }

  void toggleCategory(bool value, Category category) {
    if (value) {
      selectedCategories.add(category.id);
      update();
    } else {
      selectedCategories.removeWhere((element) => element == category.id);
      update();
    }
  }
}
