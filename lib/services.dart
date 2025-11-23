import 'package:code_fit/core/di/dependancy_injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/helpers/bloc_observer.dart';

class Services {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    Bloc.observer = MyBlocObserver();
    setupGetIt();
  }
}
