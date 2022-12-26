import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/routes/app_routes.dart';

import '../../../providers/laravel_provider.dart';
import '../controllers/e_services_controller.dart';
import 'services_empty_list_widget.dart';
import 'services_list_item_widget.dart';
import 'services_list_loader_widget.dart';

class ServicesListWidget extends GetView<EServicesController> {
  ServicesListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buy/Sell')),
      // floatingActionButton: FloatingActionButton(
      //
      //     onPressed: (){
      //
      //       Get.toNamed(Routes.E_SERVICE_FORM);
      //
      // },
      //   child: Icon(Icons.add),
      //
      // ),
      body: Obx(() {
        if (Get.find<LaravelApiClient>().isLoading(tasks: [
              'getEProviderEServices',
              'getEProviderPopularEServices',
              'getEProviderMostRatedEServices',
              'getEProviderAvailableEServices',
              'getEProviderFeaturedEServices'
            ]) &&
            controller.page == 1) {
          return ServicesListLoaderWidget();
        } else if (controller.eServices.isEmpty) {
          return ServicesEmptyListWidget();
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshEServices(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            },
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              primary: false,
              shrinkWrap: true,
              itemCount: controller.eServices.length + 1,
              itemBuilder: ((_, index) {
                if (index == controller.eServices.length) {
                  return Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Center(
                        child: new Opacity(
                          opacity: controller.isLoading.value ? 1 : 0,
                          child: new CircularProgressIndicator(),
                        ),
                      ),
                    );
                  });
                } else {
                  var _service = controller.eServices.elementAt(index);
                  return ServicesListItemWidget(service: _service);
                }
              }),
            ),
          );
        }
      }),
    );
  }
}