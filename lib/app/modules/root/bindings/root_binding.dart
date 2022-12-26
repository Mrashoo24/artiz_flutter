import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../bookings/controllers/booking_controller.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../e_provider/controllers/e_services_controller.dart';
import '../../e_service/bindings/e_service_binding.dart';
import '../../e_service/controllers/e_service_controller.dart';
import '../../e_service/controllers/e_service_form_controller.dart';
import '../../e_service/controllers/options_form_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    Get.put(HomeController(), permanent: true);
    // Get.put(EServiceFormController(), permanent: true);
    // Get.put(EServiceController(), permanent: true);
    Get.lazyPut<EServicesController>(
          () => EServicesController(),
    );
    Get.lazyPut<EServiceController>(
          () => EServiceController(),
    );
    Get.lazyPut<EServiceFormController>(
          () => EServiceFormController(),
    );
    Get.lazyPut<OptionsFormController>(
          () => OptionsFormController(),
    );
    Get.lazyPut<SearchController>(
          () => SearchController(),
    );
    Get.put(BookingsController(), permanent: true);

    Get.lazyPut<BookingController>(
      () => BookingController(),
    );
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
    );
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
  }
}
