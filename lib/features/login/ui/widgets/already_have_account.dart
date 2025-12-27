import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_button.dart';

class AlreadyHaveAccountAndDonnotHave extends StatelessWidget {
  const AlreadyHaveAccountAndDonnotHave({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyTextApp(
          title: isLogin
              ? '${LocaleKeys.dont_have_account.tr()} ?'
              : LocaleKeys.already_have_account.tr(),
          size: 16,
          fontWeight: FontWeightHelper.semiBold,
        ),
        Spacing.horizontalSpace(5),
        AppButton(
          padding: EdgeInsets.zero,
          fontSize: 16,
          text: isLogin ? LocaleKeys.signup.tr() : LocaleKeys.login.tr(),
          onPressed: () {},
          type: AppButtonType.text,
        ),
      ],
    );
  }
}
