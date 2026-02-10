import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:code_fit/blocked_and_maintance/logic/app_status_cubit.dart';
import 'package:code_fit/blocked_and_maintance/ui/screens/blocked_screen_and_maintance.dart';
import 'package:code_fit/blocked_and_maintance/ui/widgets/premium_button.dart';
import 'package:code_fit/core/di/dependancy_injection.dart';

class AppControlScreen extends StatelessWidget {
  const AppControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppStatusCubit>(),
      child: const _AppControlContent(),
    );
  }
}

class _AppControlContent extends StatelessWidget {
  const _AppControlContent();

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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'App Control Panel',
                  style: GoogleFonts.outfit(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Test the app status by setting maintenance or blocked mode',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Maintenance Button
                PremiumButton(
                  onPressed: () async {
                    final cubit = context.read<AppStatusCubit>();

                    // Set local state immediately for UI responsiveness
                    cubit.setLocalState(isBlocked: false, isMaintainance: true);

                    // Then try API call
                    await cubit.setMaintenanceMode(1);

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: const BlockedScreenAndMaintance(
                              appId: 1,
                              fromNavigation: true,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icons.build_circle_outlined,
                  label: 'Set Maintenance Mode',
                  isPrimary: true,
                ),
                const SizedBox(height: 20),

                // Blocked Button
                PremiumButton(
                  onPressed: () async {
                    final cubit = context.read<AppStatusCubit>();

                    // Set local state immediately for UI responsiveness
                    cubit.setLocalState(isBlocked: true, isMaintainance: false);

                    // Then try API call
                    await cubit.setBlockedMode(1);

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: cubit,
                            child: const BlockedScreenAndMaintance(
                              appId: 1,
                              fromNavigation: true,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icons.block_outlined,
                  label: 'Set Blocked Mode',
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
