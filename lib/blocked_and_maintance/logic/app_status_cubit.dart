import 'package:code_fit/blocked_and_maintance/data/models/app_status_model.dart';
import 'package:code_fit/blocked_and_maintance/data/repo/app_status_repo.dart';
import 'package:code_fit/blocked_and_maintance/logic/app_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStatusCubit extends Cubit<AppStatusState> {
  final AppStatusRepo _appStatusRepo;

  AppStatusCubit(this._appStatusRepo) : super(AppStatusInitial());

  Future<void> getAppStatus(int appId) async {
    emit(AppStatusLoading());
    // Artificial delay to allow loading screen to be seen (video demo)
    await Future.delayed(const Duration(seconds: 2));
    print('🔄 AppStatusCubit: Fetching app status for ID: $appId');

    final result = await _appStatusRepo.getAppStatus(appId);
    result.fold(
      ifLeft: (error) {
        print('❌ AppStatusCubit Error: $error');
        emit(AppStatusError(error));
      },
      ifRight: (statusModel) {
        print(
          '✅ AppStatusCubit Success: Blocked=${statusModel.isBlocked}, Maint=${statusModel.isMantainance}',
        );
        emit(AppStatusSuccess(statusModel));
      },
    );
  }

  Future<void> setMaintenanceMode(int appId) async {
    emit(AppStatusLoading());
    final result = await _appStatusRepo.setAppStatus(
      appId,
      false, // isBlocked
      true, // isMaintainance
    );
    result.fold(
      ifLeft: (error) => emit(AppStatusError(error)),
      ifRight: (statusModel) => emit(AppStatusSuccess(statusModel)),
    );
  }

  Future<void> setBlockedMode(int appId) async {
    emit(AppStatusLoading());
    final result = await _appStatusRepo.setAppStatus(
      appId,
      true, // isBlocked
      false, // isMaintainance
    );
    result.fold(
      ifLeft: (error) => emit(AppStatusError(error)),
      ifRight: (statusModel) => emit(AppStatusSuccess(statusModel)),
    );
  }

  // Set local state immediately (for when API fails)
  void setLocalState({required bool isBlocked, required bool isMaintainance}) {
    emit(
      AppStatusSuccess(
        AppStatusModel(isBlocked: isBlocked, isMantainance: isMaintainance),
      ),
    );
  }
}
