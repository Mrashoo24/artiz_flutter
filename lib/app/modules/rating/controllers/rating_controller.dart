import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/auth_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../e_provider/controllers/e_provider_controller.dart';
import '../../root/controllers/root_controller.dart';

class RatingController extends GetxController {
  final booking = EProvider().obs;
  final review = new Review(rate: '0').obs;
  BookingRepository _bookingRepository;

  RatingController() {
    _bookingRepository = new BookingRepository();
  }

  @override
  void onInit() {
    booking.value = Get.arguments as EProvider;
    // review.value.user = Get.find<AuthService>().user.value;
    // review.value.erprovider = booking.value;
    super.onInit();
  }

  Future addReview() async {
    try {
      if (double.parse(review.value.rate) < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this service by clicking on the stars".tr));
        return;
      }
      if (review.value.review == null || review.value.review.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this service".tr));
        return;
      }

      review.value.createdAt = DateTime.now().toLocal().toString();
      review.value.id = '1';


    http.Response respone =   await http.get(Uri.parse('https://artiz.consciser.in/mrzulfapi/addreview.php?review=${review.value.review}&rate=${review.value.rate}&user_id=${Get.put<AuthController>(AuthController()).currentUser.value.id}&e_service_id=${Get.find<EProviderController>().eProvider.value.id}'));

    print('responseReview = ${respone.body}');
      // await _bookingRepository.addReview(review.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Thank you! your review has been added".tr));
      Timer(Duration(seconds: 2), () {
        Get.find<RootController>().changePage(0);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
