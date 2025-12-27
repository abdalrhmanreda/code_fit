import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/config/routes/app_router.dart';
import 'package:code_fit/features/movie/screens/onboarding.dart';
import 'package:code_fit/test_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:code_fit/core/helpers/graphql_helper.dart';

import 'config/themes/app_theme.dart';

/// Main app widget
class CodeFitApp extends StatelessWidget {
  const CodeFitApp({
    super.key,
    required this.initialRoute,
    required this.appRouter,
  });

  final String initialRoute;

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    );
    return GraphQLProvider(
      client: GraphqlHelper.client,
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone 11 Pro size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Code Fit',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: appRouter.generateRoute,
            // initialRoute: initialRoute,
            home: AnimeMoviesOnboardingScreen(),
          );
        },
      ),
    );
  }
}
