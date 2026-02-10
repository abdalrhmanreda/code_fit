class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});

  factory ValidationResult.valid() {
    return const ValidationResult(isValid: true);
  }

  factory ValidationResult.invalid(String message) {
    return ValidationResult(isValid: false, errorMessage: message);
  }
}

class FormValidator {
  static ValidationResult validate({
    required String? value,
    required String? rules,
    required String fieldLabel,
    String locale = 'en',
  }) {
    if (rules == null || rules.isEmpty) {
      return ValidationResult.valid();
    }

    final rulesList = rules.split('|');

    for (final rule in rulesList) {
      final result = _validateRule(
        value: value,
        rule: rule.trim(),
        fieldLabel: fieldLabel,
        locale: locale,
      );

      if (!result.isValid) {
        return result;
      }
    }

    return ValidationResult.valid();
  }

  /// Validate a single rule
  static ValidationResult _validateRule({
    required String? value,
    required String rule,
    required String fieldLabel,
    required String locale,
  }) {
    // Required rule
    if (rule == 'required') {
      if (value == null || value.trim().isEmpty) {
        return ValidationResult.invalid(
          _getErrorMessage('required', fieldLabel, locale),
        );
      }
    }

    // Email rule
    if (rule == 'email') {
      if (value != null && value.isNotEmpty) {
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(value)) {
          return ValidationResult.invalid(
            _getErrorMessage('email', fieldLabel, locale),
          );
        }
      }
    }

    // Min length rule
    if (rule.startsWith('min:')) {
      final minLength = int.tryParse(rule.split(':')[1]) ?? 0;
      if (value != null && value.length < minLength) {
        return ValidationResult.invalid(
          _getErrorMessage('min', fieldLabel, locale, minLength),
        );
      }
    }

    // Max length rule
    if (rule.startsWith('max:')) {
      final maxLength = int.tryParse(rule.split(':')[1]) ?? 0;
      if (value != null && value.length > maxLength) {
        return ValidationResult.invalid(
          _getErrorMessage('max', fieldLabel, locale, maxLength),
        );
      }
    }

    // Numeric rule
    if (rule == 'numeric') {
      if (value != null && value.isNotEmpty) {
        if (double.tryParse(value) == null) {
          return ValidationResult.invalid(
            _getErrorMessage('numeric', fieldLabel, locale),
          );
        }
      }
    }

    // URL rule
    if (rule == 'url') {
      if (value != null && value.isNotEmpty) {
        final urlRegex = RegExp(
          r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
        );
        if (!urlRegex.hasMatch(value)) {
          return ValidationResult.invalid(
            _getErrorMessage('url', fieldLabel, locale),
          );
        }
      }
    }

    // Phone rule (basic)
    if (rule == 'phone') {
      if (value != null && value.isNotEmpty) {
        final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
        if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
          return ValidationResult.invalid(
            _getErrorMessage('phone', fieldLabel, locale),
          );
        }
      }
    }

    return ValidationResult.valid();
  }

  /// Get localized error message
  static String _getErrorMessage(
    String ruleType,
    String fieldLabel,
    String locale, [
    int? value,
  ]) {
    final isArabic = locale.startsWith('ar');

    switch (ruleType) {
      case 'required':
        return isArabic ? '$fieldLabel مطلوب' : '$fieldLabel is required';

      case 'email':
        return isArabic
            ? 'يرجى إدخال بريد إلكتروني صحيح'
            : 'Please enter a valid email';

      case 'min':
        return isArabic
            ? '$fieldLabel يجب أن يكون على الأقل $value حرف'
            : '$fieldLabel must be at least $value characters';

      case 'max':
        return isArabic
            ? '$fieldLabel يجب ألا يتجاوز $value حرف'
            : '$fieldLabel must not exceed $value characters';

      case 'numeric':
        return isArabic
            ? '$fieldLabel يجب أن يكون رقماً'
            : '$fieldLabel must be a number';

      case 'url':
        return isArabic ? 'يرجى إدخال رابط صحيح' : 'Please enter a valid URL';

      case 'phone':
        return isArabic
            ? 'يرجى إدخال رقم هاتف صحيح'
            : 'Please enter a valid phone number';

      default:
        return isArabic ? '$fieldLabel غير صحيح' : '$fieldLabel is invalid';
    }
  }

  /// Validate list of values (for multiple selects, checkboxes)
  static ValidationResult validateList({
    required List<String>? values,
    required bool isRequired,
    required String fieldLabel,
    String locale = 'en',
  }) {
    if (isRequired && (values == null || values.isEmpty)) {
      final isArabic = locale.startsWith('ar');
      return ValidationResult.invalid(
        isArabic ? '$fieldLabel مطلوب' : '$fieldLabel is required',
      );
    }
    return ValidationResult.valid();
  }

  /// Validate file
  static ValidationResult validateFile({
    required dynamic file,
    required bool isRequired,
    required String fieldLabel,
    String locale = 'en',
  }) {
    if (isRequired && file == null) {
      final isArabic = locale.startsWith('ar');
      return ValidationResult.invalid(
        isArabic ? '$fieldLabel مطلوب' : '$fieldLabel is required',
      );
    }
    return ValidationResult.valid();
  }
}
