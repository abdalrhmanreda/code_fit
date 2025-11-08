import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Header widget for roadmap screen
class RoadmapHeaderWidget extends StatelessWidget {
  final String userName;
  final int level;
  final String language;

  const RoadmapHeaderWidget({
    Key? key,
    required this.userName,
    required this.level,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greeting = language == 'ar' ? 'مرحبًا' : 'Welcome';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSmall),
        Text(
          language == 'ar' ? 'المستوى $level' : 'Level $level',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
