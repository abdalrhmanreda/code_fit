import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/login/ui/widgets/login_form.dart';
import 'package:code_fit/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyTextApp(
              title: LocaleKeys.login.tr(),
              size: 30,
              fontWeight: FontWeightHelper.bold,
            ),
            Spacing.verticalSpace(10),
            MyTextApp(
              title: LocaleKeys.please_login.tr(),
              size: 18,
              fontWeight: FontWeightHelper.regular,
              color: AppColors.kGreyColor,
            ),
            Spacing.verticalSpace(25),

            LoginForm(),
          ],
        ),
      ),
    );
  }
}
