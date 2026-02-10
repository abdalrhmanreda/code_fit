import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_fit/blocked_and_maintance/logic/app_status_cubit.dart';
import 'package:code_fit/blocked_and_maintance/logic/app_status_state.dart';
import 'package:code_fit/blocked_and_maintance/ui/screens/blocked_screen_and_maintance.dart';
import 'package:code_fit/core/di/dependancy_injection.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInitializer extends StatelessWidget {
  final int appId;
  final Widget homeScreen;

  const AppInitializer({
    super.key,
    required this.appId,
    required this.homeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppStatusCubit>()..getAppStatus(appId),
      child: BlocBuilder<AppStatusCubit, AppStatusState>(
        builder: (context, state) {
          print('📱 AppInitializer Builder State: $state');

          if (state is AppStatusLoading || state is AppStatusInitial) {
            // Show loading screen while checking status
            return _LoadingScreen();
          } else if (state is AppStatusSuccess) {
            // Check if app is blocked or in maintenance
            final isBlocked = state.statusModel.isBlocked ?? false;
            final isMaintenance = state.statusModel.isMantainance ?? false;

            print(
              '🔎 Status Check: isBlocked=$isBlocked, isMaintenance=$isMaintenance',
            );

            if (isBlocked || isMaintenance) {
              print('🔒 Access Restricted: Showing Blocked/Maintenance Screen');
              // Show blocked/maintenance screen
              return BlocProvider.value(
                value: context.read<AppStatusCubit>(),
                child: BlockedScreenAndMaintance(
                  appId: appId,
                  fromNavigation: true,
                ),
              );
            } else {
              print('🔓 Access Granted: Showing Home Screen');
              // App is active - show normal home screen
              return homeScreen;
            }
          } else if (state is AppStatusError) {
            print('⚠️ Status Error: Access Granted (Fail Open)');
            // On error, allow access to app (fail-open)
            return homeScreen;
          }

          return _LoadingScreen();
        },
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                'Connecting to Secure Server...',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
