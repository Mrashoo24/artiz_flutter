/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/ui.dart';
import '../../../../models/e_provider_model.dart';
import '../../../../routes/app_routes.dart';
import 'e_provider_main_thumb_widget.dart';

class EProvidersListItemWidget extends StatelessWidget {
  const EProvidersListItemWidget({
    Key key,
    @required EProvider eProvider,
  })  : _eProvider = eProvider,
        super(key: key);

  final EProvider _eProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.E_PROVIDER, arguments: {'eProvider': _eProvider, 'heroTag': 'e_providers_list_item'});
      },
      child: Container(
        width: double.infinity,
        decoration:BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          boxShadow: [
            //BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          children: [
            EProviderMainThumbWidget(eProvider: _eProvider),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                    _eProvider.name ?? '',
                    maxLines: 2,
                    style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                  ),
                  Text(
                    _eProvider.description ?? '',
                    maxLines: 3,
                    style: Get.textTheme.bodyText1,
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Wrap(
                        children: Ui.getStarsList(_eProvider.rate),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
