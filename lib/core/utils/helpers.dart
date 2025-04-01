import 'package:intl/intl.dart';

class AppHelpers {
  static final _currencyFormat = NumberFormat.currency(
    symbol: 'ر.س',
    decimalDigits: 2,
    locale: 'ar_SA',
  );

  static final _dateFormat = DateFormat('yyyy/MM/dd', 'ar_SA');
  static final _timeFormat = DateFormat('hh:mm a', 'ar_SA');

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatDate(DateTime date, {String? format}) {
    return format != null
        ? DateFormat(format, 'ar_SA').format(date)
        : _dateFormat.format(date);
  }

  static String formatTime(DateTime time, {String? format}) {
    return format != null
        ? DateFormat(format, 'ar_SA').format(time)
        : _timeFormat.format(time);
  }

  static String truncateWithEllipsis(String text, int maxLength) {
    assert(maxLength > 0, 'maxLength must be greater than 0');
    return text.length <= maxLength
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  static bool isLargeService(String serviceName) {
    return serviceName.toLowerCase().contains('لارج');
  }

  static bool isExcludedContact(String contactName) {
    const excludedContacts = {
      'د/ محمد صيدلية بيش',
      'عيادة الأنعام - الإدارة',
      'مؤسسة علي محمد غروي البيطرية',
      'صيدليه علي محمد غروي',
      'عيادة الانعام الظبية',
    };
    return excludedContacts.contains(contactName.trim());
  }

  static String getDatabaseName(String fullName) {
    if (fullName.contains('خميس مشيط')) return 'Elnam-KhamisMushit';
    if (fullName.contains('بيش')) return 'Elnam-Baish';
    if (fullName.contains('الظبية')) return 'Elnam-Zapia';
    return fullName;
  }

  static Future<void> delay([int milliseconds = 500]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}