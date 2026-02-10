import '../models/form_field_option.dart';
import '../models/localized_text.dart';

class StaticOptionsProvider {
  static List<FormFieldOption> getOptions(String model) {
    switch (model) {
      case 'Modules\\Utilities\\Models\\Term':
        return _getProjectObjectives();

      default:
        return [];
    }
  }

  static List<FormFieldOption> _getProjectObjectives() {
    return [
      const FormFieldOption(
        value: '1',
        label: LocalizedText(en: 'New Construction', ar: 'بناء جديد'),
      ),
      const FormFieldOption(
        value: '2',
        label: LocalizedText(en: 'Renovation', ar: 'تجديد'),
      ),
      const FormFieldOption(
        value: '3',
        label: LocalizedText(en: 'Extension', ar: 'توسعة'),
      ),
      const FormFieldOption(
        value: '4',
        label: LocalizedText(en: 'Maintenance', ar: 'صيانة'),
      ),
      const FormFieldOption(
        value: '5',
        label: LocalizedText(en: 'Demolition', ar: 'هدم'),
      ),
    ];
  }

  static bool hasOptions(String model) {
    return getOptions(model).isNotEmpty;
  }
}
