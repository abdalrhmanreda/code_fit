// import 'package:code_fit/config/routes/route_names.dart';
// import 'package:code_fit/services.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// import 'app.dart';
// import 'config/routes/app_router.dart';

// void main() async {
//   await Services.initialize();

//   runApp(
//     EasyLocalization(
//       supportedLocales: const [Locale('en'), Locale('ar')],
//       path: 'assets/translations',
//       fallbackLocale: const Locale('en'),
//       child: CodeFitApp(initialRoute: RouteNames.login, appRouter: AppRouter()),
//     ),
//   );
// }
import 'package:code_fit/blocked_and_maintance/ui/screens/app_initializer.dart';
import 'package:code_fit/core/di/dependancy_injection.dart';
import 'package:code_fit/features/birthday_card/ui/screens/romantic_birthday_screen.dart';
import 'package:code_fit/features/liqwed_swip/ui/liqwed_swip_screen.dart';
import 'package:code_fit/features/map_location/ui/screens/map_location_screen.dart';
import 'package:code_fit/l10n/alive_picker_localizations.dart';
import 'package:code_fit/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Code Fit App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          localizationsDelegates: const [
            AlivePickerLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          home: LiqwedSwipScreen(),
        );
      },
    );
  }
}
