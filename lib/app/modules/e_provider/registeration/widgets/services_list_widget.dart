import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services_empty_list_widget.dart';
import 'services_list_loader_widget.dart';

// class ServicesListWidget extends GetView<EProviderEServicesController> {
//   ServicesListWidget({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (Get.find<LaravelApiClient>().isLoading(tasks: [
//             'getEProviderEServices',
//             'getEProviderFeaturedEServices',
//             'getEProviderPopularEServices',
//             'getEProviderMostRatedEServices',
//             'getEProviderAvailableEServices',
//           ]) &&
//           controller.page == 1) {
//         return ServicesListLoaderWidget();
//       } else if (controller.eServices.isEmpty) {
//         return ServicesEmptyListWidget();
//       } else {
//         return ListView.builder(
//           padding: EdgeInsets.only(bottom: 10, top: 10),
//           primary: false,
//           shrinkWrap: true,
//           itemCount: controller.eServices.length + 1,
//           itemBuilder: ((_, index) {
//             if (index == controller.eServices.length) {
//               return Obx(() {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: new Center(
//                     child: new Opacity(
//                       opacity: controller.isLoading.value ? 1 : 0,
//                       child: new CircularProgressIndicator(),
//                     ),
//                   ),
//                 );
//               });
//             } else {
//               var _service = controller.eServices.elementAt(index);
//               return ServicesListItemWidget(service: _service);
//             }
//           }),
//         );
//       }
//     });
//   }
// }
