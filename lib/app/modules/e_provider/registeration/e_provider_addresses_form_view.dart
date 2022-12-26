import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/e_provider/registeration/widgets/horizontal_stepper_widget.dart';
import 'package:home_services/app/modules/e_provider/registeration/widgets/step_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/confirm_dialog.dart';
import '../controllers/e_provider_addresses_form_controller.dart';

class EProviderAddressesFormView extends GetView<EProviderAddressesFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Provider Addresses".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () async {
              Get.back();
              // controller.isCreateForm()
              //     ? await Get.offAndToNamed(Routes.E_PROVIDERS)
              //     : await Get.offAndToNamed(Routes.E_PROVIDER, arguments: {'eProvider': controller.eProvider.value, 'heroTag': 'e_provider_addresses_form_back'});
              //
              },
          ),
          elevation: 0,
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
          onPressed: () => {
            Get.toNamed(Routes.E_PROVIDER_ADDRESS_PICKER, arguments: {'address': new Address()})
          },
          backgroundColor: Get.theme.colorScheme.secondary,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  return MaterialButton(
                    onPressed: controller.eProvider.value.addresses.isEmpty
                        ? null
                        : () async {
                            await Get.toNamed(Routes.E_PROVIDER_FORM, arguments: {'eProvider': controller.eProvider.value});
                          },
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledElevation: 0,
                    disabledColor: Get.theme.focusColor,
                    color: Get.theme.colorScheme.secondary,
                    child: Text("Save & Next".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                    elevation: 0,
                  );
                }),
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          primary: true,
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 60),
          children: [
            HorizontalStepperWidget(
              controller: new ScrollController(initialScrollOffset: 0),
              steps: [
                StepWidget(
                  title: Text(
                    "Addresses".tr,
                  ),
                  index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
                ),
                StepWidget(
                  title: Text(
                    "Provider Details".tr,
                  ),
                  color: Get.theme.focusColor,
                  index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
                ),
                StepWidget(
                  title: Text(
                    "Availability".tr,
                  ),
                  color: Get.theme.focusColor,
                  index: Text("3", style: TextStyle(color: Get.theme.primaryColor)),
                ),
              ],
            ),
            Text("Addresses details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
            Text("Select from your addresses".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
            Obx(() {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: Ui.getBoxDecoration(),
                child: (controller.addresses.isEmpty)
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.15),
                        highlightColor: Colors.grey[200].withOpacity(0.1),
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: MapsUtil.getStaticMaps(controller.eProvider.value.addresses.map((e) => e.getLatLng()).toList()),
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(top: 20, start: 20, end: 5),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                            ),
                            child: Column(
                              children: List.generate(controller.addresses.length, (index) {
                                var _address = controller.addresses.elementAt(index);
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          visualDensity: VisualDensity.compact,
                                          checkColor: Get.theme.colorScheme.secondary,
                                          fillColor: MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.selected)) {
                                              return Get.theme.colorScheme.secondary.withOpacity(0.2);
                                            } else {
                                              return Get.theme.focusColor.withOpacity(0.2);
                                            }
                                          }),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          value: controller.eProvider.value?.addresses?.contains(_address) ?? false,
                                          onChanged: (value)  {
                                            controller.toggleAddress(value, _address);
                                          },
                                        ),
                                      );
                                    }),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(_address.getDescription, style: Get.textTheme.subtitle2),
                                          SizedBox(height: 5),
                                          Text(_address.address, style: Get.textTheme.caption),
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () => {
                                        Get.toNamed(Routes.E_PROVIDER_ADDRESS_PICKER, arguments: {'address': _address})
                                      },
                                      height: 44,
                                      minWidth: 44,
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: Get.theme.colorScheme.secondary,
                                      ),
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ConfirmDialog(
                                                title: "Delete Address".tr,
                                                content: "Are you sure you want to delete this address?".tr,
                                                submitText: "Submit".tr,
                                                cancelText: "Cancel".tr);
                                          },
                                        );
                                        if (confirm && _address.hasData) {
                                          await controller.deleteAddress(_address);
                                        }
                                      },
                                      height: 44,
                                      minWidth: 44,
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        Icons.delete_outlined,
                                        color: Colors.redAccent,
                                      ),
                                      elevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                    ),
                                  ],
                                ).marginOnly(bottom: 10);
                              }),
                            ),
                          ),
                        ],
                      ),
              );
            }),
          ],
        ));
  }
}
