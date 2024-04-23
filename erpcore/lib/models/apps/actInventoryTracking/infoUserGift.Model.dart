class InfoUserGift {
  String? name;
  String? phoneNumber;
  String? address;
  String? note;

  InfoUserGift({this.address,this.name,this.note,this.phoneNumber});
  factory InfoUserGift.fromJson(Map<String, dynamic>? json) {
    late InfoUserGift result = InfoUserGift();
    if(json!=null){
      result = InfoUserGift(
        name : (json['name'])??"",
        phoneNumber : (json['phoneNumber'])??"",
        address : (json['address'])??"",
        note : (json['note'])??"",
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = (this.name)??"";
    data['phoneNumber'] = (this.phoneNumber)??"";
    data['address'] = (this.address)??"";
    data['note'] = (this.note)??"";
    return data;
  }
}