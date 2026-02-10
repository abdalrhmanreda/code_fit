import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/colors/app_colors.dart';
import '../../../../core/utils/app_button.dart';
import '../../data/models/api_response.dart';
import '../screens/dynamic_form_screen.dart';

import '../widgets/demo_feature_item.dart';

class DynamicFormDemoScreen extends StatelessWidget {
  const DynamicFormDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Dynamic Form Engine Demo',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),

              Text(
                'This demo showcases a fully dynamic multi-step form engine that renders forms based on JSON schema.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32.h),

              const DemoFeatureItem(
                icon: Icons.layers_outlined,
                title: 'Multi-Step Navigation',
                description: 'Navigate through form steps with validation',
              ),
              SizedBox(height: 16.h),
              const DemoFeatureItem(
                icon: Icons.check_circle_outline,
                title: 'Field Validation',
                description: 'Required, email, min/max, numeric, and more',
              ),
              SizedBox(height: 16.h),
              const DemoFeatureItem(
                icon: Icons.language,
                title: 'Bilingual Support',
                description: 'Arabic and English localization',
              ),
              SizedBox(height: 16.h),
              const DemoFeatureItem(
                icon: Icons.repeat,
                title: 'Repeatable Fields',
                description: 'Dynamic add/remove field instances',
              ),
              SizedBox(height: 16.h),
              const DemoFeatureItem(
                icon: Icons.widgets_outlined,
                title: 'Multiple Field Types',
                description: 'Text, Select, Radio, Checkbox, File, Groups',
              ),

              SizedBox(height: 32.h),

              AppButton(
                type: AppButtonType.elevated,
                onPressed: () => _loadAndShowForm(context, 'en'),
                text: 'Open Form (English)',
                borderRadius: 26,
                height: 56,
                backgroundColor: AppColors.kPrimary,
                foregroundColor: AppColors.kWhiteColor,
              ),

              SizedBox(height: 12.h),

              AppButton(
                type: AppButtonType.outlined,
                backgroundColor: AppColors.kWhiteColor,
                onPressed: () => _loadAndShowForm(context, 'ar'),
                text: 'فتح النموذج (عربي)',
                elevation: 0,
                borderRadius: 26,
                borderWidth: 1,
                height: 56,
                borderColor: AppColors.kGrayColor.withValues(alpha: 0.5),
                foregroundColor: AppColors.kPrimary,
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadAndShowForm(BuildContext context, String locale) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final jsonString = await rootBundle.loadString(
        'assets/data/sample-response.json',
      );
      final jsonData = json.decode(jsonString);

      final apiResponse = ApiResponse.fromJson(jsonData);

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (context.mounted && apiResponse.data?.form != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DynamicFormScreen(
              formSchema: apiResponse.data!.form!,
              locale: locale,
              onSubmit: (data) {
                print('Form submitted with data: $data');
              },
            ),
          ),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No form found in API response')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading form: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
