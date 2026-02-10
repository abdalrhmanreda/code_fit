import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientTitle extends StatelessWidget {
  final String text;

  const GradientTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, Color(0xFFF0F0F0)],
      ).createShader(bounds),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
