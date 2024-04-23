import 'package:erpcore/models/apps/labourTracking/infoNXTmonth.Model.dart';
import 'prCodeLabour.Model.dart';

class DataDetailNXTMonth {
  InfoNXTMonth? listInfoNXTMonth;
  List<NXTMonthSum>? listItemNXTMonth;

  DataDetailNXTMonth({InfoNXTMonth? listInfoNXTMonth, List<NXTMonthSum>? listItemNXTMonth}){
    this.listInfoNXTMonth = listInfoNXTMonth??InfoNXTMonth();
    this.listItemNXTMonth = listItemNXTMonth??List<NXTMonthSum>.empty(growable: true);
  }

  factory DataDetailNXTMonth.fromJson(Map<String, dynamic>? json) {
    late DataDetailNXTMonth result = DataDetailNXTMonth();
    if (json != null) {
      result = DataDetailNXTMonth(
        listInfoNXTMonth: (InfoNXTMonth.fromJson(json['info'])),
        listItemNXTMonth: (NXTMonthSum.fromJsonList(json['items'])),
      );
    }
    return result;
  }
}
