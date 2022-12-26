import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../e_provider/views/e_provider_list.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../widgets/services_list_widget.dart';

class CategoryView extends GetView<HomeController> {



  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: ()async {
        Get.find<HomeController>().subcategory.value = null;
        Get.find<HomeController>().category.value = null;

        return true;
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            if (!Get.find<LaravelApiClient>()
                .isLoading(tasks: ['getAllEServicesWithPagination', 'getFeaturedEServices', 'getPopularEServices', 'getMostRatedEServices', 'getAvailableEServices'])) {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshEServices(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            }
          },
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Get.theme.scaffoldBackgroundColor,
                expandedHeight: 280,
                elevation: 0.5,
                primary: true,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                title: Column(
                  children: [
                    Text(
                      controller.category.value == null ? Get.arguments.name :     controller.category.value.name,
                      style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                    ),
                    controller.subcategory.value != null ? Text(
                      controller.subcategory.value.name,
                      style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                    ) : SizedBox(),
                  ],
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
                  onPressed: () => {


              Get.back(),
                  Get.find<HomeController>().subcategory.value = null,
                    Get.find<HomeController>().category.value = null

                  },
                ),
                bottom: HomeSearchBarWidget(),
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 75, bottom: 115),
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                                colors: [controller.category.value.color.withOpacity(1), controller.category.value.color.withOpacity(0.2)],
                                begin: AlignmentDirectional.topStart,
                                //const FractionalOffset(1, 0),
                                end: AlignmentDirectional.bottomEnd,
                                stops: [0.1, 0.9],
                                tileMode: TileMode.clamp),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                          ),
                          child: (controller.category.value.image.url.toLowerCase().endsWith('.svg')
                              ? SvgPicture.network(
                                  controller.category.value.image.url,
                                  color: controller.category.value.color,
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.fitHeight,
                                  imageUrl: controller.category.value.image.url,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/img/loading.gif',
                                    fit: BoxFit.fitHeight,
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                )),
                        ),
                        AddressWidget().paddingOnly(bottom: 75),
                      ],
                    )).marginOnly(bottom: 42),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    Container(
                      height: 60,
                      child: ListView(
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(CategoryFilter.values.length, (index) {
                            var _filter = CategoryFilter.values.elementAt(index);
                            return Obx(() {
                              return Padding(
                                padding: const EdgeInsetsDirectional.only(start: 20),
                                child: RawChip(
                                  elevation: 0,
                                  label: Text(_filter.toString().tr),
                                  labelStyle: controller.isSelected(_filter) ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)) : Get.textTheme.bodyText2,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                                  selectedColor: controller.category.value.color,
                                  selected: controller.isSelected(_filter),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  showCheckmark: true,
                                  checkmarkColor: Get.theme.primaryColor,
                                  onSelected: (bool value) {
                                    print('changed = $_filter');
                                    controller.toggleSelected(_filter);
                                    controller.loadEServicesOfCategory(
                                        // controller.category.value.id,
                                        filter: controller.selected.value
                                    );
                                  },
                                ),
                              );
                            });
                          })),
                    ),
                     // ServicesListWidget(),
                     EproviderCarouselWidget(true)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
