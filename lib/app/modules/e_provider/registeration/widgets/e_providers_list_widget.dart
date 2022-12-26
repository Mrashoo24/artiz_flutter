import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'e_providers_empty_list_widget.dart';
import 'e_providers_list_item_widget.dart';

// class EProvidersListWidget extends GetView<EProvidersController> {
//   EProvidersListWidget({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (Get.find<LaravelApiClient>().isLoading(tasks: ['getEProviders', 'getAcceptedEProviders', 'getFeaturedEProviders', 'getPendingEProviders'])) {
//         return CircularLoadingWidget(height: 300);
//       } else {
//         if (controller.eProviders.isEmpty && controller.selected.value == EProviderFilter.ALL) {
//           return EProvidersEmptyListWidget();
//         }
//         return ListView.separated(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           primary: false,
//           shrinkWrap: true,
//           itemCount: controller.eProviders.length + 1,
//           itemBuilder: ((_, index) {
//             if (index == controller.eProviders.length) {
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
//               var _eProvider = controller.eProviders.elementAt(index);
//               return EProvidersListItemWidget(eProvider: _eProvider);
//             }
//           }),
//           separatorBuilder: (BuildContext context, int index) {
//             return SizedBox(height: 20);
//           },
//         );
//       }
//     });
//   }
// }
