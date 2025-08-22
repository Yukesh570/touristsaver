// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class LocaleModel {
  final String name;
  final Locale locale;
  final String imagePath;

  const LocaleModel(
      {required this.name, required this.locale, required this.imagePath});
}

class L10n {
  static List<LocaleModel> all = [
    const LocaleModel(
        name: 'English',
        locale: Locale('en'),
        imagePath: 'assets/images/en.png'),
    const LocaleModel(
        name: 'Malay', locale: Locale('ms'), imagePath: 'assets/images/ms.png'),
    const LocaleModel(
        name: 'Nepali',
        locale: Locale('ne'),
        imagePath: 'assets/images/ne.png'),
    const LocaleModel(
        name: 'Thai', locale: Locale('th'), imagePath: 'assets/images/th.png'),
    const LocaleModel(
        name: 'Afrikaans',
        locale: Locale('af'),
        imagePath: 'assets/images/af.png'),
    // const LocaleModel(
    //     name: 'Indonesian',
    //     locale: Locale('id'),
    //     imagePath: 'assets/images/id.png'),
    // const LocaleModel(
    //     name: 'Khmer', locale: Locale('km'), imagePath: 'assets/images/km.png'),
    // const LocaleModel(
    //     name: 'Vietnamese',
    //     locale: Locale('vi'),
    //     imagePath: 'assets/images/vi.png'),
    // const LocaleModel(
    //     name: 'Lao', locale: Locale('lo'), imagePath: 'assets/images/lo.png'),
  ];
}
