import 'dart:async';
import 'dart:io';
import 'package:erpcore/models/apps/deviceDetail.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';

enum AppTypeScreen {
  READONLY, // Chỉ xem
  EDIT, // cho chỉnh sửa 1 số thông tin
  ACTION // tạo mới
}

class AppKey{
  static const String keyERPToken = "ERP_TOKEN_KEY";
  static const String keFirebaseERPToken = "ERP_FIREBASE_TOKEN_KEY";
  static const String keyIntroWorkingPlant = "ERP_INTROSCREEN1_KEY";
  static const String keyIntroWorkingAct = "ERP_INTROSCREEN2_KEY";
  static const String keyConfigIntro = "ERP_CONFIGINTRO_KEY";
  static const String keyAppMode = "ERP_APPMODE_KEY";
  static const String keyActivationToken = "ACTIVATION_TOKEN_KEY";
  static const String keybiometricstoken = "BIOMETRICS_TOKEN_KEY";
  static const String keybiometricsStatus = "BIOMETRICS_STATUS_KEY";
  static const String keyFingerprintStatus = "Fingerprint_STATUS_KEY";
  static const String keyFcmToken = "FCM_TOKEN_KEY";
  static const String keyTokenFile = "FILE_TOKEN_KEY";
  static const String usernameLogin = "USERNAME_LOGIN";
  static const String authenOpenStatus = "AUTHEN_OPEN_STATUS";
  static const String userData = "USER_DATA";
  static const String routesKey = "ROUTES_KEY";
  static const String authTypeKey = "AUTH_TYPE_KEY";
  static const String keyDevMode = "DEV_MODE_KEY";
  static const String keyServerDevModeURL = "SERVER_URL_DEV_MODE_KEY";
  static const String loginCryptInfoKey = "LOGIN_CRYPT_INFO_KEY";
  static const String inProcessRefreshTokenKey = "IN_PROCESS_REFRESH_TOKEN_KEY";


  // key phân trang tab pageView Route
  static const int keyTabMain = 1;
  static const int keyTabActMain = 2;
  static const int keyTabDashboard = 3;
  static const int keyTabInvMain = 4;
  static const int keyTabTaskMain = 5;
   static const int keyAttMandayTab = 6;
   static const int keyIdentificationTab = 7;
   static const int keyTaskMngTab = 8;

  // key sync data
  static const String keySyncListError = "ERP_ERROR_SYNC_DATA_KEY";
}
class pageSizeConfig{
  static const int page = 1;
  static const int totalPage = 1;
  static const int pageSize = 25;
}

class PackageName{
  static const String spiralPackage = "spiral.com.vn.erp"; // name ERP app
  static const String acacyPackage = "acacy.com.vn.erp"; // name ERP app
  static const String spiralv2Package = "spiral.com.vn.erpspi"; // spiral ERP phiên bản logo spiral
  static const String abbottPackage = "com.acacy.abbott"; // name ERP ABBOTT
  static const String allfreePackage = "acacy.com.vn.erpALLFREE";
  static const String kotexmaxcoolPackage = "acacy.com.vn.kotexmaxcool";
  static const String ssAuditPackage = "acacy.com.vn.samsungaudit"; // name ERP app
  static const String anlenePackage = "acacy.com.vn.anlene"; // name ERP app
  static const String heinekenPackage = "acacy.com.vn.heineken"; // name ERP Heineken activation
  static const String pepsiPackage = "acacy.com.vn.pepsi"; // name ERP Pepsi activation
  static const String chupachupsPackage = "spiral.com.vn.chupachups"; // name ERP hupachups activation
  static const String sabecoAcacyPackage = "acacy.com.vn.sabeco"; // Acacy ERP sabeco
  static const String marsPackage = "acacy.com.vn.mars"; // name ERP mars activation
  static const String demoAcacyPackage = "acacy.com.vn.demo"; // name ERP Acacy demo 
  static const String demoSpiralPackage = "spiral.com.vn.demo"; // name ERP Spiral demo 
  static const String abbottv2Package = "acacy.com.vn.abbott"; // name ERP Abbott activation
  static const String abbottAuditPackage = "acacy.com.vn.abbottAudit"; // name ERP Abbott audit
  static const String heinekenAuditPackage = "acacy.com.vn.heinekenaudit"; // name ERP Heineken audit activation
  static const String heinekenMTPackage = "acacy.com.vn.heinekenmt"; // name ERP Heineken mt
  static const String jtiPackage = "acacy.com.vn.jti"; // name ERP jti
  static const String pernodPackage = "acacy.com.vn.pernod"; // name ERP pernod
}

