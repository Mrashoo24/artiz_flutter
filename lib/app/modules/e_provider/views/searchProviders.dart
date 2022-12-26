import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../routes/app_routes.dart';
import '../../category/controllers/categories_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/e_provider_controller.dart';
// import '../controllers/home_controller.dart';

class SearchProviders extends GetWidget<HomeController> {
  bool vertical = false;
  final  List<EProvider> listofeproviders;
  final String query;

  SearchProviders(this.vertical, this.listofeproviders, this.query);


  @override
  Widget build(BuildContext context) {


    return GetBuilder<SearchController>(
      init:Get.put(SearchController()),
      builder: (searchControoller) {
        var eproviders = listofeproviders.where((element) {
          print(element.name + 'runnigSearch ${searchControoller.textEditingController.text} ${searchControoller.selectedCategories}');

          print(element.name + 'runnigSearch2 ${element.name.contains(searchControoller.textEditingController.text)}');
// print(
          //     'getCategoryatProvider = ${element.categoryGet} ${controller.category.value.id} ${element.categoryGet == controller.category.value.id}');
          if(searchControoller.selectedCategories.isEmpty){

            return element.name.contains(searchControoller.textEditingController.text) ;
          }else{

            return element.name.contains(searchControoller.textEditingController.text) && searchControoller.selectedCategories.contains(element.categoryGet)
            ;
          }

        }).toList();

//         eproviders = searchControoller.selectedCategories.isEmpty ? listofeproviders   :listofeproviders.where((element) {
//           print(element.name + 'runnigSearch ${searchControoller.textEditingController.text} ${searchControoller.selectedCategories}');
//
//           print(element.name + 'runnigSearch2 ${element.name.contains(searchControoller.textEditingController.text)}');
// // print(
//           //     'getCategoryatProvider = ${element.categoryGet} ${controller.category.value.id} ${element.categoryGet == controller.category.value.id}');
//           return element.name.contains(searchControoller.textEditingController.text) &&
//                searchControoller.selectedCategories.contains(element.categoryGet)
//
//           ;
//         }).toList();



        return Container(
            height: vertical? null :360,
            color: Get.theme.primaryColor,
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                primary: false,
                shrinkWrap: vertical,
                scrollDirection:vertical?Axis.vertical :Axis.horizontal,
                itemCount: eproviders.length,
                itemBuilder: (_, index) {

                  var _service = eproviders.elementAt(index);




                  return _service == null ? SizedBox() : GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.E_PROVIDER, arguments: {'eProvider': _service, 'heroTag': 'e_service_details'});

                      // Get.toNamed(Routes.E_SERVICE, arguments: {'eService': _service, 'heroTag': 'recommended_carousel'});
                    },
                    child: Container(
                      width: 180,
                      margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                        ],
                      ),
                      child: Column(
                        //alignment: AlignmentDirectional.topStart,
                        children: [
                          Hero(
                            tag: 'recommended_carousel ${_service.id}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              child: CachedNetworkImage(
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: _service.firstImageUrl,
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 100,
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error_outline),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            height: 130,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  _service.name ?? '',
                                  maxLines: 2,
                                  style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                                ),
                                Wrap(
                                  children: Ui.getStarsList(_service.rate ?? 0),
                                ),
                                SizedBox(height: 10),
                                Wrap(
                                  spacing: 5,
                                  alignment: WrapAlignment.spaceBetween,
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: [
                                    Text(
                                      "Start from".tr,
                                      style: Get.textTheme.caption,
                                    ),
                                    // Column(
                                    //   crossAxisAlignment: CrossAxisAlignment.end,
                                    //   children: [
                                    //     if (_service.getOldPrice > 0)
                                    //       Ui.getPrice(
                                    //         _service.getOldPrice,
                                    //         style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                                    //         unit: _service.getUnit,
                                    //       ),
                                    //     Ui.getPrice(
                                    //       _service.getPrice,
                                    //       style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                                    //       unit: _service.getUnit,
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
          // Obx(() {
          //
          //
          //   // if(controller.category.value != null){
          //   //   eproviders = controller.subcategory.value == null
          //   //       ? controller.eProviderList.where((element) {
          //   //     print(
          //   //         'getCategoryatProvider = ${element.categoryGet} ${controller.category.value.id} ${element.categoryGet == controller.category.value.id}');
          //   //     return element.categoryGet == controller.category.value.id;
          //   //   }).toList()
          //   //       : controller.eProviderList.where((element) {
          //   //     print(
          //   //         'getCategoryatProvider = ${element.categoryGet} ${controller.category.value.id} ${element.categoryGet == controller.category.value.id}');
          //   //     return element.categoryGet == controller.category.value.id &&
          //   //         element.subcategoryGet
          //   //             .contains(controller.subcategory.value.id);
          //   //   }).toList();
          //   // }
          //
          //
          //   // if(!vertical){
          //   //   eproviders = controller.eProviderList.where((element) {
          //   //     // print(
          //   //     //     'getCategoryatProvider = ${element.categoryGet} ${controller.category.value.id} ${element.categoryGet == controller.category.value.id}');
          //   //     return element.featured;
          //   //   }).toList();
          //   // }
          //
          //   return
          // }),
        );
      }
    );
  }
}


// class EproviderCarouselWidgetVertical extends GetWidget<CategoryController> {
//   bool vertical = false;
//
//   EproviderCarouselWidgetVertical(this.vertical);
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Container(
//       height: vertical? null :360,
//       color: Get.theme.primaryColor,
//       child: Obx(() {
//         return  ListView.builder(
//             padding: EdgeInsets.only(bottom: 10),
//             primary: false,
//             shrinkWrap: vertical,
//             scrollDirection:vertical?Axis.vertical :Axis.horizontal,
//             itemCount: controller.eProviderList.length,
//             itemBuilder: (_, index) {
//               var _service = controller.eProviderList.elementAt(index);
//               return _service == null ? SizedBox() : GestureDetector(
//                 onTap: () {
//                   Get.toNamed(Routes.E_PROVIDER, arguments: {'eProvider': _service, 'heroTag': 'e_service_details'});
//
//                   // Get.toNamed(Routes.E_SERVICE, arguments: {'eService': _service, 'heroTag': 'recommended_carousel'});
//                 },
//                 child: Container(
//                   width: 180,
//                   margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
//                   // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     boxShadow: [
//                       BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
//                     ],
//                   ),
//                   child: Column(
//                     //alignment: AlignmentDirectional.topStart,
//                     children: [
//                       Hero(
//                         tag: 'recommended_carousel ${_service.id}',
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//                           child: CachedNetworkImage(
//                             height: 180,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             imageUrl: _service.firstImageUrl,
//                             placeholder: (context, url) => Image.asset(
//                               'assets/img/loading.gif',
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               height: 100,
//                             ),
//                             errorWidget: (context, url, error) => Icon(Icons.error_outline),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                         height: 130,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Get.theme.primaryColor,
//                           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Text(
//                               _service.name ?? '',
//                               maxLines: 2,
//                               style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
//                             ),
//                             Wrap(
//                               children: Ui.getStarsList(_service.rate ?? 0),
//                             ),
//                             SizedBox(height: 10),
//                             Wrap(
//                               spacing: 5,
//                               alignment: WrapAlignment.spaceBetween,
//                               direction: Axis.horizontal,
//                               crossAxisAlignment: WrapCrossAlignment.end,
//                               children: [
//                                 Text(
//                                   "Start from".tr,
//                                   style: Get.textTheme.caption,
//                                 ),
//                                 // Column(
//                                 //   crossAxisAlignment: CrossAxisAlignment.end,
//                                 //   children: [
//                                 //     if (_service.getOldPrice > 0)
//                                 //       Ui.getPrice(
//                                 //         _service.getOldPrice,
//                                 //         style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
//                                 //         unit: _service.getUnit,
//                                 //       ),
//                                 //     Ui.getPrice(
//                                 //       _service.getPrice,
//                                 //       style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
//                                 //       unit: _service.getUnit,
//                                 //     ),
//                                 //   ],
//                                 // ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             });
//       }),
//     );
//   }
// }