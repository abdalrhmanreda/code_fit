import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'twinkling_widget.dart';

class EnhancedSkyBackground extends StatefulWidget {
  final bool isPM;
  final AnimationController transitionController;

  const EnhancedSkyBackground({
    super.key,
    required this.isPM,
    required this.transitionController,
  });

  @override
  State<EnhancedSkyBackground> createState() => _EnhancedSkyBackgroundState();
}

class _EnhancedSkyBackgroundState extends State<EnhancedSkyBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _cloudController;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.isPM
              ? [
                  const Color(0xFF0f172a),
                  const Color(0xFF1e293b),
                  const Color(0xFF334155),
                ]
              : [
                  const Color(0xFF60a5fa),
                  const Color(0xFF93c5fd),
                  const Color(0xFFdbeafe),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Stars for night
          if (widget.isPM) ...[
            Positioned(top: 20, left: 40, child: _buildStar(0.8)),
            Positioned(top: 35, left: 100, child: _buildStar(0.6)),
            Positioned(top: 25, right: 60, child: _buildStar(1.0)),
            Positioned(top: 50, right: 120, child: _buildStar(0.7)),
            Positioned(top: 45, left: 200, child: _buildStar(0.5)),
          ],

          // Clouds for day
          if (!widget.isPM)
            AnimatedBuilder(
              animation: _cloudController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: 30,
                      left: -50 + (_cloudController.value * 500) % 500,
                      child: _buildCloud(40, 0.3),
                    ),
                    Positioned(
                      top: 60,
                      left: -100 + (_cloudController.value * 400) % 500,
                      child: _buildCloud(30, 0.2),
                    ),
                    Positioned(
                      top: 45,
                      left: -150 + (_cloudController.value * 450) % 500,
                      child: _buildCloud(35, 0.25),
                    ),
                  ],
                );
              },
            ),

          // Sun/Moon with enhanced animation
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: RotationTransition(turns: animation, child: child),
                );
              },
              child: widget.isPM
                  ? Stack(
                      key: const ValueKey('moon'),
                      alignment: Alignment.center,
                      children: [
                        // Moon glow
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // Moon
                        Container(
                          width: 55,
                          height: 55,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF4E9CD),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 12,
                                left: 15,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE5D4B5),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 30,
                                left: 10,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE5D4B5),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 25,
                                right: 12,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE5D4B5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      key: const ValueKey('sun'),
                      alignment: Alignment.center,
                      children: [
                        // Sun rays
                        ...List.generate(8, (index) {
                          return Transform.rotate(
                            angle: (index * math.pi / 4),
                            child: Container(
                              width: 4,
                              height: 85,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.yellow[600]!.withOpacity(0),
                                    Colors.yellow[600]!,
                                    Colors.yellow[600]!.withOpacity(0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                        // Sun glow
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // Sun
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.yellow[300]!,
                                Colors.yellow[600]!,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          // Transition particles
          AnimatedBuilder(
            animation: widget.transitionController,
            builder: (context, child) {
              if (widget.transitionController.value == 0) {
                return const SizedBox.shrink();
              }
              return Stack(
                children: List.generate(15, (index) {
                  final random = math.Random(index);
                  final startX = random.nextDouble() * 400;
                  final startY = random.nextDouble() * 140;
                  final endY = startY + (random.nextDouble() * 60 - 30);

                  return Positioned(
                    left: startX,
                    top:
                        startY +
                        (endY - startY) * widget.transitionController.value,
                    child: Opacity(
                      opacity: (1 - widget.transitionController.value),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isPM ? Colors.white : Colors.yellow,
                          boxShadow: [
                            BoxShadow(
                              color: widget.isPM
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.yellow.withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStar(double opacity) {
    return TwinklingWidget(
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(opacity * 0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud(double size, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size * 0.6,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
    );
  }
}
