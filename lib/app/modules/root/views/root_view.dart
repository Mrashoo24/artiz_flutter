import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends StatefulWidget {
  final int currentpageindex ;

  const RootView({Key key, this.currentpageindex}) : super(key: key);
  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  var currentpage = 0;

  @override
  void initState() {
    setState(() {
      currentpage =  widget.currentpageindex == null ?  currentpage : widget.currentpageindex;

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RootController>(
      init:Get.find<RootController>() ,
      builder: (controller) {
        return Scaffold(
          key: RootController.key,
          drawer: MainDrawerWidget(),
          body: controller.pages[currentpage],
          bottomNavigationBar: CustomBottomNavigationBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            itemColor: context.theme.colorScheme.secondary,
            currentIndex:currentpage,
            onChange: (index) async {
              if (!Get.find<AuthService>().isAuth && index > 0) {
                await Get.toNamed(Routes.LOGIN);
              }else{
                setState(() {
                  currentpage = index;
                });
              }

              // controller.changePage(index);
            },
            children: [
              CustomBottomNavigationItem(
                icon: Icons.home_outlined,
                label: "Home".tr,
              ),
              CustomBottomNavigationItem(
                icon: Icons.calendar_month,
                label: "Calender".tr,
              ),
              // CustomBottomNavigationItem(
              //   icon: Icons.assignment_outlined,
              //   label: "Bookings".tr,
              // ),

              CustomBottomNavigationItem(
                icon: Icons.home_repair_service,
                label: "Buy/Sell".tr,
              ),

              CustomBottomNavigationItem(
                icon: Icons.video_call,
                label: "Videos".tr,
              ),

              CustomBottomNavigationItem(
                icon: Icons.newspaper,
                label: "News".tr,
              ),

              // CustomBottomNavigationItem(
              //   icon: Icons.chat_outlined,
              //   label: "Chats".tr,
              // ),
              // CustomBottomNavigationItem(
              //   icon: Icons.person_outline,
              //   label: "Account".tr,
              // ),
            ],
          ),
        );
      }
    );
  }
}
