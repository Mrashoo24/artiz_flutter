import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/availability_hour_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../repositories/e_provider_repository.dart';

// class EProviderAvailabilityFormController extends GetxController {
//   final days = <String>[].obs;
//   final eProvider = EProvider().obs;
//   final availabilityHour = AvailabilityHour().obs;
//   GlobalKey<FormState> eProviderAvailabilityForm = new GlobalKey<FormState>();
//   ScrollController scrollController = ScrollController();
//   EProviderRepository _eProviderRepository;
//
//   EProviderAvailabilityFormController() {
//     _eProviderRepository = new EProviderRepository();
//   }
//
//   @override
//   void onInit() async {
//     var arguments = Get.arguments as Map<String, dynamic>;
//     if (arguments != null) {
//       eProvider.value = arguments['eProvider'] as EProvider;
//     }
//     super.onInit();
//   }
//
//   @override
//   void onReady() async {
//     await refreshEProvider();
//     super.onReady();
//   }
//
//   @override
//   void onClose() {
//     days.value = [];
//     availabilityHour.value = AvailabilityHour();
//     eProvider.value = EProvider();
//     super.onClose();
//   }
//
//   Future refreshEProvider({bool showMessage = false}) async {
//     await getEProvider();
//     getDays();
//     if (showMessage) {
//       Get.showSnackbar(Ui.SuccessSnackBar(message: eProvider.value.name + " " + "page refreshed successfully".tr));
//     }
//   }
//
//   Future getEProvider() async {
//     if (eProvider.value.hasData) {
//       try {
//         eProvider.value = await _eProviderRepository.get(eProvider.value.id);
//         availabilityHour.value.eProvider = eProvider.value;
//       } catch (e) {
//         Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//       }
//     }
//   }
//
//   getDays() {
//     days.assignAll([
//       "monday",
//       "tuesday",
//       "wednesday",
//       "thursday",
//       "friday",
//       "saturday",
//       "sunday",
//     ]);
//   }
//
//   void createAvailabilityHour() async {
//     Get.focusScope.unfocus();
//     if (eProviderAvailabilityForm.currentState.validate()) {
//       try {
//         eProviderAvailabilityForm.currentState.save();
//         scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
//         final _availabilityHour = await _eProviderRepository.createAvailabilityHour(this.availabilityHour.value);
//         eProvider.update((val) {
//           val.availabilityHours.insert(0, _availabilityHour);
//           return val;
//         });
//         availabilityHour.value = AvailabilityHour(eProvider: availabilityHour.value.eProvider);
//         eProviderAvailabilityForm.currentState.reset();
//       } catch (e) {
//         Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//       } finally {}
//     } else {
//       Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
//     }
//   }
//
// /*
//   * Check if the form for create new service or edit
//   * */
//   bool isCreateForm() {
//     return !eProvider.value.hasData;
//   }
//
//   Future<void> deleteAvailabilityHour(AvailabilityHour availabilityHour) async {
//     try {
//       availabilityHour = await _eProviderRepository.deleteAvailabilityHour(availabilityHour);
//       eProvider.update((val) {
//         val.availabilityHours.removeWhere((element) => element.id == availabilityHour.id);
//         return val;
//       });
//     } catch (e) {
//       Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//     }
//   }
//
//   List<SelectDialogItem<String>> getSelectDaysItems() {
//     return days.map((element) {
//       return SelectDialogItem(element, element.tr);
//     }).toList();
//   }
// }
