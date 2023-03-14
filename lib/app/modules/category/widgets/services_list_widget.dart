import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../e_provider/widgets/services_empty_list_widget.dart';
import '../../e_provider/widgets/services_list_loader_widget.dart';
import '../../e_service/controllers/e_service_form_controller.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../controllers/category_controller.dart';
import 'services_list_item_widget.dart';

class ServicesListWidget extends GetView<CategoryController> {
  ServicesListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<LaravelApiClient>()
              .isLoading(tasks: ['getAllEServicesWithPagination', 'getFeaturedEServices', 'getPopularEServices', 'getMostRatedEServices', 'getAvailableEServices']) &&
          controller.page == 1) {
        return ServicesListLoaderWidget();
      } else if (controller.eServices.isEmpty) {
        return ServicesEmptyListWidget();
      } else {
        return Column(
          children: [

            ListView.builder(
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
                  return ServicesListItemWidget(service: EService());
                    // ServicesListItemWidget(service: _service);
                }
              }),
            ),
          ],
        );
      }
    });
  }
}
