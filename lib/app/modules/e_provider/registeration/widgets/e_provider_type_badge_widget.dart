/*
 * File name: eProvider_level_badge_widget.dart
 * Last modified: 2022.02.13 at 15:44:07
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/e_provider_model.dart';


class EProviderTypeBadgeWidget extends StatelessWidget {
  const EProviderTypeBadgeWidget({
    Key key,
    @required EProvider eProvider,
  })  : _eProvider = eProvider,
        super(key: key);

  final EProvider _eProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 12, top: 10),
      child: Text(_eProvider.category?.name ?? '',
          maxLines: 1,
          style: Get.textTheme.bodyText2.merge(
            TextStyle(color: Get.theme.primaryColor, height: 1.4, fontSize: 10),
          ),
          softWrap: false,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.secondary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
