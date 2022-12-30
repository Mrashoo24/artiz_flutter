import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_provider_type_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/tax_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/select_dialog.dart';

class EProviderFormController extends GetxController {
  final eProvider = EProvider().obs;
  final optionGroups = <OptionGroup>[].obs;
  final categories = <Category>[].obs;
  final eProviders = <EProvider>[].obs;
  final employees = <User>[].obs;
  final taxes = <Category>[].obs;
  // final eProviderTypes = <EProviderType>[].obs;
  final eProviderTypes = <Category>[].obs;
  GlobalKey<FormState> eProviderForm = new GlobalKey<FormState>();
  EProviderRepository _eProviderRepository;
  CategoryRepository _categoryRepository;



  EProviderFormController() {
    _eProviderRepository = new EProviderRepository();
    _categoryRepository = new CategoryRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      eProvider.value = arguments['eProvider'] as EProvider;
    }
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEProvider();
    super.onReady();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    await getEProviderTypes();
    await getEmployees();

    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: eProvider.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEProviderTypes() async {
    try {
      // eProviderTypes.assignAll(await _eProviderRepository.getEProviderTypes());
    eProviderTypes.assignAll ( await _categoryRepository.getAllWithSubCategories());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEmployees() async {
    try {
      employees.assignAll(await _eProviderRepository.getAllEmployees());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getTaxes() async {
    try {
      taxes.assignAll(await eProvider.value.category.subCategories);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEProviders() async {
    try {
      eProviders.assignAll(await _eProviderRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<MultiSelectDialogItem<User>> getMultiSelectEmployeesItems() {
    return employees.map((element) {
      return MultiSelectDialogItem(element, element.name);
    }).toList();
  }

  List<MultiSelectDialogItem<Category>> getMultiSelectTaxesItems() {
    return taxes.map((element) {
      return MultiSelectDialogItem(element, element.name);
    }).toList();
  }

  // List<SelectDialogItem<EProviderType>> getSelectProviderTypesItems() {
  //   return eProviderTypes.map((element) {
  //     return SelectDialogItem(element, element.name);
  //   }).toList();
  // }

  List<SelectDialogItem<Category>> getSelectProviderTypesItems() {
    return eProviderTypes.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !eProvider.value.hasData;
  }

  void createEProviderForm() async {
    Get.focusScope.unfocus();
    if (eProviderForm.currentState.validate()) {
      try {
        eProviderForm.currentState.save();
        User user = Get.find<AuthService>().user.value;

        eProvider.value.id = user.id;
        eProvider.value.memId =    eProvider.value.memId == null ? 'a' :  eProvider.value.memId;
        eProvider.value.memName =    eProvider.value.memId == null ? 'a' :  eProvider.value.memName;
        eProvider.value.availabilityRange =    5;
        final _eProvider = await _eProviderRepository.create(eProvider.value);

        await Get.offAllNamed(Routes.ROOT);
        // await Get.toNamed(Routes.E_PROVIDER_AVAILABILITY_FORM, arguments: {'eProvider': _eProvider});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateEProviderForm() async {
    Get.focusScope.unfocus();
    if (eProviderForm.currentState.validate()) {
      try {
        eProviderForm.currentState.save();
        User user = Get.find<AuthService>().user.value;
        eProvider.value.id = user.id;
        eProvider.value.memId =    eProvider.value.memId == null ? 'a' :  eProvider.value.memId;
        eProvider.value.memName =    eProvider.value.memId == null ? 'a' :  eProvider.value.memName;
        eProvider.value.availabilityRange =    5;
        final _eProvider = await _eProviderRepository.update(eProvider.value);
        await Get.offAllNamed(Routes.ROOT);
        // await Get.toNamed(Routes.E_PROVIDER_AVAILABILITY_FORM, arguments: {'eProvider': _eProvider});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> deleteEProvider() async {
    try {
      await _eProviderRepository.delete(eProvider.value);
      // Get.offNamedUntil(Routes.E_PROVIDERS, (route) => route.settings.name == Routes.E_PROVIDERS);
      Get.showSnackbar(Ui.SuccessSnackBar(message: eProvider.value.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
