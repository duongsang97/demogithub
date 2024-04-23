import 'package:erpcore/utility/logs/appLogs.Utility.dart';

class PayslipInfoModel{
  String? sysCode;
  double? tongThuNhap;
  double? luongThucNhan;
  double? luonggiamtru;
  String? payslipContent;
  String? salPeriodFromDate;
  String? salPeriodToDate;
  // chi tiết tổng lương
  String? luongCoBan; // lương cơ bản
  String? hoTroNghiChoViec; // hỗ trợ nghỉ chờ việc
  String? phuCapAnUong; // phụ cấp ăn uống
  String? phuCapDienThoai; // phu cấp điện thoại
  String? phuCapDiChuyen; // Phụ cấp di chuyển
  String? phuCapDocHai; // phụ cấp đọc hại
  String? thuongThangTruoc; // thưởng tháng
  String? adjusted; // bao gồm tăng ca, hoặc chi lương bổ sung thánng trước
  String? ot; // ot không chịu thuế
  String? otTinhChiuThue; // tiền lương ot chịu thuế
  String? thuongKhac; // thưởng khác
  String? kpiTrongThang; // kpi trong tháng
  String? adjustRemunerationOfPayroll;
  String? ttPhepNam; // thanh toán phép năm
  // chi tiết khoản trừ
  String? tricBHXH; 
  String? thuNhapTinhThue;
  String? thueTNCN;
  String? adjustOrther;
  String? soNguoiGiamTru; //
  String? soTienGiamTru; //

  String? empCode;
  String? empName;
  String? empIdentity;
  String? colHDLD002;

  PayslipInfoModel({this.adjustOrther,this.adjustRemunerationOfPayroll,this.adjusted,this.colHDLD002,this.empCode,this.empIdentity,this.empName,this.hoTroNghiChoViec,
    this.kpiTrongThang,this.luongCoBan,this.luongThucNhan,this.luonggiamtru,this.ot,this.otTinhChiuThue,this.payslipContent,this.phuCapAnUong,this.phuCapDiChuyen,this.phuCapDienThoai,
    this.phuCapDocHai,this.salPeriodFromDate,this.salPeriodToDate,this.soNguoiGiamTru,this.soTienGiamTru,this.sysCode,this.thuNhapTinhThue,this.thueTNCN,this.thuongKhac,this.thuongThangTruoc,
    this.tongThuNhap,this.tricBHXH,this.ttPhepNam,
  });

  factory PayslipInfoModel.fromJson(Map<String, dynamic>? json) {
    late PayslipInfoModel result = PayslipInfoModel();
    if (json != null){
      result = PayslipInfoModel(
        sysCode: (json["sysCode"])??"",
      );

      try{
        result.salPeriodFromDate = (json["SalPeriodFromDate"])??"";
        result.salPeriodToDate = (json["SalPeriodToDate"])??"";
        result.tongThuNhap = (json["Col105"])??0;
        result.luongThucNhan = (json["Col110"])??0;
        result.luonggiamtru = (result.tongThuNhap ??0)- (result.luongThucNhan??0);

        // chi tiết tổng lương
        result.luongCoBan = ((json["Col100"])??"").toString();
        result.hoTroNghiChoViec = ((json["Col259"])??"").toString();
        result.phuCapAnUong = ((json["Col125"])??"").toString();
        result.phuCapDienThoai = ((json["Col025"])??"").toString();
        result.phuCapDiChuyen = ((json["Col178"])??"").toString();
        result.phuCapDocHai = ((json["Col216"])??"").toString();
        result.thuongThangTruoc = ((json["Col269"])??"").toString();
        result.adjusted = ((json["Col232"])??"").toString();
        result.ot = ((json["Col102"])??"").toString();
        result.otTinhChiuThue = ((json["Col101"])??"").toString();
        result.thuongKhac = ((json["Col227"])??"").toString();
        result.kpiTrongThang = ((json["Col126"])??"").toString();
        result.adjustRemunerationOfPayroll = ((json["Col099"])??"").toString();
        result.ttPhepNam = ((json["Col228"])??"").toString();
        // chi tiết khoản trừ
        result.tricBHXH = ((json["Col111"])??"").toString();
        result.thuNhapTinhThue = ((json["Col108"])??"").toString();
        result.thueTNCN = ((json["Col109"])??"").toString();
        result.adjustOrther = ((json["Col133"])??"").toString();
        result.soNguoiGiamTru = ((json["Col106"])??"").toString();
        result.soTienGiamTru = ((json["Col107"])??"").toString();
        result.empCode = (json["EmpCode"])??"";
        result.empName = (json["EmpName"])??"";
        result.empIdentity = (json["EmpIdentity"])??"";
        result.colHDLD002 = (json["ColHDLD002"])??"";
      }
      catch(ex){
        AppLogsUtils.instance.writeLogs(ex,func: "PayslipInfoModel.fromJson payslipInfo.Model");
      }
    }
      return result;
  }

  static List<PayslipInfoModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => PayslipInfoModel.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PayslipInfoModel>? list) {
    if (list == null) return [];
    return list.map((item) => item.toJson()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "sysCode": (this.sysCode)??"",
    };
    return map;
  }
}