import 'package:code_fit/core/utils/app_text.dart';
import 'package:flutter/material.dart';

class MovieDescriptionSection extends StatefulWidget {
  final String description;

  const MovieDescriptionSection({super.key, required this.description});

  @override
  State<MovieDescriptionSection> createState() =>
      _MovieDescriptionSectionState();
}

class _MovieDescriptionSectionState extends State<MovieDescriptionSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextApp(
          title: widget.description
              .replaceAll('<br>', ' ')
              .replaceAll('<i>', '')
              .replaceAll('</i>', ''),
          size: 14,
          color: Colors.grey.shade400,
          height: 1.5,
          maxLines: isExpanded ? null : 5,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "Read less" : "Read more",
            style: const TextStyle(
              color: Color(0xFFCC00FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
