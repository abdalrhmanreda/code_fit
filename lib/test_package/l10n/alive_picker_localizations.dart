import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class AlivePickerLocalizations {
  static AlivePickerLocalizations of(BuildContext context) {
    return Localizations.of<AlivePickerLocalizations>(
          context,
          AlivePickerLocalizations,
        ) ??
        AlivePickerLocalizationsEn();
  }

  static const LocalizationsDelegate<AlivePickerLocalizations> delegate =
      _AlivePickerLocalizationsDelegate();

  String get selectYear;
  String get selectMonth;
  String get selectDay;
  String get selectDate;
  String get hour;
  String get minute;
  String get ok;
  String get cancel;

  // Seasons
  String get winter;
  String get spring;
  String get summer;
  String get autumn;

  // Season Months
  String get winterMonths;
  String get springMonths;
  String get summerMonths;
  String get autumnMonths;

  List<String> get monthNames;
}

class AlivePickerLocalizationsEn extends AlivePickerLocalizations {
  @override
  String get selectYear => 'Select Year';
  @override
  String get selectMonth => 'Select Month';
  @override
  String get selectDay => 'Select Day';
  @override
  String get selectDate => 'Select Date';
  @override
  String get hour => 'Hour';
  @override
  String get minute => 'Minute';
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'CANCEL';

  @override
  String get winter => 'Winter';
  @override
  String get spring => 'Spring';
  @override
  String get summer => 'Summer';
  @override
  String get autumn => 'Autumn';

  @override
  String get winterMonths => 'Dec - Feb';
  @override
  String get springMonths => 'Mar - May';
  @override
  String get summerMonths => 'Jun - Aug';
  @override
  String get autumnMonths => 'Sep - Nov';

  @override
  List<String> get monthNames => [
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
  ];
}

class AlivePickerLocalizationsAr extends AlivePickerLocalizations {
  @override
  String get selectYear => 'اختر السنة';
  @override
  String get selectMonth => 'اختر الشهر';
  @override
  String get selectDay => 'اختر اليوم';
  @override
  String get selectDate => 'اختر التاريخ';
  @override
  String get hour => 'ساعة';
  @override
  String get minute => 'دقيقة';
  @override
  String get ok => 'موافق';
  @override
  String get cancel => 'إلغاء';

  @override
  String get winter => 'الشتاء';
  @override
  String get spring => 'الربيع';
  @override
  String get summer => 'الصيف';
  @override
  String get autumn => 'الخريف';

  @override
  String get winterMonths => 'ديسمبر - فبراير';
  @override
  String get springMonths => 'مارس - مايو';
  @override
  String get summerMonths => 'يونيو - أغسطس';
  @override
  String get autumnMonths => 'سبتمبر - نوفمبر';

  @override
  List<String> get monthNames => [
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
  ];
}

class AlivePickerLocalizationsFr extends AlivePickerLocalizations {
  @override
  String get selectYear => 'Choisir l\'année';
  @override
  String get selectMonth => 'Choisir le mois';
  @override
  String get selectDay => 'Choisir le jour';
  @override
  String get selectDate => 'Choisir la date';
  @override
  String get hour => 'Heure';
  @override
  String get minute => 'Minute';
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'ANNULER';

  @override
  String get winter => 'Hiver';
  @override
  String get spring => 'Printemps';
  @override
  String get summer => 'Été';
  @override
  String get autumn => 'Automne';

  @override
  String get winterMonths => 'Déc - Fév';
  @override
  String get springMonths => 'Mar - Mai';
  @override
  String get summerMonths => 'Juin - Août';
  @override
  String get autumnMonths => 'Sep - Nov';

  @override
  List<String> get monthNames => [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ];
}

class _AlivePickerLocalizationsDelegate
    extends LocalizationsDelegate<AlivePickerLocalizations> {
  const _AlivePickerLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'fr'].contains(locale.languageCode);

  @override
  Future<AlivePickerLocalizations> load(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return SynchronousFuture(AlivePickerLocalizationsAr());
      case 'fr':
        return SynchronousFuture(AlivePickerLocalizationsFr());
      default:
        return SynchronousFuture(AlivePickerLocalizationsEn());
    }
  }

  @override
  bool shouldReload(_AlivePickerLocalizationsDelegate old) => false;
}
