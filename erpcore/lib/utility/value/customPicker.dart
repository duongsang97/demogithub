import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';

class CustomPicker extends TimePickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale, int indexMinute = 4}) : super(locale: locale, showSecondsColumn: false) {
    this.currentTime = currentTime ?? DateTime.now();
    setLeftIndex(this.currentTime.hour);
    setMiddleIndex(indexMinute);
    setRightIndex(this.currentTime.second);
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 4) {
      switch (index) {
        case 0:
          return digits(0, 2);
        case 1:
          return digits(15, 2);
        case 2:
          return digits(30, 2);
        case 3:
          return digits(45, 2);
        default:
          return digits(index, 2);
      }
    } else {
      return null;
    }
  }

  @override
  DateTime finalTime() {
    int minute = 0;
    switch (currentMiddleIndex()) {
        case 0:
          minute = 0;
          break;
        case 1:
          minute = 15;
          break;
        case 2:
          minute = 30;
          break;
        case 3:
          minute = 45;
          break;
        default:
      }
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
            currentLeftIndex(), minute)
        : DateTime(currentTime.year, currentTime.month, currentTime.day,
            currentLeftIndex(), minute);
  }
}