import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/login/ui/widgets/social_platform_signin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../gen/locale_keys.g.dart';

class OrWidget extends StatelessWidget {
  const OrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: MyTextApp(
                title: LocaleKeys.or.tr(),
                size: 18,
                fontWeight: FontWeightHelper.semiBold,
              ),
            ),
            Expanded(child: Divider(thickness: 1)),
          ],
        ),
        Spacing.verticalSpace(10),
        Row(
          children: [
            Expanded(
              child: SocialPlatformSignin(
                text: LocaleKeys.google.tr(),
                platformIcon: Brands.google,
              ),
            ),
            Spacing.horizontalSpace(15),
            Expanded(
              child: SocialPlatformSignin(
                text: LocaleKeys.facebook.tr(),
                platformIcon: Brands.facebook,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
