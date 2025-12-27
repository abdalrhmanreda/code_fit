import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/constants/app_constant.dart';
import 'package:code_fit/core/constants/app_icons.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/responsive_text.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_button.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/core/utils/app_text_form_field.dart';
import 'package:code_fit/features/login/logic/login_cubit.dart';
import 'package:code_fit/features/login/ui/widgets/already_have_account.dart';
import 'package:code_fit/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forget_password_text.dart';
import 'or_widget.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: context.read<LoginCubit>().formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextApp(
                title: LocaleKeys.email,
                size: 17,
                fontWeight: FontWeightHelper.semiBold,
              ),
              Spacing.verticalSpace(10),
              AppTextFormField(
                controller: context.read<LoginCubit>().emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,

                validator: context.read<LoginCubit>().validateEmail,
                hintText: LocaleKeys.enter_email.tr(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: getResponsiveFontSize(context, fontSize: 16),
                ),
                borderRadius: 20,
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: getResponsiveFontSize(context, fontSize: 14),
                  color: AppColors.kGreyColor,
                ),
              ),
              Spacing.verticalSpace(15),
              MyTextApp(
                title: LocaleKeys.password,
                size: 17,
                fontWeight: FontWeightHelper.semiBold,
              ),
              Spacing.verticalSpace(10),
              AppTextFormField(
                borderRadius: 20,
                controller: context.read<LoginCubit>().passController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,

                validator: context.read<LoginCubit>().validatePassword,
                obscureText: context.read<LoginCubit>().isPass,
                suffixIcon: GestureDetector(
                  onTap: () {
                    context.read<LoginCubit>().changePassVisibility();
                  },
                  child: Icon(
                    context.read<LoginCubit>().isPass
                        ? AppIcons.visibilityOff
                        : AppIcons.visibility,
                    color: AppColors.kGreyColor,
                  ),
                ),
                hintText: LocaleKeys.password.tr(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: getResponsiveFontSize(context, fontSize: 16),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: getResponsiveFontSize(context, fontSize: 14),
                  color: AppColors.kGreyColor,
                ),
              ),
              Spacing.verticalSpace(10),
              ForgetPasswordText(),
              Spacing.verticalSpace(10),
              AppButton(
                text: LocaleKeys.next.tr(),
                borderRadius: 20,
                backgroundColor: AppColors.kPrimaryColor,
                size: AppButtonSize.large,
                type: AppButtonType.elevated,
                width: AppConstant.deviceWidth(context),
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.kWhiteColor,
                  fontSize: getResponsiveFontSize(context, fontSize: 16),
                  fontWeight: FontWeightHelper.semiBold,
                ),
                onPressed: () {
                  if (context
                      .read<LoginCubit>()
                      .formKey
                      .currentState!
                      .validate()) {}
                },
              ),
              Spacing.verticalSpace(20),
              OrWidget(),
              Spacing.verticalSpace(20),

              AlreadyHaveAccountAndDonnotHave(isLogin: true),
            ],
          ),
        );
      },
    );
  }
}
