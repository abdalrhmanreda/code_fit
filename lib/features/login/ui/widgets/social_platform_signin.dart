import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/utils/app_text.dart';

class SocialPlatformSignin extends StatelessWidget {
  const SocialPlatformSignin({
    super.key,
    required this.text,
    required this.platformIcon,
  });

  final String text;

  final String platformIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Brand(platformIcon),
            Spacing.horizontalSpace(10),
            MyTextApp(
              title: text,
              size: 15,
              fontWeight: FontWeightHelper.semiBold,
            ),
          ],
        ),
      ),
    );
  }
}
