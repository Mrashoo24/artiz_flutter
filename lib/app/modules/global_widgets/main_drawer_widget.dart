/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/address_model.dart';
import '../../models/e_provider_model.dart';
import '../../repositories/e_provider_repository.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/settings_service.dart';
import '../auth/controllers/auth_controller.dart';
import '../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../e_provider/bindings/e_provider_bindings.dart';
import '../e_provider/controllers/e_provider_addresses_form_controller.dart';
import '../e_provider/controllers/e_provider_form_controller.dart';
import '../e_service/controllers/e_service_form_controller.dart';
import '../home/controllers/home_controller.dart';
import '../root/bindings/root_binding.dart';
import '../root/controllers/root_controller.dart' show RootController;
import '../root/views/root_view.dart';
import 'drawer_link_widget.dart';
import 'package:http/http.dart' as http;

class MainDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<http.Response>(
          future: http.get(Uri.parse('http://artiz.consciser.in/mrzulfapi/check_vendor.php?user_id=${Get.find<AuthService>().user.value.id}')),
        builder: (context, snapshot) {

          if(!snapshot.hasData){
            return SizedBox();
          }

          print('vendorbool ${snapshot.requireData.body}');


          return ListView(
            children: [
              Obx(() {
                if (!Get.find<AuthService>().isAuth) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome".tr, style: Get.textTheme.headline5.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
                          SizedBox(height: 5),
                          Text("Login account or create new one for free".tr, style: Get.textTheme.bodyText1),
                          SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  Get.toNamed(Routes.LOGIN);
                                },
                                color: Get.theme.colorScheme.secondary,
                                height: 40,
                                elevation: 0,
                                child: Wrap(
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 9,
                                  children: [
                                    Icon(Icons.exit_to_app_outlined, color: Get.theme.primaryColor, size: 24),
                                    Text(
                                      "Login".tr,
                                      style: Get.textTheme.subtitle1.merge(TextStyle(color: Get.theme.primaryColor)),
                                    ),
                                  ],
                                ),
                                shape: StadiumBorder(),
                              ),
                              MaterialButton(
                                color: Get.theme.focusColor.withOpacity(0.2),
                                height: 40,
                                elevation: 0,
                                onPressed: () {
                                  Get.toNamed(Routes.REGISTER);
                                },
                                child: Wrap(
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 9,
                                  children: [
                                    Icon(Icons.person_add_outlined, color: Get.theme.hintColor, size: 24),
                                    Text(
                                      "Register".tr,
                                      style: Get.textTheme.subtitle1.merge(TextStyle(color: Get.theme.hintColor)),
                                    ),
                                  ],
                                ),
                                shape: StadiumBorder(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      await Get.find<RootController>().changePage(3);
                    },
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                      ),
                      accountName: Text(
                        Get.find<AuthService>().user.value.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      accountEmail: Text(
                        Get.find<AuthService>().user.value.email,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      currentAccountPicture: Stack(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(80)),
                              child: CachedNetworkImage(
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: Get.find<AuthService>().user.value.avatar.thumb,
                                placeholder: (context, url) => Image.asset(
                                  'assets/icon/photo.jpeg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 80,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/icon/photo.jpeg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 80,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Get.find<AuthService>().user.value.verifiedPhone ?? false ? Icon(Icons.check_circle, color: Get.theme.colorScheme.secondary, size: 24) : SizedBox(),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }),
              SizedBox(height: 20),


           FutureBuilder<List<EProvider>>(
             future: EProviderRepository().getAll(),
             builder: (context,future) {


               if(!future.hasData) {
                 return SizedBox();
               }

               return DrawerLinkWidget(

          icon: Icons.account_balance,
          text: snapshot.requireData.body == "1" ? "Profile" : "Add Services",
          onTap: (e) async {
                //
                if(snapshot.requireData.body == "1"){
                 String userid  =   await    Get.put<AuthController>(AuthController()).currentUser.value.id;

                  List<EProvider> eproviders =   await    future.requireData;

                  print(future.requireData.length);

                 var eprovider= future.requireData.firstWhere((element)
                 {
                   print(element.userid == userid );
                   print(element.userid + '  dd' +userid );

                   return  element.userid == userid;} );

                 print('eprovidercheck = ${eprovider.toJson()}');

                 Get.put<EProviderFormController>(EProviderFormController()).eProvider.value = eprovider;

                 Get.put<EProviderAddressesFormController>(EProviderAddressesFormController()).eProvider.value = eprovider;
                  Get.back();
                  await Get.toNamed(Routes.E_PROVIDER_ADDRESSES_FORM,arguments: {'eProvider',eprovider});

                }else{




                  Get.back();
                  await Get.toNamed(Routes.E_PROVIDER_ADDRESSES_FORM);
                }


          // await Get.to(EProviderAddressesFormView(),binding: EProviderBinding());
          // vendorAuthController.AuthController().login();

          },
          );
             }
           ),
    DrawerLinkWidget(
    icon: Icons.production_quantity_limits,
    text: "Add Product (Buy/Sell)",
    onTap: (e) async {
      
      
    
    Get.back();
    Get.toNamed(Routes.E_SERVICE_FORM);

    // await Get.to(EProviderAddressesFormView(),binding: EProviderBinding());
    // vendorAuthController.AuthController().login();

    },
    ),

              // DrawerLinkWidget(
              //   icon: Icons.home_outlined,
              //   text: "Home",
              //   onTap: (e) async {
              //     Get.back();
              //
              //     Get.offAll(RootView(currentpageindex: 0,),binding: RootBinding());
              //     // await Get.find<RootController>().changePage(0);
              //   },
              // ),
              // DrawerLinkWidget(
              //   icon: Icons.folder_special_outlined,
              //   text: "Categories",
              //   onTap: (e) {
              //     Get.offAndToNamed(Routes.CATEGORIES);
              //   },
              // ),
              // DrawerLinkWidget(
              //   icon: Icons.assignment_outlined,
              //   text: "Bookings",
              //   onTap: (e) async {
              //     Get.back();
              //     await Get.find<RootController>().changePage(1);
              //   },
              // ),
              // DrawerLinkWidget(
              //   icon: Icons.notifications_none_outlined,
              //   text: "Notifications",
              //   onTap: (e) {
              //     Get.offAndToNamed(Routes.NOTIFICATIONS);
              //   },
              // ),
              // DrawerLinkWidget(
              //   icon: Icons.favorite_outline,
              //   text: "Favorites",
              //   onTap: (e) async {
              //     await Get.offAndToNamed(Routes.FAVORITES);
              //   },
              // ),
              DrawerLinkWidget(
                icon: Icons.chat_outlined,
                text: "Messages",
                onTap: (e) async {
                  Get.back();
                  if (!Get.find<AuthService>().isAuth) {
                    await Get.toNamed(Routes.LOGIN);
                  }else{
                  Get.offAll(RootView(currentpageindex: 5,),binding: RootBinding());}
                },
              ),
              ListTile(
                dense: true,
                title: Text(
                  "Application preferences".tr,
                  style: Get.textTheme.caption,
                ),
                trailing: Icon(
                  Icons.remove,
                  color: Get.theme.focusColor.withOpacity(0.3),
                ),
              ),
              // DrawerLinkWidget(
              //   icon: Icons.account_balance_wallet_outlined,
              //   text: "Wallets",
              //   onTap: (e) async {
              //     await Get.offAndToNamed(Routes.WALLETS);
              //   },
              // ),
              // DrawerLinkWidget(
              //   icon: Icons.person_outline,
              //   text: "Account",
              //   onTap: (e) async {
              //     Get.back();
              //     if (!Get.find<AuthService>().isAuth) {
              //     await Get.toNamed(Routes.LOGIN);
              //     }else{
              //              Get.offAll(RootView(currentpageindex: 6,),binding: RootBinding());}
              //
              //   },
              // ),
              DrawerLinkWidget(
                icon: Icons.settings_outlined,
                text: "Settings",
                onTap: (e) async {
                  await Get.offAndToNamed(Routes.SETTINGS);
                },
              ),
              // DrawerLinkWidget(
              //   icon: Icons.translate_outlined,
              //   text: "Languages",
              //   onTap: (e) async {
              //     await Get.offAndToNamed(Routes.SETTINGS_LANGUAGE);
              //   },
              // ),
              DrawerLinkWidget(
                icon: Icons.brightness_6_outlined,
                text: Get.isDarkMode ? "Light Theme" : "Dark Theme",
                onTap: (e) async {
                  await Get.offAndToNamed(Routes.SETTINGS_THEME_MODE);
                },
              ),
              // ListTile(
              //   dense: true,
              //   title: Text(
              //     "Help & Privacy",
              //     style: Get.textTheme.caption,
              //   ),
              //   trailing: Icon(
              //     Icons.remove,
              //     color: Get.theme.focusColor.withOpacity(0.3),
              //   ),
              // ),
              // DrawerLinkWidget(
              //   icon: Icons.help_outline,
              //   text: "Help & FAQ",
              //   onTap: (e) async {
              //     await Get.offAndToNamed(Routes.HELP);
              //   },
              // ),
              CustomPageDrawerLinkWidget(),
              Obx(() {
                if (Get.find<AuthService>().isAuth) {
                  return DrawerLinkWidget(
                    icon: Icons.logout,
                    text: "Logout",
                    onTap: (e) async {
                      await Get.find<AuthService>().removeCurrentUser();
                      Get.back();
                      // await Get.find<RootController>().changePage(0);
                      Get.offAll(RootView(currentpageindex: 0,),binding: RootBinding());

                    },
                  );
                } else {
                  return SizedBox(height: 0);
                }
              }),
              if (Get.find<SettingsService>().setting.value.enableVersion)
                ListTile(
                  dense: true,
                  title: Text(
                    "Version".tr + " " + Get.find<SettingsService>().setting.value.appVersion,
                    style: Get.textTheme.caption,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Get.theme.focusColor.withOpacity(0.3),
                  ),
                )
            ],
          );
        }
      ),
    );
  }
}
