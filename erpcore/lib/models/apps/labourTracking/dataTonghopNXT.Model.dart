import 'infoNXT.Model.dart';
import 'itemNXT.Model.dart';

class DataTonghopNXT {
  InfoNXT? listInfoNXT;
  List<ItemNXT>? listItemNXT;

  DataTonghopNXT({InfoNXT? listInfoNXT, List<ItemNXT>? listItemNXT}){
    this.listInfoNXT = listInfoNXT??InfoNXT();
    this.listItemNXT = listItemNXT??List<ItemNXT>.empty(growable: true);
  }

  factory DataTonghopNXT.fromJson(Map<String, dynamic>? json) {
    late DataTonghopNXT result = DataTonghopNXT();
    if (json != null) {
      result = DataTonghopNXT(
        listInfoNXT: (InfoNXT.fromJson(json['info'])),
        listItemNXT: ItemNXT.fromJsonList(json['items'])
      );
    }
    return result;
  }
}
