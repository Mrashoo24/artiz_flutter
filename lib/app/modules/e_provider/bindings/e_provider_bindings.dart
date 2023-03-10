import 'package:get/get.dart';

import '../../messages/controllers/messages_controller.dart';
import '../controllers/e_provider_addresses_form_controller.dart';
import '../controllers/e_provider_controller.dart';
import '../controllers/e_provider_form_controller.dart';
import '../controllers/e_services_controller.dart';

class EProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EProviderAddressesFormController>(
          () => EProviderAddressesFormController(),
    );
    Get.lazyPut<EProviderFormController>(
          () => EProviderFormController(),
    );
    Get.lazyPut<EProviderController>(
      () => EProviderController(),
    );
    Get.lazyPut<EServicesController>(
      () => EServicesController(),
    );
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
    );
  }
}
