import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:flutter/material.dart';

class CustomSkewCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final Gradient gradient;
  final double width;
  final double height;
  final String image;
  final bool isRightSkew;

  const CustomSkewCard({
    super.key,
    required this.title,
    this.subTitle = '532 Titles',
    required this.gradient,
    this.width = 170,
    this.height = 150,
    required this.image,
    this.isRightSkew = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height + 20, // Add space for overflow
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(width, height),
              painter: _SkewedPainter(
                gradient: gradient,
                isRightSkew: isRightSkew,
              ),
            ),
          ),

          Positioned(
            left: !isRightSkew ? -30 : null,
            right: isRightSkew ? -5 : null,
            top: !isRightSkew ? -10 : -35,
            bottom: 0, // Keep anchor to bottom
            child: Image.asset(image, fit: BoxFit.cover),
          ),

          Positioned(
            right: !isRightSkew ? 20 : null,
            left: isRightSkew ? 20 : null,
            top: 40,
            child: Column(
              crossAxisAlignment: isRightSkew
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextApp(
                  title: title,
                  size: 20,
                  color: AppColors.kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
                Spacing.verticalSpace(35),
                MyTextApp(
                  title: subTitle,
                  size: 14,
                  color: AppColors.kWhiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkewedPainter extends CustomPainter {
  final Gradient gradient;
  final bool isRightSkew;

  _SkewedPainter({required this.gradient, required this.isRightSkew});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTRB(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final path = Path();
    const double radius = 20.0;
    const double skewDrop = 20.0;

    // Determine the Y offset for Top-Left and Top-Right based on skew direction
    // If isRightSkew (Standard): Top-Left is high (0), Top-Right is low (skewDrop)
    // If !isRightSkew (Mirrored): Top-Left is low (skewDrop), Top-Right is high (0)
    final double topLeftY = isRightSkew ? 0 : skewDrop;
    final double topRightY = isRightSkew ? skewDrop : 0;

    // Start Top-Left (after corner)
    path.moveTo(radius, topLeftY);

    // Line to Top-Right (before corner)
    path.lineTo(size.width - radius, topRightY);

    // Top-Right Corner
    path.quadraticBezierTo(
      size.width,
      topRightY,
      size.width,
      topRightY + radius,
    );

    // Line to Bottom-Right (before corner)
    path.lineTo(size.width, size.height - radius);

    // Bottom-Right Corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );

    // Line to Bottom-Left (before corner)
    path.lineTo(radius, size.height);

    // Bottom-Left Corner
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    // Line to Top-Left (before corner)
    path.lineTo(0, topLeftY + radius);

    // Top-Left Corner
    path.quadraticBezierTo(0, topLeftY, radius, topLeftY);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
