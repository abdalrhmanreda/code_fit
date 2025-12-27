import 'package:code_fit/config/routes/route_names.dart';
import 'package:code_fit/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/routes/app_router.dart';

void main() async {
  await Services.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: CodeFitApp(initialRoute: RouteNames.login, appRouter: AppRouter()),
    ),
  );
}
