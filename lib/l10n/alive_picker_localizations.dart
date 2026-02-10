import 'package:flutter/material.dart';

class AlivePickerLocalizations {
  final Locale locale;

  const AlivePickerLocalizations(this.locale);

  static AlivePickerLocalizations of(BuildContext context) {
    return Localizations.of<AlivePickerLocalizations>(
          context,
          AlivePickerLocalizations,
        ) ??
        const AlivePickerLocalizations(Locale('en'));
  }

  static const LocalizationsDelegate<AlivePickerLocalizations> delegate =
      _AlivePickerLocalizationsDelegate();

  static const _localizedValues = <String, Map<String, dynamic>>{
    'en': {
      'selectYear': 'Select Year',
      'selectMonth': 'Select Month',
      'selectDay': 'Select Day',
      'hour': 'Hour',
      'minute': 'Minute',
      'cancel': 'Cancel',
      'ok': 'OK',
      'winter': 'Winter',
      'spring': 'Spring',
      'summer': 'Summer',
      'autumn': 'Autumn',
      'winterMonths': 'Dec - Feb',
      'springMonths': 'Mar - May',
      'summerMonths': 'Jun - Aug',
      'autumnMonths': 'Sep - Nov',
      'monthNames': <String>[
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
    },
    'ar': {
      'selectYear': 'اختر السنة',
      'selectMonth': 'اختر الشهر',
      'selectDay': 'اختر اليوم',
      'hour': 'ساعة',
      'minute': 'دقيقة',
      'cancel': 'إلغاء',
      'ok': 'موافق',
      'winter': 'شتاء',
      'spring': 'ربيع',
      'summer': 'صيف',
      'autumn': 'خريف',
      'winterMonths': 'ديسمبر - فبراير',
      'springMonths': 'مارس - مايو',
      'summerMonths': 'يونيو - أغسطس',
      'autumnMonths': 'سبتمبر - نوفمبر',
      'monthNames': <String>[
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ],
    },
  };

  String get selectYear {
    return _localizedValues[locale.languageCode]?['selectYear'] as String? ??
        'Select Year';
  }

  String get selectMonth {
    return _localizedValues[locale.languageCode]?['selectMonth'] as String? ??
        'Select Month';
  }

  String get selectDay {
    return _localizedValues[locale.languageCode]?['selectDay'] as String? ??
        'Select Day';
  }

  String get hour {
    return _localizedValues[locale.languageCode]?['hour'] as String? ?? 'Hour';
  }

  String get minute {
    return _localizedValues[locale.languageCode]?['minute'] as String? ??
        'Minute';
  }

  String get cancel {
    return _localizedValues[locale.languageCode]?['cancel'] as String? ??
        'Cancel';
  }

  String get ok {
    return _localizedValues[locale.languageCode]?['ok'] as String? ?? 'OK';
  }

  String get winter {
    return _localizedValues[locale.languageCode]?['winter'] as String? ??
        'Winter';
  }

  String get spring {
    return _localizedValues[locale.languageCode]?['spring'] as String? ??
        'Spring';
  }

  String get summer {
    return _localizedValues[locale.languageCode]?['summer'] as String? ??
        'Summer';
  }

  String get autumn {
    return _localizedValues[locale.languageCode]?['autumn'] as String? ??
        'Autumn';
  }

  String get winterMonths {
    return _localizedValues[locale.languageCode]?['winterMonths'] as String? ??
        'Dec - Feb';
  }

  String get springMonths {
    return _localizedValues[locale.languageCode]?['springMonths'] as String? ??
        'Mar - May';
  }

  String get summerMonths {
    return _localizedValues[locale.languageCode]?['summerMonths'] as String? ??
        'Jun - Aug';
  }

  String get autumnMonths {
    return _localizedValues[locale.languageCode]?['autumnMonths'] as String? ??
        'Sep - Nov';
  }

  List<String> get monthNames {
    final names = _localizedValues[locale.languageCode]?['monthNames'];
    if (names != null) {
      return (names as List).cast<String>();
    }
    return (_localizedValues['en']!['monthNames'] as List).cast<String>();
  }
}

class _AlivePickerLocalizationsDelegate
    extends LocalizationsDelegate<AlivePickerLocalizations> {
  const _AlivePickerLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AlivePickerLocalizations> load(Locale locale) {
    return Future.value(AlivePickerLocalizations(locale));
  }

  @override
  bool shouldReload(_AlivePickerLocalizationsDelegate old) => false;
}
