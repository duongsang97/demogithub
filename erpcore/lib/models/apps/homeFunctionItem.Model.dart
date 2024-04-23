class HomeFunctionItemModel {
  String code = "";
  String routerName = "";
  String? name;
  String? assetImage;
  String? url;
  String? encode;
  int? type;
  HomeFunctionItemModel({required String code,String? assetImage,String name="",required String routerName,this.url,this.encode,this.type}){
    this.code = code;
    this.routerName = routerName;
    this.name = name;
    this.assetImage = assetImage??"";
    this.url = url;
    this.encode = encode;
    this.type = type;
  }
}