class AppDatas{
  static List<PrCodeName> listWorkDisplayType =[
    PrCodeName(code: "DT01",name: ""),
    PrCodeName(code: "DT02",name: ""),
  ];
  static List<PrCodeName> listKindWareHouse = [
    PrCodeName(code:"0",name:"Phiếu nhập"),
    PrCodeName(code:"1",name:"Phiếu mất/hư hỏng/nhận lệch"),
    PrCodeName(code:"2",name:"Phiếu xuất"),
    PrCodeName(code:"3",name:"Phiếu yêu cầu quà"),
    PrCodeName(code:"4",name:"Phiếu yêu nợ quà")
  ];
  static List<PrCodeName> listStatusWareHouseConfirm = [
    PrCodeName(code:"5",name:"Hủy phiếu",codeDisplay: "#808080"),
    PrCodeName(code:"4",name:"Hoàn thành",codeDisplay: "#00FF00"),
    PrCodeName(code:"0",name:"Chờ duyệt",codeDisplay: "#00FF00"),
    PrCodeName(code:"3",name:"Chờ nhận",codeDisplay: "#00FF00"),  
  ];

  // quyền 
  static List<String> permissionWareHouseApprove = [
    "PrFormActivation_ActStoreOutput_Approve", // xuất
    "PrFormActivation_ActStoreInput_Approve", // nhập
    "PrFormActivation_ActStoreTransfer_Approve", // chuyển
    "PrFormActivation_ActGiftDebt_Approve", // nợ
    "PrFormActivation_ActRequestGift_Approve", // yêu cầu quà
    "PrFormActivation_ActRequestChangePostion_Approved" // luân chuyển
  ];
  static List<String> permissionWareHouse = [
    "PrFormActivation_ActStoreOutput", // xuất
    "PrFormActivation_ActStoreInput", // nhập
    "PrFormActivation_ActStoreTransfer", // chuyển
  ];
  static List<String> permissionWareHouseCreate = [
    "PrFormActivation_ActStoreOutput_Create", // xuất
    "PrFormActivation_ActStoreInput_Create", // nhập
    "PrFormActivation_ActStoreTransfer_Create", // chuyển
  ];
  static List<String> permissionWareHouseEdit = [
    "PrFormActivation_ActStoreOutput_Update", // xuất
    "PrFormActivation_ActStoreInput_Update", // nhập
    "PrFormActivation_ActStoreTransfer_Update", // chuyển
  ];
  // quyền search quà
  static List<String> permissionActivationGift = [
    "PrFormActivation_ActGiftDebt", // nợ
    "PrFormActivation_ActRequestGift", // yêu cầu quà
    "PrFormActivation_ActRequestChangePostion" // luân chuyển nhân sự
  ];
  // quyền save quà
  static List<String> permissionActivationEdit = [
    "PrFormActivation_ActGiftDebt_Update", // nợ
    "PrFormActivation_ActRequestGift_Update", // yêu cầu quà
    "PrFormActivation_ActRequestChangePostion_Update", // luân chuyển nhân sự
  ];

  //quyền hiển thị yêu cầu transfer
  static List<String> permissionActEquipment = [
    "PrFormActivation_ActTransport",
    "PrFormActivation_ActMaintenance"
  ];

  // quyền duyệt y/c transfer
  static List<String> permissionActEquipmentApprove = [
    "PrFormActivation_ActTransport_Approve",
    "PrFormActivation_ActMaintenance_Approve"
  ];

  static List<String> permissionActEquipmentEdit = [
    "PrFormActivation_ActTransport_Update", //update 3 phiếu vận chuyển
    "PrFormActivation_ActMaintenance_Update" //update phiếu bảo trì
  ];

  static List<String> permissionActivation = [
    "PrFormActivation_AppActivation", 
    "PrFormActivation_ActReportOOS_UpdateSale", 
  ];

  static String appConfig = "appConfig";// store appConfig
  static String programConfig = "programConfig";// store programConfig

  static String sysKeyAppConfig = "SysKeyAppConfig";// key app
  static String sysKeyActConfig = "SysKeyProgramConfig";// key program
  
