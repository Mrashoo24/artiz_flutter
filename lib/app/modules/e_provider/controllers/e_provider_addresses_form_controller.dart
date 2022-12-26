import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../global_widgets/multi_select_dialog.dart';

class EProviderAddressesFormController extends GetxController {
  final addresses = <Address>[].obs;
  final eProvider = EProvider().obs;
  GlobalKey<FormState> eProviderAddressesForm = new GlobalKey<FormState>();
  EProviderRepository _eProviderRepository;

  EProviderAddressesFormController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      eProvider.value = arguments['eProvider'] as EProvider;
    }
    eProvider.value.addresses = eProvider.value.addresses ?? <Address>[];
    addresses.assignAll(eProvider.value.addresses);
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEProvider();
    super.onReady();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    await getEProvider();
    await getAddresses();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: eProvider.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEProvider() async {
    if (eProvider.value.hasData) {
      try {
        eProvider.value = await _eProviderRepository.get(eProvider.value.id);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  Future getAddresses() async {
    try {
      addresses.assignAll(await _eProviderRepository.getAddresses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> createAddress(Address address) async {
    try {
      address = await _eProviderRepository.createAddress(address);
      addresses.insert(0, address);
      toggleAddress(true, address);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> updateAddress(Address address) async {
    try {
      address = await _eProviderRepository.updateAddress(address);
      addresses[addresses.indexWhere((element) => element.id == address.id)] = address;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> deleteAddress(Address address) async {
    try {
      address = await _eProviderRepository.deleteAddress(address);
      addresses.removeWhere((element) => element.id == address.id);
      toggleAddress(false, address);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void toggleAddress(bool value, Address address) {
    eProvider.update((val) {
      if (value) {
        val.addresses.add(address);
      } else {
        val.addresses.removeWhere((element) => element == address);
      }
    });
  }

  List<MultiSelectDialogItem<Address>> getMultiSelectAddressesItems() {
    return addresses.map((element) {
      return MultiSelectDialogItem(element, element.getDescription);
    }).toList();
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !eProvider.value.hasData;
  }
}
