import 'package:code_fit/config/routes/route_names.dart';
import 'package:code_fit/core/di/dependancy_injection.dart';
import 'package:code_fit/features/login/logic/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/login/ui/screens/login_screen.dart';
import '../../features/seasons/ui/screens/summer_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Define your routes here
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: LoginScreen(),
          ),
        );
      case RouteNames.summer:
        return MaterialPageRoute(builder: (_) => const SummerScreen());
      default:
        return null;
    }
  }
}
