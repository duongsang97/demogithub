import 'prCodeLabour.Model.dart';

class InfoNXTMonth {
  String? comName;
  String? comAdd;
  String? sysDate;
  int? year;
  String? ftCusName;
  String? ftPrjName;
  String? ftStoreName;
  String? ftKindInOut;
  NXTMonthSum? sum;

  InfoNXTMonth({String? comName,String? comAdd,String? sysDate,int? year,String? ftCusName,String? ftPrjName,String? ftStoreName,String? ftKindInOut,NXTMonthSum? sum}){
    this.comName = comName??"";
    this.comAdd = comAdd??"";
    this.sysDate = sysDate??"";
    this.year = year??0;
    this.ftCusName = ftCusName??"";
    this.ftPrjName = ftPrjName??"";
    this.ftStoreName = ftStoreName??"";
    this.ftKindInOut = ftKindInOut??"";
    this.sum = sum??NXTMonthSum();
  }

  factory InfoNXTMonth.fromJson(Map<String, dynamic>? json) {
    late InfoNXTMonth result = InfoNXTMonth();
    if (json != null){
    result = InfoNXTMonth(
        comName: (json['comName'])??"",
        comAdd: (json['comAdd'])??"",
        sysDate: (json['sysDate'])??"",
        year: (json['year'])??0,
        ftCusName: (json['ftCusName'])??"",
        ftPrjName: (json['ftPrjName'])??"",
        ftStoreName: (json['ftStoreName'])??"",
        ftKindInOut: (json['ftKindInOut'])??"",
        sum: NXTMonthSum.fromJson(json['sum']));
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comName'] = (this.comName)??"";
    data['comAdd'] = (this.comAdd)??"";
    data['sysDate'] = (this.sysDate)??"";
    data['year'] = (this.year)??0;
    data['ftCusName'] = (this.ftCusName)??"";
    data['ftPrjName'] = (this.ftPrjName)??"";
    data['ftStoreName'] = (this.ftStoreName)??"";
    data['ftKindInOut'] = (this.ftKindInOut)??"";
    data['sum'] = (this.sum)??NXTMonthSum();
    return data;
  }
}

