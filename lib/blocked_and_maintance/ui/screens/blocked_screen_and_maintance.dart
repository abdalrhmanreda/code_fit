import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:code_fit/blocked_and_maintance/logic/app_status_cubit.dart';
import 'package:code_fit/blocked_and_maintance/logic/app_status_state.dart';
import 'package:code_fit/blocked_and_maintance/ui/widgets/animated_background_circles.dart';
import 'package:code_fit/blocked_and_maintance/ui/widgets/glassmorphic_card.dart';
import 'package:code_fit/blocked_and_maintance/ui/widgets/gradient_title.dart';
import 'package:code_fit/blocked_and_maintance/ui/widgets/premium_button.dart';
import 'package:code_fit/blocked_and_maintance/ui/widgets/status_animation_container.dart';
import 'package:code_fit/core/di/dependancy_injection.dart';

class BlockedScreenAndMaintance extends StatelessWidget {
  final int appId;
  final bool fromNavigation;

  const BlockedScreenAndMaintance({
    super.key,
    this.appId = 1,
    this.fromNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    // Only create new provider if not from navigation
    if (fromNavigation) {
      return _BlockedScreenContent(appId: appId);
    }

    return BlocProvider(
      create: (context) => getIt<AppStatusCubit>()..getAppStatus(appId),
      child: _BlockedScreenContent(appId: appId),
    );
  }
}

class _BlockedScreenContent extends StatefulWidget {
  final int appId;

  const _BlockedScreenContent({required this.appId});

