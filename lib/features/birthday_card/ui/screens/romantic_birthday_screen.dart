import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

/// A romantic birthday card screen with animated floating hearts
/// and a warm, cozy atmosphere inspired by modern Flutter UI design
class RomanticBirthdayScreen extends StatefulWidget {
  final String recipientName;
  final String? senderName;
  final VoidCallback? onSendLove;

  const RomanticBirthdayScreen({
    super.key,
    this.recipientName = 'Clara',
    this.senderName,
    this.onSendLove,
  });

  @override
  State<RomanticBirthdayScreen> createState() => _RomanticBirthdayScreenState();
}

class _RomanticBirthdayScreenState extends State<RomanticBirthdayScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _heartsController;
  late AnimationController _confettiController;
  late AnimationController _celebrationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _celebrationAnimation;

  final List<FloatingHeart> _hearts = [];
  final List<Confetti> _confettiPieces = [];
  final Random _random = Random();
  bool _isCelebrating = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _generateHearts();
    _generateConfetti();
  }

  void _initAnimations() {
    // Glow animation for the aura around the character
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Hearts floating animation
    _heartsController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Confetti animation
    _confettiController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    // Celebration burst animation
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _celebrationAnimation = CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.easeOutCubic,
    );
  }

  void _generateHearts() {
    for (int i = 0; i < 15; i++) {
      _hearts.add(
        FloatingHeart(
          startX: _random.nextDouble(),
          startY: _random.nextDouble(),
          size: _random.nextDouble() * 20 + 10,
          speed: _random.nextDouble() * 0.5 + 0.3,
          delay: _random.nextDouble(),
          opacity: _random.nextDouble() * 0.5 + 0.3,
          color: _getRandomHeartColor(),
        ),
      );
    }
  }

  void _generateConfetti() {
    for (int i = 0; i < 20; i++) {
      _confettiPieces.add(
        Confetti(
          startX: _random.nextDouble(),
          startY: _random.nextDouble() * -0.5,
          size: _random.nextDouble() * 8 + 4,
          speed: _random.nextDouble() * 0.3 + 0.2,
          delay: _random.nextDouble(),
          color: _getRandomConfettiColor(),
          rotation: _random.nextDouble() * 360,
        ),
      );
    }
  }

  Color _getRandomHeartColor() {
    final colors = [
      const Color(0xFFFFB6C1), // Light pink
      const Color(0xFFF8BBD9), // Soft pink
      const Color(0xFFE1BEE7), // Light purple
      const Color(0xFFCE93D8), // Medium purple
      const Color(0xFFF48FB1), // Medium pink
      const Color(0xFFFFCDD2), // Very light pink
    ];
    return colors[_random.nextInt(colors.length)];
  }

  Color _getRandomConfettiColor() {
    final colors = [
      const Color(0xFFFFB6C1),
      const Color(0xFFE1BEE7),
      const Color(0xFFFFF9C4), // Light yellow
      const Color(0xFFB3E5FC), // Light blue
      const Color(0xFFFFCCBC), // Light peach
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _triggerCelebration() {
    setState(() {
      _isCelebrating = true;
    });

    // Start celebration animation
    _celebrationController.forward(from: 0);

    // Show celebratory message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              '🎉 Happy Birthday ${widget.recipientName}! 🎂',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFFA6C9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 3),
      ),
    );

    // Reset celebration state after animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isCelebrating = false;
      });
    });

    // Call the optional callback
    widget.onSendLove?.call();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _heartsController.dispose();
    _confettiController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5D4E60), // Warm purple-brown
              Color(0xFF8B7355), // Warm brown
              Color(0xFF6B5B5B), // Soft mauve
              Color(0xFF7D6B6B), // Dusty rose-brown
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorations
            _buildBackgroundDecorations(),

            // Floating confetti
            _buildConfettiLayer(),

            // String lights at the top
            _buildStringLights(),

            // Floating hearts
            _buildFloatingHearts(),

            // Celebrate Lottie overlay
            _buildCelebrateOverlay(),

            // Celebration burst when button is pressed
            _buildCelebrationBurst(),

            // Main content
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Positioned.fill(
      child: CustomPaint(painter: BackgroundPatternPainter()),
    );
  }

  Widget _buildStringLights() {
    return Positioned(
      top: 40.h,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 60.h,
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return CustomPaint(
              painter: StringLightsPainter(glowIntensity: _glowAnimation.value),
              size: Size(double.infinity, 60.h),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingHearts() {
    return AnimatedBuilder(
      animation: _heartsController,
      builder: (context, child) {
        return Stack(
          children: _hearts.map((heart) {
            final progress = (_heartsController.value + heart.delay) % 1.0;
            final yOffset = 1.0 - (progress * heart.speed * 2);
            final xWobble = sin(progress * pi * 4) * 0.05;

            return Positioned(
              left:
                  (heart.startX + xWobble) * MediaQuery.of(context).size.width,
              top:
                  (heart.startY + yOffset) * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: heart.opacity * (1 - (progress * 0.5)),
                child: Icon(
                  Icons.favorite,
                  size: heart.size,
                  color: heart.color,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildConfettiLayer() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return Stack(
          children: _confettiPieces.map((confetti) {
            final progress = (_confettiController.value + confetti.delay) % 1.0;
            final yOffset = progress * confetti.speed * 3;
            final xWobble = sin(progress * pi * 6) * 0.03;
            final rotation = confetti.rotation + (progress * 360);

            return Positioned(
              left:
                  (confetti.startX + xWobble) *
                  MediaQuery.of(context).size.width,
              top:
                  (confetti.startY + yOffset) *
                  MediaQuery.of(context).size.height,
              child: Transform.rotate(
                angle: rotation * pi / 180,
                child: Container(
                  width: confetti.size,
                  height: confetti.size * 0.6,
                  decoration: BoxDecoration(
                    color: confetti.color.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCelebrateOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Lottie.asset(
          'assets/images/celebrate.json',
          fit: BoxFit.cover,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }

  Widget _buildCelebrationBurst() {
    if (!_isCelebrating) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _celebrationAnimation,
      builder: (context, child) {
        final progress = _celebrationAnimation.value;

        return Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              children: List.generate(20, (index) {
                final angle = (index / 20) * 2 * pi;
                final distance = 150 * progress;
                final x =
                    MediaQuery.of(context).size.width / 2 +
                    cos(angle) * distance;
                final y =
                    MediaQuery.of(context).size.height * 0.6 +
                    sin(angle) * distance;
                final opacity = (1 - progress).clamp(0.0, 1.0);

                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: 0.5 + (progress * 1.5),
                      child: Icon(
                        index % 3 == 0
                            ? Icons.favorite
                            : (index % 3 == 1 ? Icons.star : Icons.celebration),
                        size: 24,
                        color: index % 2 == 0
                            ? const Color(0xFFFFA6C9)
                            : const Color(0xFFE1BEE7),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 60.h),

          // Character with glow effect
          Expanded(child: Center(child: _buildCharacterSection())),

          // Birthday message card
          _buildMessageCard(),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildCharacterSection() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow layers
              _buildGlowCircle(180.r, 0.1 * _glowAnimation.value),
              _buildGlowCircle(160.r, 0.15 * _glowAnimation.value),
              _buildGlowCircle(140.r, 0.2 * _glowAnimation.value),
              _buildGlowCircle(120.r, 0.3 * _glowAnimation.value),

              // Character container
              Container(
                width: 200.r,
                height: 280.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
                child: _buildCharacter(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlowCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFF8BBD9).withOpacity(opacity),
            const Color(0xFFE1BEE7).withOpacity(opacity * 0.5),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildCharacter() {
    return Lottie.asset(
      'assets/images/Birthday_Gifts.json',
      width: 250.r,
      height: 250.r,
      fit: BoxFit.contain,
      repeat: true,
      animate: true,
    );
  }

  Widget _buildMessageCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Happy Birthday text
          Text(
            'Happy Birthday,',
            style: GoogleFonts.dancingScript(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            widget.recipientName,
            style: GoogleFonts.dancingScript(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF8BBD9),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Send Love button - Cute animated style
          GestureDetector(
            onTap: _triggerCelebration,
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.5,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFA6C9), // Pastel pink
                          Color(0xFFE1BEE7), // Pastel lavender
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFA6C9).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: const Color(0xFFE1BEE7).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Heart icon
                        Icon(Icons.favorite, color: Colors.white, size: 20.r),
                        SizedBox(width: 8.w),

                        // Text
                        Text(
                          'Celebrate',
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // Gift icon
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (widget.senderName != null) ...[
            SizedBox(height: 16.h),
            Text(
              'With love from ${widget.senderName}',
              style: GoogleFonts.dmSans(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Data class for floating hearts
class FloatingHeart {
  final double startX;
  final double startY;
  final double size;
  final double speed;
  final double delay;
  final double opacity;
  final Color color;

  FloatingHeart({
    required this.startX,
    required this.startY,
    required this.size,
    required this.speed,
    required this.delay,
    required this.opacity,
    required this.color,
  });
}

// Data class for confetti
class Confetti {
  final double startX;
  final double startY;
  final double size;
  final double speed;
  final double delay;
  final Color color;
  final double rotation;

  Confetti({
    required this.startX,
    required this.startY,
    required this.size,
    required this.speed,
    required this.delay,
    required this.color,
    required this.rotation,
  });
}

// Background pattern painter
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Draw subtle circular patterns
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.1 + i * 0.2);
      final y = size.height * (0.2 + (i % 3) * 0.3);
      canvas.drawCircle(Offset(x, y), 80 + i * 20, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// String lights painter
class StringLightsPainter extends CustomPainter {
  final double glowIntensity;

  StringLightsPainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw the string
    final path = Path();
    path.moveTo(0, 20);

    int lightCount = 12;
    double segmentWidth = size.width / (lightCount - 1);

    for (int i = 0; i < lightCount; i++) {
      double x = i * segmentWidth;
      double y = 20 + sin(i * 0.8) * 8;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw light bulb
      final bulbPaint = Paint()
        ..color = Color.lerp(
          const Color(0xFFFFF8E1),
          const Color(0xFFFFE082),
          glowIntensity,
        )!.withOpacity(0.8 * glowIntensity)
        ..style = PaintingStyle.fill;

      // Glow effect
      final glowPaint = Paint()
        ..color = const Color(0xFFFFE082).withOpacity(0.3 * glowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(x, y + 10), 6, glowPaint);
      canvas.drawCircle(Offset(x, y + 10), 4, bulbPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant StringLightsPainter oldDelegate) {
    return oldDelegate.glowIntensity != glowIntensity;
  }
}
