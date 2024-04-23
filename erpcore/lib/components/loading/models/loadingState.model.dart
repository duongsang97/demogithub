import 'package:erpcore/components/loading/datas/loadingType.data.dart';

class LoadingStatesModel{
  LoadingType type = LoadingType.DEFAULT;
  String msg ="";
  double? processing;
  bool init = false;
  LoadingStatesModel({this.msg="",this.processing,this.type=LoadingType.DEFAULT,this.init = false});
}