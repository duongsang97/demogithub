import '../prCodeName.Model.dart';

class DataBalance {
  String? sysCode;
  PrCodeName? company;
  PrCodeName? customer;
  PrCodeName? project;
  PrCodeName? monthYearDisplay;
  int? month;
  int? year;
  double? takeTarget;
  double? takeActual;
  double? takeTotal;
  double? spendingTarget;
  double? spendingActual;
  double? spendingTotal;
  double? toCollectPPE;
  double? balance;
  String? note;
  int? sortOrder;
  int? sysStatus;
  String? strResult;
  var listErr;
  int? type;
  DataBalance({String? sysCode,PrCodeName? company,PrCodeName? customer,PrCodeName? project,PrCodeName? monthYearDisplay,int? month,int? year,double? takeTarget,double? takeActual,double? takeTotal,double? spendingTarget,double? spendingActual,double? spendingTotal,double? toCollectPPE,double? balance,String? note,int? sortOrder,int? sysStatus,String? strResult,var listErr,int? type,}){
    this.sysCode = sysCode??"";
    this.company = company??PrCodeName();
    this.customer = customer??PrCodeName();
    this.project = project??PrCodeName();
    this.monthYearDisplay = monthYearDisplay??PrCodeName();
    this.month = month??0;
    this.year = year??0;
    this.takeTarget = takeTarget??0;
    this.takeActual = takeActual??0;
    this.takeTotal = takeTotal??0;
    this.spendingTarget = spendingTarget??0;
    this.spendingActual = spendingActual??0;
    this.spendingTotal = spendingTotal??0;
    this.toCollectPPE = toCollectPPE??0;
    this.balance = balance??0;
    this.note = note??"";
    this.sortOrder = sortOrder??0;
    this.sysStatus = sysStatus??0;
    this.strResult = strResult??"";
    this.listErr = listErr??"";
    this.type = type??0;
  }

  factory DataBalance.fromJson(Map<String, dynamic>? json) {
    late DataBalance result = DataBalance();
    if(json != null){
      result = DataBalance(
        sysCode : (json['sysCode'])??"",
        company : PrCodeName.fromJson(json['company']),
        customer : PrCodeName.fromJson(json['customer']),
        project : PrCodeName.fromJson(json['project']),
        monthYearDisplay : PrCodeName.fromJson(json['monthYearDisplay']),
        month : (json['month'])??0,
        year : (json['year'])??0,
        takeTarget : (json['takeTarget'])??0,
        takeActual : (json['takeActual'])??0,
        takeTotal : (json['takeTotal'])??0,
        spendingTarget : (json['spendingTarget'])??0,
        spendingActual : (json['spendingActual'])??0,
        spendingTotal : (json['spendingTotal'])??0,
        toCollectPPE : (json['toCollectPPE'])??0,
        balance : (json['balance'])??0,
        note : (json['note'])??"",
        sortOrder : (json['sortOrder'])??0,
        sysStatus : (json['sysStatus'])??0,
        strResult : (json['strResult'])??"",
        listErr : (json['listErr'])??"",
        type : (json['type'])??0,
      );
    }
   return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sysCode'] = (this.sysCode)??"";
    data['company'] = (this.company)??{};
    data['customer'] = (this.customer)??{};
    data['project'] = (this.project)??{};
    data['monthYearDisplay'] = (this.monthYearDisplay)??{};
    data['month'] = (this.month)??0;
    data['year'] = (this.year)??0;
    data['takeTarget'] = (this.takeTarget)??0;
    data['takeActual'] = (this.takeActual)??0;
    data['takeTotal'] = (this.takeTotal)??0;
    data['spendingTarget'] = (this.spendingTarget)??0;
    data['spendingActual'] = (this.spendingActual)??0;
    data['spendingTotal'] = (this.spendingTotal)??0;
    data['toCollectPPE'] = (this.toCollectPPE)??0;
    data['balance'] = (this.balance)??0;
    data['note'] = (this.note)??"";
    data['sortOrder'] = (this.sortOrder)??0;
    data['sysStatus'] = (this.sysStatus)??0;
    data['strResult'] = (this.strResult)??"";
    data['listErr'] = (this.listErr)??"";
    data['type'] = (this.type)??0;
    return data;
  }

  static List<DataBalance> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => DataBalance.fromJson(item)).toList();
  }
}