  @override
  State<_BlockedScreenContent> createState() => _BlockedScreenContentState();
}

class _BlockedScreenContentState extends State<_BlockedScreenContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _gradientController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  // Local state fallback when API fails
  bool? _localIsBlocked;
  bool? _localIsMaintenance;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStatusCubit, AppStatusState>(
      listener: (context, state) {
        if (state is AppStatusSuccess) {
          print(
            '✅ AppStatusSuccess: isBlocked=${state.statusModel.isBlocked}, isMantainance=${state.statusModel.isMantainance}',
          );
          // Update local state with API response
          _localIsBlocked = state.statusModel.isBlocked;
          _localIsMaintenance = state.statusModel.isMantainance;
        } else if (state is AppStatusError) {
          print('❌ AppStatusError: ${state.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'API Error: ${state.errorMessage}\nUsing local state',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is AppStatusLoading) {
          print('⏳ AppStatusLoading');
        }
      },
      child: BlocBuilder<AppStatusCubit, AppStatusState>(
        builder: (context, state) {
          // Default to maintenance, but check specific flags carefully
          bool isMaintenance = true;
          bool? isBlocked;
          bool? isMaint;

          if (state is AppStatusSuccess) {
            // API Response / Manual Set
            isBlocked = state.statusModel.isBlocked;
            isMaint = state.statusModel.isMantainance;

            // Priority Logic: If Blocked is true, force it to Blocked mode
            if (isBlocked == true) {
              isMaintenance = false;
            } else if (isMaint == true) {
              isMaintenance = true;
            }
          } else if (state is AppStatusError || state is AppStatusLoading) {
            // Local State Fallback
            if (_localIsBlocked != null || _localIsMaintenance != null) {
              isBlocked = _localIsBlocked;
              isMaint = _localIsMaintenance;

              if (_localIsBlocked == true) {
                isMaintenance = false;
              } else if (_localIsMaintenance == true) {
                isMaintenance = true;
              }
            }
          }

          return Scaffold(
            body: AnimatedBuilder(
              animation: _gradientController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isMaintenance
                          ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                          : [const Color(0xFFff6b6b), const Color(0xFFee5253)],
                      transform: GradientRotation(
                        _gradientController.value * 2 * 3.14159,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        // Background circles
                        AnimatedBackgroundCircles(
                          pulseAnimation: _pulseAnimation,
                        ),

                        // Content
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GlassmorphicCard(
                                    pulseAnimation: _pulseAnimation,
                                    child: Column(
                                      children: [
                                        StatusAnimationContainer(
                                          isMaintenance: isMaintenance,
                                        ),
                                        const SizedBox(height: 40),
                                        GradientTitle(
                                          text: isMaintenance
                                              ? 'Under Maintenance'
                                              : 'Access Restricted',
                                        ),
                                        const SizedBox(height: 16),
                                        _buildSubtitle(isMaintenance),
                                        const SizedBox(height: 16),
                                        _buildDescription(isMaintenance),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  // Manual Toggle Buttons for Video Demo
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Video Demo Controls",
                                          style: GoogleFonts.inter(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: PremiumButton(
                                                onPressed: () {
                                                  context
                                                      .read<AppStatusCubit>()
                                                      .setLocalState(
                                                        isBlocked: false,
                                                        isMaintainance: true,
                                                      );
                                                },
                                                icon:
                                                    Icons.build_circle_outlined,
                                                label: 'Maintenance',
                                                isPrimary: isMaintenance,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: PremiumButton(
                                                onPressed: () {
                                                  context
                                                      .read<AppStatusCubit>()
                                                      .setLocalState(
                                                        isBlocked: true,
                                                        isMaintainance: false,
                                                      );
                                                },
                                                icon: Icons.block_outlined,
                                                label: 'Blocked',
                                                isPrimary: !isMaintenance,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Contact Support only shown when blocked (and not overridden)
                                  if (!isMaintenance)
                                    PremiumButton(
                                      onPressed: () {},
                                      icon: Icons.headset_mic_rounded,
                                      label: 'Contact Support',
                                      isPrimary: true,
                                    ),
                                  const SizedBox(height: 20),
                                  _buildFooter(isMaintenance),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Debug Status Panel
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GlassmorphicCard(
                              pulseAnimation: _pulseAnimation,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'API Status',
                                      style: GoogleFonts.inter(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildStatusChip(
                                          'isBlocked',
                                          isBlocked.toString(),
                                          isBlocked == true,
                                        ),
                                        const SizedBox(width: 12),
                                        _buildStatusChip(
                                          'isMaintenance',
                                          isMaint.toString(),
                                          isMaint == true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // This function is no longer used as its content has been moved inline
  // Widget _buildMainContent(bool isMaintenance, AppStatusState state) {
  //   // Show loading indicator
  //   if (state is AppStatusLoading) {
  //     return Center(child: CircularProgressIndicator(color: Colors.white));
  //   }

  //   return FadeTransition(
  //     opacity: _fadeAnimation,
  //     child: Center(
  //       child: SingleChildScrollView(
  //         padding: const EdgeInsets.all(24.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             GlassmorphicCard(
  //               pulseAnimation: _pulseAnimation,
  //               child: Column(
  //                 children: [
  //                   StatusAnimationContainer(isMaintenance: isMaintenance),
  //                   const SizedBox(height: 32),
  //                   GradientTitle(
  //                     text: isMaintenance
  //                         ? 'Under Maintenance'
  //                         : 'Access Restricted',
  //                   ),
  //                   const SizedBox(height: 20),
  //                   _buildSubtitle(isMaintenance),
  //                   const SizedBox(height: 16),
  //                   _buildDescription(isMaintenance),
  //                   const SizedBox(height: 40),
  //                   // Only show Contact Support button when blocked
  //                   if (!isMaintenance)
  //                     PremiumButton(
  //                       onPressed: () {},
  //                       icon: Icons.headset_mic_rounded,
  //                       label: 'Contact Support',
  //                       isPrimary: true,
  //                     ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 40),

  //             // Debug Status Display
  //             if (state is AppStatusSuccess)
  //               Container(
  //                 padding: const EdgeInsets.all(16),
  //                 margin: const EdgeInsets.symmetric(horizontal: 24),
  //                 decoration: BoxDecoration(
  //                   color: Colors.black.withValues(alpha: 0.3),
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(
  //                     color: Colors.white.withValues(alpha: 0.3),
  //                   ),
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       'API Status',
  //                       style: GoogleFonts.outfit(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         _buildStatusChip(
  //                           'isBlocked',
  //                           state.statusModel.isBlocked?.toString() ?? 'null',
  //                           state.statusModel.isBlocked == true,
  //                         ),
  //                         _buildStatusChip(
  //                           'isMaintenance',
  //                           state.statusModel.isMantainance?.toString() ??
  //                               'null',
  //                           state.statusModel.isMantainance == true,
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             const SizedBox(height: 20),
  //             _buildFooter(isMaintenance),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSubtitle(bool isMaintenance) {
    return Text(
      isMaintenance
          ? 'We\'re making things better'
          : 'Your rights have been suspended',
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white.withValues(alpha: 0.9),
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(bool isMaintenance) {
    return Text(
      isMaintenance
          ? 'We\'re currently performing scheduled maintenance to enhance your experience. Our team is working hard to bring you exciting new features and improvements.'
          : 'This application has been temporarily blocked due to non-payment. Please contact our support team to resolve this issue and restore your access.',
      style: GoogleFonts.inter(
        fontSize: 15,
        color: Colors.white.withValues(alpha: 0.75),
        height: 1.6,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFooter(bool isMaintenance) {
    return Text(
      isMaintenance
          ? 'Thank you for your patience'
          : 'Need immediate assistance? Reach out to us',
      style: GoogleFonts.inter(
        fontSize: 13,
        color: Colors.white.withValues(alpha: 0.6),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatusChip(String label, String value, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green : Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: isActive ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
