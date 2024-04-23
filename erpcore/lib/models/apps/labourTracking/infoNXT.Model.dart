class InfoNXT {
  String? comName;
  String? comAdd;
  String? sysDate;
  String? ftFromDate;
  String? ftToDate;
  String? ftCusName;
  String? ftPrjName;
  String? ftStoreName;
  String? ftKindInOut;
  double? sumQtyBg;
  double? sumQtyIn;
  double? sumQtyOut;
  double? sumQtyEnd;

  InfoNXT({String? comName,String? comAdd,String? sysDate,String? ftFromDate,String? ftToDate,String? ftCusName,String? ftPrjName,String? ftStoreName,String? ftKindInOut,double? sumQtyBg,double? sumQtyIn,double? sumQtyOut,double? sumQtyEnd}){
    this.comName = comName?? "";
    this.comAdd = comAdd?? "";
    this.sysDate = sysDate?? "";
    this.ftFromDate = ftFromDate?? "";
    this.ftToDate = ftToDate?? "";
    this.ftCusName = ftCusName?? "";
    this.ftPrjName = ftPrjName?? "";
    this.ftStoreName = ftStoreName?? "";
    this.ftKindInOut = ftKindInOut?? "";
    this.sumQtyBg = sumQtyBg?? 0;
    this.sumQtyIn = sumQtyIn?? 0;
    this.sumQtyOut = sumQtyOut?? 0;
    this.sumQtyEnd = sumQtyEnd?? 0;
  }

  factory InfoNXT.fromJson(Map<String, dynamic>? json) {
    late InfoNXT result = InfoNXT();
    if(json != null){
      result = InfoNXT(
        comName : (json['comName'])??"",
        comAdd : (json['comAdd'])??"",
        sysDate : (json['sysDate'])??"",
        ftFromDate : (json['ftFromDate'])??"",
        ftToDate : (json['ftToDate'])??"",
        ftCusName : (json['ftCusName'])??"",
        ftPrjName : (json['ftPrjName'])??"",
        ftStoreName : (json['ftStoreName'])??"",
        ftKindInOut : (json['ftKindInOut'])??"",
        sumQtyBg : (json['sumQtyBg'])??0,
        sumQtyIn : (json['sumQtyIn'])??0,
        sumQtyOut : (json['sumQtyOut'])??0,
        sumQtyEnd : (json['sumQtyEnd'])??0,
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comName'] = (this.comName)??"";
    data['comAdd'] = (this.comAdd)??"";
    data['sysDate'] = (this.sysDate)??"";
    data['ftFromDate'] = (this.ftFromDate)??"";
    data['ftToDate'] = (this.ftToDate)??"";
    data['ftCusName'] = (this.ftCusName)??"";
    data['ftPrjName'] = (this.ftPrjName)??"";
    data['ftStoreName'] = (this.ftStoreName)??"";
    data['ftKindInOut'] = (this.ftKindInOut)??"";
    data['sumQtyBg'] = (this.sumQtyBg)??0;
    data['sumQtyIn'] = (this.sumQtyIn)??0;
    data['sumQtyOut'] = (this.sumQtyOut)??0;
    data['sumQtyEnd'] = (this.sumQtyEnd)??0;
    return data;
  }
}