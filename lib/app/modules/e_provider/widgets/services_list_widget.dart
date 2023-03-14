import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/routes/app_routes.dart';
import 'package:home_services/common/ui.dart';

import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../e_service/controllers/e_service_form_controller.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../controllers/e_services_controller.dart';
import 'services_empty_list_widget.dart';
import 'services_list_item_widget.dart';
import 'services_list_loader_widget.dart';

class ServicesListWidget extends StatefulWidget{
  ServicesListWidget({Key key}) : super(key: key);

  @override
  State<ServicesListWidget> createState() => _ServicesListWidgetState();
}

class _ServicesListWidgetState extends State<ServicesListWidget> {
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
      body: Builder(builder:(context) {
        var controller =Get.find<EServicesController>();
        return RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshEServices(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      border: Border.all(
                        color: Get.theme.focusColor.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 12, left: 0),
                        child: Icon(Icons.search, color: Get.theme.colorScheme.secondary),
                      ),
                      Expanded(
                        child: Material(
                          color: Get.theme.primaryColor,
                          child: TextField(
                            controller: controller.searchString,
                            style: Get.textTheme.bodyText2,
                            onSubmitted: (value) {
                              print('check = $value');
                              controller.searchEServices();
                              setState(() {

                              });
                            },
                            onChanged: (value) {
                              print('check = $value');
                              controller.searchEServices();
                              setState(() {

                              });
                            },
                            // autofocus: true,
                            cursorColor: Get.theme.focusColor,
                            decoration: Ui.getInputDecoration(hintText: "Search for home service...".tr),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                GetBuilder<EServiceFormController>(
                    init: Get.put(EServiceFormController()),
                    builder: (formcontroller) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                            decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                                ],
                                border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Categories".tr,
                                        style: Get.textTheme.bodyText1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        final selectedValues = await showDialog<Set<Category>>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MultiSelectDialog<Category>(
                                              title: "Select Categories".tr,
                                              submitText: "Submit".tr,
                                              cancelText: "Cancel".tr,
                                              items: formcontroller.getMultiSelectCategoriesItems(),
                                              initialSelectedValues: formcontroller.categories
                                                  .where(
                                                    (category) => formcontroller.eService.value.categories?.where((element) => element.id == category.id)?.isNotEmpty ?? false,
                                              )
                                                  .toSet(),
                                            );
                                          },
                                        );
                                        formcontroller.eService.update((val) {
                                          val.categories = selectedValues?.toList();
                                        });
                                      },
                                      shape: StadiumBorder(),
                                      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                                      child: Text("Select".tr, style: Get.textTheme.subtitle1),
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  if (formcontroller.eService.value?.categories?.isEmpty ?? true) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Select categories".tr,
                                        style: Get.textTheme.caption,
                                      ),
                                    );
                                  } else {
                                    return buildCategories(formcontroller.eService.value);
                                  }
                                })
                              ],
                            ),
                          ),
                          GetX<EServicesController>(
                            // init: Get.put(EServicesController()),

                              builder: (controller) {
                                var _service = controller.searchString.text != '' ?
                                controller.eServicesSearch:
                                controller.eServices;

                                // _service.where((element) => element.categories.contains(formcontroller.categories));



                                
    // for (var i = 0; i < _service.length; i++)
    // {
    // if (formcontroller.categories.contains(_service[i]))
    // {
    //
    //
    //
    // }
    // }


                                var oldServiceLength = controller.searchString.text != '' ? _service.length :_service.length + 1;





                                return ListView.builder(
                                  padding: EdgeInsets.only(bottom: 10, top: 10),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: oldServiceLength,
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
                                      EService finalService =
                                      _service.elementAt(index) ;

                                     var check =  formcontroller.categories.any(
                                             (element) => finalService.categories.contains(element) || finalService.subCategories.contains(element)
                                     );


                                      print('serviceCheck = $check ');
                                      print('serviceCheck = $check ${finalService.subCategories.length}');

                                      return ServicesListItemWidget(service: finalService);
                                    }
                                  }),
                                );
                              }
                          ),
                        ],
                      );
                    }
                ),

              ],
            ),
          ),
        );
      })
    );


  }

  Widget buildCategories(EService _eService) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_eService.categories?.length ?? 0, (index) {
          var _category = _eService.categories.elementAt(index);
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(_category.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: _category.color))),
            decoration: BoxDecoration(
                color: _category.color.withOpacity(0.2),
                border: Border.all(
                  color: _category.color.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          );
        }) +
            List.generate(_eService.subCategories?.length ?? 0, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_eService.subCategories.elementAt(index).name, style: Get.textTheme.caption),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }
}
