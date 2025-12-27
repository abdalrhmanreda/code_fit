import 'package:code_fit/config/colors/app_colors.dart';
import 'package:code_fit/core/helpers/font_weight_helper.dart';
import 'package:code_fit/core/helpers/spacing.dart';
import 'package:code_fit/core/utils/app_text.dart';
import 'package:code_fit/features/movie/widgets/custom_skew_card.dart';
import 'package:flutter/material.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextApp(
          title: 'Categories',
          size: 20,
          fontWeight: FontWeightHelper.semiBold,
          color: AppColors.kWhiteColor,
        ),
        Spacing.verticalSpace(16),
        Row(
          children: [
            Expanded(
              child: CustomSkewCard(
                title: 'Movies',
                subTitle: '532 Titles',
                isRightSkew: false,
                image: 'assets/images/sipder.png',
                gradient: const LinearGradient(
                  colors: [Color(0xFF16CAF1), Color(0xFF0143A7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Spacing.horizontalSpace(12),
            Expanded(
              child: CustomSkewCard(
                title: 'Animes',
                subTitle: '532 Titles',
                isRightSkew: true,
                image: 'assets/images/anime.png',
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF2E2E), Color(0xFFE08939)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
