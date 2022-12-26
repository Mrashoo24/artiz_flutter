/*
 * File name: salon_main_thumb_widget.dart
 * Last modified: 2022.02.04 at 18:22:32
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../models/e_provider_model.dart';
import 'e_provider_type_badge_widget.dart';

class EProviderMainThumbWidget extends StatelessWidget {
  const EProviderMainThumbWidget({
    Key key,
    @required EProvider eProvider,
  })  : _eProvider = eProvider,
        super(key: key);

  final EProvider _eProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'recommended_carousel' + _eProvider.id,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: CachedNetworkImage(
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: _eProvider.firstImageUrl,
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ),
        ),
        EProviderTypeBadgeWidget(eProvider: _eProvider),
      ],
    );
  }
}
