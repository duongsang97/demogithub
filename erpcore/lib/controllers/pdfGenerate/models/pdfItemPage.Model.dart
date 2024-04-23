class PDFItemPageModel{
  String? code;
  int status =1;
  int? page =0;
  String? asset;
  String? note;

  PDFItemPageModel({this.asset,this.code,this.note,this.page,this.status=1});
}