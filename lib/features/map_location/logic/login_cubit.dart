import 'package:bloc/bloc.dart';
import 'package:code_fit/features/login/data/repo/login_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/helpers/app_regex.dart';
import '../../../gen/locale_keys.g.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginRepo) : super(LoginInitial());
  final LoginRepo loginRepo;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isPass = true;
  bool isRememberMe = false;

  void changeRememberMeValue(bool? value) {
    isRememberMe = value ?? false;
    emit(ChangeRememberMeState());
  }

  void changePassVisibility() {
    isPass = !isPass;
    emit(ChangePassVisibilityState());
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.email_is_required.tr();
    }
    // Simple email validation
    if (!AppRegex.isEmailValid(value)) {
      return LocaleKeys.email_should_be_valid.tr();
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.password_is_required.tr();
    }
    // Simple email validation
    if (!AppRegex.isPasswordValid(value)) {
      return LocaleKeys.password_should_be_strong.tr();
    }
    if (value.length < 8) {
      return LocaleKeys.password_min_length.tr();
    }
    return null;
  }
}
