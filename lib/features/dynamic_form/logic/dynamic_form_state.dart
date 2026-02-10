import '../data/models/form_schema.dart';

/// State for the dynamic form
class DynamicFormState {
  final int currentStep;
  final int totalSteps;
  final Map<String, dynamic> formData;
  final Map<String, String> validationErrors;
  final FormSchema? formSchema;
  final bool isLoading;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? errorMessage;

  const DynamicFormState({
    this.currentStep = 0,
    this.totalSteps = 0,
    this.formData = const {},
    this.validationErrors = const {},
    this.formSchema,
    this.isLoading = false,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.errorMessage,
  });

  /// Check if current step is the first step
  bool get isFirstStep => currentStep == 0;

  /// Check if current step is the last step
  bool get isLastStep => currentStep == totalSteps - 1;

  /// Check if form can go to next step (no validation errors)
  bool get canGoNext => validationErrors.isEmpty;

  /// Get progress percentage
  double get progress => totalSteps > 0 ? (currentStep + 1) / totalSteps : 0;

  DynamicFormState copyWith({
    int? currentStep,
    int? totalSteps,
    Map<String, dynamic>? formData,
    Map<String, String>? validationErrors,
    FormSchema? formSchema,
    bool? isLoading,
    bool? isSubmitting,
    bool? isSubmitted,
    String? errorMessage,
  }) {
    return DynamicFormState(
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      formData: formData ?? this.formData,
      validationErrors: validationErrors ?? this.validationErrors,
      formSchema: formSchema ?? this.formSchema,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
