import 'package:erpcore/models/apps/prCodeName.Model.dart';

class TotalProjectCostModel{
  String? sysCode;
  PrCodeName? departmant;
  double? alLEXPECTEDCOST;
  double? alLREVENUEFORECAST;
  double? pLFORECAST;
  TotalProjectCostModel({this.alLEXPECTEDCOST,this.alLREVENUEFORECAST,this.departmant,this.pLFORECAST,this.sysCode});
}