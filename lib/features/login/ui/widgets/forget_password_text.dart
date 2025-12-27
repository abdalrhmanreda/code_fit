import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/utils/app_button.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/login/logic/login_cubit.dart';
import 'package:code_fit/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          value: context.read<LoginCubit>().isRememberMe,
          onChanged: (value) {
            context.read<LoginCubit>().changeRememberMeValue(value!);
          },
        ),
        MyTextApp(
          title: LocaleKeys.remember_me.tr(),
          size: 15,
          fontWeight: FontWeightHelper.semiBold,
        ),
        Spacer(),
        AppButton(
          text: LocaleKeys.forgot_password.tr(),
          onPressed: () {},
          type: AppButtonType.text,
        ),
      ],
    );
  }
}
