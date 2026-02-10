import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_fit/features/liqwed_swip/ui/widgets/liqwed_swip_text.dart';

class LiqwedSwipScreen extends StatefulWidget {
  const LiqwedSwipScreen({super.key});

  @override
  State<LiqwedSwipScreen> createState() => _LiqwedSwipScreenState();
}

class _LiqwedSwipScreenState extends State<LiqwedSwipScreen> {
  final LiquidController _liquidController = LiquidController();

  // Colors from user request
  final List<Color> _colors = [
    const Color(0xFFE6F3FF), // Dog - Matches Image Background
    const Color(0xFFF0E6FF), // Elephant - Matches Image Background
    const Color(
      0xFFF2F7F2,
    ), // Goat/Goat - Light Mint/Grey (Approximated for Goat)
    const Color(0xFFFDF2E9), // Sheep - Matches Image Background
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildPage(
        color: _colors[0],
        title: "Happy Puppy!",
        description:
            "Meet your new best friend! This playful puppy is ready to run, jump, and go on a big adventure with you!",
        imagePath: "assets/liqwed/dog.png",
        icon: Icons.pets,
      ),
      _buildPage(
        color: _colors[1],
        title: "Giant Hugs!",
        description:
            "Meet the gentle elephant! She gives the biggest, softest hugs and is here to tell you wonderful stories.",
        imagePath: "assets/liqwed/elephant.png",
        icon: Icons.bubble_chart,
      ),
      _buildPage(
        color: _colors[2],
        title: "Silly Goat!",
        description:
            "This curious goat loves to climb high mountains and show you all the secret paths to Amazing Land!",
        imagePath: "assets/liqwed/goat.png",
        icon: Icons.nature_people,
        imageHeight: 500.h,
      ),
      _buildPage(
        color: _colors[3],
        title: "Fluffy Clouds!",
        description:
            "Meet the softest sheep ever! He's as fluffy as a cloud and loves to help you have the sweetest dreams.",
        imagePath: "assets/liqwed/sheep.png",
        icon: Icons.cloud,
        imageHeight: 500.h,
      ),
    ];

    return Scaffold(
      body: LiquidSwipe(
        pages: pages,
        fullTransitionValue: 880,
        enableSideReveal: true,
        preferDragFromRevealedArea: true,
        enableLoop: true,
        liquidController: _liquidController,
        waveType: WaveType.liquidReveal,
        positionSlideIcon: 0.8,
        slideIconWidget: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildPage({
    required Color color,
    required String title,
    required String description,
    required String imagePath,
    required IconData icon,
    double? imageHeight,
  }) {
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Center(
              child: Image.asset(
                imagePath,
                height: imageHeight ?? 420.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          LiqwedSwipText(
            title: title,
            description: description,
            color: color,
            onTap: () {},
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
