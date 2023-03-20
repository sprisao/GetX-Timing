class DateTimeUtils {
  static DateTime roundToNearest(DateTime dateTime, int interval) {
    int minutes = dateTime.minute;
    int roundedMinutes = (minutes ~/ interval) * interval;
    return dateTime.subtract(Duration(minutes: minutes - roundedMinutes));
  }
}
