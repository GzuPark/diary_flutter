class Utils {
  static int getFormatTime(DateTime date) {
    return int.parse(
        "${date.year}${makeTwoDigit(date.month)}${makeTwoDigit(date.day)}");
  }

  static DateTime numToDateTime(int date) {
    String _d = date.toString();

    int year = int.parse(_d.substring(0, 4));
    int month = int.parse(_d.substring(4, 6));
    int day = int.parse(_d.substring(6, 8));

    return DateTime(year, month, day);
  }

  static String makeTwoDigit(int num) {
    // 월, 일의 자리수를 항상 2자리로 유지
    return num.toString().padLeft(2, "0");
  }
}
