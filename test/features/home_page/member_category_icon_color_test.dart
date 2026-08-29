import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/features/home_page/widget/tab_container.dart';

void main() {
  test('member category icons use the approved rust tint', () {
    expect(memberCategoryIconColor, const Color(0xFFD81b60));
  });
}
