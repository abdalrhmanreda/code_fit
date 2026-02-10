import 'package:code_fit/blocked_and_maintance/data/models/app_status_model.dart';

abstract class AppStatusState {}

class AppStatusInitial extends AppStatusState {}

class AppStatusLoading extends AppStatusState {}

class AppStatusSuccess extends AppStatusState {
  final AppStatusModel statusModel;

  AppStatusSuccess(this.statusModel);
}

class AppStatusError extends AppStatusState {
  final String errorMessage;

  AppStatusError(this.errorMessage);
}
