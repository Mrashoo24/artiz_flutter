import 'package:get/get.dart';

import '../controllers/e_provider_addresses_form_controller.dart';
import '../controllers/e_provider_availability_form_controller.dart';
import '../controllers/e_provider_controller.dart';
import '../controllers/e_provider_form_controller.dart';

class EProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EProviderController>(
      () => EProviderController(),
    );
    Get.lazyPut<EProviderFormController>(
      () => EProviderFormController(),
    );
    Get.lazyPut<EProviderAddressesFormController>(
      () => EProviderAddressesFormController(),
    );
    // Get.lazyPut<EProviderAvailabilityFormController>(
    //   () => EProviderAvailabilityFormController(),
    // );
    // Get.lazyPut<EProviderEServicesController>(
    //   () => EProviderEServicesController(),
    // );
  }
}