  static String colorWelcome = "ColorWelcome";//màu background welcome
  static String colorTextAppBar = "ColorTextAppBar";

  static String requireAutomaticTime = "requireAutomaticTime";
  static PrCodeName fnValidateDynamicTable = PrCodeName(code: "fnValidateDynamicTable", name: "Xác minh dữ liệu bảng",codeDisplay: "file");
  static PrCodeName fnValidateDynamicTableInputData = PrCodeName(code: "fnValidateDynamicTableInputData", name: "Xác minh dữ liệu nhập bảng");
  static PrCodeName fnValidateDynamicTableRowInputData = PrCodeName(code: "fnValidateDynamicTableRowInputData", name: "Xác minh dữ liệu nhập dòng bảng");
  static PrCodeName fnFinishChecking = PrCodeName(code: "fnFinishChecking", name: "Công việc hoàn thành");
  static PrCodeName fnValidateWorkResultDynamic = PrCodeName(code: "fnValidateWorkResultDynamic", name: "Xác minh kết quả công việc");
  static PrCodeName fnValidateSyncDynamic = PrCodeName(code: "fnValidateSyncDynamic", name: "Kiểm tra trạng thái đồng bộ", codeDisplay: "file");
  static PrCodeName fnHandleWDOnChange = PrCodeName(code: "fnHandleWDOnChange", name: "Xử lý sự kiện thay đổi WD", codeDisplay: "file");
  static PrCodeName timeZoneData = PrCodeName(code: "timeZoneData", name: "Danh sách múi giờ", codeDisplay: "");
  static PrCodeName typeWhenErrorQR = PrCodeName(code: "typeWhenErrorQR", name: "Nhập khi QR lỗi", codeDisplay: "");

  static PrCodeName erpTempLocal = PrCodeName(code: "erpTempLocal.db",name: "",codeDisplay: "",value: Completer<Database>,value2: false);
  static PrCodeName logsDb = PrCodeName(code: "logs.db",name: "logs",codeDisplay: "",value: Completer<Database>,value2: true);

  static List<PrCodeName> get dbs {
    return [
      erpTempLocal,
      logsDb
    ];
  }

  static List<PrCodeName> permissionRequired(DeviceDetails device) {
    List<PrCodeName> result = List<PrCodeName>.empty(growable: true);
    try{
      result.add(PrCodeName(code: "assets/images/icons/camera_permission.png",name: "Quyền máy ảnh",codeDisplay: "ERP cần quyền chụp hình để sử dụng các chức năng chấm công, upload hình ảnh",value: [Permission.camera,Permission.microphone],value2: []));
      result.add(PrCodeName(code: "assets/images/icons/map.png",name: "Quyền vị trí",codeDisplay: "ERP cần lấy toạ độ vị trí khi bạn thực hiện chấm công",value: [Permission.location,],value2: []));
      result.add(PrCodeName(code: "assets/images/icons/active.png",name: "Nhận thông báo",codeDisplay: "Để không bỏ lỡ những thông tin quan trọng, vui lòng bật quyền nhận thông báo từ ERP",value: [Permission.notification],value2: []));
      if(Platform.isIOS){
        String iosVersion = (device.systemVersion??"1.0.0").replaceAll(".", "");
        int iosINTVersion = int.parse(iosVersion);
        List<Permission> permission = [Permission.storage];
        if(iosINTVersion > 1400){
          permission.addAll([Permission.photos]);
        }
        
        result.add(PrCodeName(code: "assets/images/icons/multimedia.png",name: "Quyền dữ liệu hình ảnh và âm thanh",codeDisplay: "Ứng dụng cần quyền hình ảnh và âm thanh để dùng cho các tính năng cần thiết",value: permission,value2: [Permission.photos,Permission.videos,Permission.audio]));
      }
      else{
        List<Permission> permission = [];
        if((device.androidSdk??0) < 33){
          permission.addAll([Permission.storage]);
        }
        else{
          permission.addAll([Permission.photos,Permission.videos,Permission.audio]);
        }
        result.add(PrCodeName(code: "assets/images/icons/multimedia.png",name: "Quyền dữ liệu hình ảnh và âm thanh",codeDisplay: "Ứng dụng cần quyền hình ảnh và âm thanh để dùng cho các tính năng cần thiết",value: permission,value2: [Permission.manageExternalStorage]));

      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "");
    }
    return result;
  }
}