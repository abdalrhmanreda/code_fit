import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/form_field_model.dart';

import '../../../../config/colors/app_colors.dart';

class DynamicFileField extends StatelessWidget {
  final FormFieldModel field;
  final dynamic value;
  final String? errorText;
  final Function(dynamic) onChanged;
  final String locale;

  const DynamicFileField({
    super.key,
    required this.field,
    this.value,
    this.errorText,
    required this.onChanged,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = locale.startsWith('ar');
    final label = field.label.getLocalized(locale);
    final hasFiles =
        value != null &&
        ((value is List && (value as List).isNotEmpty) ||
            (value is String && (value as String).isNotEmpty));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: RichText(
              text: TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                children: [
                  if (field.isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
          ),

        InkWell(
          onTap: () => _pickFile(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: errorText != null
                    ? AppColors.error
                    : AppColors.kGrayColor.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.kWhiteColor,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48.sp,
                  color: AppColors.kPrimary,
                ),
                SizedBox(height: 8.h),
                Text(
                  hasFiles
                      ? (isRtl ? 'تم اختيار الملفات' : 'Files selected')
                      : (isRtl
                            ? 'اضغط لاختيار الملفات'
                            : 'Tap to select files'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (field.multiple)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      isRtl
                          ? 'يمكنك اختيار عدة ملفات'
                          : 'Multiple files allowed',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (hasFiles)
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: _buildFilesList(context, isRtl),
          ),

        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h),
            child: Text(
              errorText!,
              style: TextStyle(fontSize: 12.sp, color: AppColors.error),
            ),
          ),
      ],
    );
  }

  Widget _buildFilesList(BuildContext context, bool isRtl) {
    List<String> files;
    if (value is List) {
      files = (value as List).cast<String>();
    } else if (value is String) {
      files = [value as String];
    } else {
      files = [];
    }

    return Column(
      children: files.map((filePath) {
        final fileName = filePath.split('/').last;
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.insert_drive_file,
                size: 20.sp,
                color: AppColors.kPrimary,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(fontSize: 13.sp, color: AppColors.kPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18.sp, color: AppColors.kPrimary),
                onPressed: () => _removeFile(filePath),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _pickFile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          locale.startsWith('ar') ? 'اختيار الملفات' : 'File Selection',
        ),
        content: Text(
          locale.startsWith('ar')
              ? 'قم بدمج مكتبة file_picker أو image_picker لاختيار الملفات'
              : 'Integrate file_picker or image_picker package for file selection',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              if (field.multiple) {
                onChanged(['file1.pdf', 'file2.pdf']);
              } else {
                onChanged('document.pdf');
              }
            },
            child: Text(locale.startsWith('ar') ? 'موافق' : 'OK'),
          ),
        ],
      ),
    );
  }

  void _removeFile(String filePath) {
    if (value is List) {
      final files = List<String>.from(value as List);
      files.remove(filePath);
      onChanged(files);
    } else {
      onChanged(null);
    }
  }
}
