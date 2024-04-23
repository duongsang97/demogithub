class InternetCnInfoModel{
  String connectType="none";
  bool connecting=false;

  InternetCnInfoModel({required String connectType,required bool connecting}){
    this.connectType=connectType;
    this.connecting=connecting;
  }
}