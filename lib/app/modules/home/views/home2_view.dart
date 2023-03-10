import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/slide_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../e_provider/views/e_provider_list.dart';
import '../../e_provider/views/featuredEProviders.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';
import 'package:http/http.dart' as http;

class Home2View extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> scafkey ;

  Home2View(this.scafkey);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: controller.refreshHome(),
        builder: (context, snapshot) {

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }


          return RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                await controller.refreshHome(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 300,
                    elevation: 0.5,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Get.find<SettingsService>().setting.value.appName.split(' ')[0].toLowerCase(),
                          style: TextStyle(color: Colors.white,fontFamily: 'Ebrima Regular'),
                        ),
                        Text(
                          Get.find<SettingsService>().setting.value.appName.split(' ')[1],
                          style: TextStyle(color: Colors.yellow.shade700,fontFamily: 'SecularOne-Regular',fontSize: 22,shadows: [Shadow(color: Colors.black,offset: Offset(1, 1),blurRadius: 0.1)]),
                        ),
                      ],
                    ),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: new Icon(Icons.sort, color: Colors.black87),
                      onPressed: () => {scafkey.currentState.openDrawer()},
                    ),
                    // actions: [NotificationsButtonWidget()],
                    bottom: HomeSearchBarWidget(),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: controller.slider.isEmpty
                              ? AlignmentDirectional.center
                              : Ui.getAlignmentDirectional(controller.slider.elementAt(controller.currentSlide.value).textPosition),
                          children: <Widget>[
                            CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 7),
                                height: 360,
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  controller.currentSlide.value = index;
                                },
                              ),
                              items: controller.slider.map((Slide slide) {
                                return SlideItemWidget(slide: slide);
                              }).toList(),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: controller.slider.map((Slide slide) {
                                  return Container(
                                    width: 20.0,
                                    height: 5.0,
                                    margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: controller.currentSlide.value == controller.slider.indexOf(slide) ? slide.indicatorColor : slide.indicatorColor.withOpacity(0.4)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 42),
                  ),
                  SliverToBoxAdapter(
                    child: Wrap(
                      children: [
                        AddressWidget(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Row(
                            children: [
                              Expanded(child: Text("Categories".tr, style: Get.textTheme.headline5)),
                              MaterialButton(
                                onPressed: () {
                                  Get.toNamed(Routes.CATEGORIES);
                                },
                                shape: StadiumBorder(),
                                color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                                child: Text("View All".tr, style: Get.textTheme.subtitle1),
                                elevation: 0,
                              ),
                            ],
                          ),
                        ),
                        CategoriesCarouselWidget(),
                        Container(
                          color: Get.theme.primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Row(
                            children: [
                              Expanded(child: Text("Recommended for you".tr, style: Get.textTheme.headline5)),
                              MaterialButton(
                                onPressed: () {
                                  Get.toNamed(Routes.CATEGORIES);
                                },
                                shape: StadiumBorder(),
                                color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                                child: Text("View All".tr, style: Get.textTheme.subtitle1),
                                elevation: 0,
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<List<EProvider>>(
                          future: controller.getEProviderAll(),
                          builder: (context, snapshot) {

                            if(!snapshot.hasData){
                              return Center(child: CircularProgressIndicator(),);
                            }

                            return EFeaturedproviderCarouselWidget(false,snapshot.requireData.toList().where((element) => element.featured).toList());
                          }
                        )
                        // RecommendedCarouselWidget(),
                        // FeaturedCategoriesWidget(),
                      ],
                    ),
                  ),
                ],
              ));
        }
      ),
    );
  }
}
