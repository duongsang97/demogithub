class AppServiceAPIData{
  static const int connectTimeout = 60000;
  static const int receiveTimeout = 10000;

  // server chat signAlr
  static const String serverSignAlrUrl = "https://centaurus.acacy.com.vn";
  static const String chatServerURL = "$serverSignAlrUrl/MessageHub"; // server chat
  static const String chatChannelAcacy = "erp.acacy.com.vn"; // channel chat acacy
  static const String chatChannelSpiral = "prol.spiral.com.vn"; // channel chat spiral

  // config Url
  static const String acaHostURL = "https://erpapi.acacy.com.vn/"; // erp acacy domain
  static const String spiHostURL = "https://erpapi.spiral.com.vn/"; // erp spiral domain
  static const String heinekenHostURL = "https://heinekenapi.acacy.com.vn/"; // erp heineken domain
  static const String abbottHostURL = "https://pediasureapi.acacy.com.vn/"; // erp abbott domain
  static const String marsHostURL = "https://coolairapi.acacy.com.vn/"; // erp mars domain
  static const String pepsiHostURL = "https://pepsiapi.acacy.com.vn/"; // erp pepsi domain
  static const String chupachupsHostURL = "https://chupachupsapi.spiral.com.vn/"; // erp chupachups domain
  static const String demoAcacyHostURL = "https://demo.acacy.com.vn/"; // erp demo acacy domain
  static const String demoSpiralHostURL = "https://demo.spiral.com.vn/"; // erp demo spiral domain
  static const String sabecoAcacyHostURL = "https://sabecoapi.acacy.com.vn/"; // erp sabe spiral domain
  static const String jtiAcacyHostURL = "https://jtiapi.acacy.com.vn/"; // erp jti acacy domain
  static const String pernodAcacyHostURL = "https://pernodapi.acacy.com.vn/"; // erp pernod acacy domain
  static String rootHostURL = ""; // domain by package name


  static const String loginURL = "/access/login"; // đăng nhập với username and password
  static const String logInByFingerprintIDURL = "/access/LogInByFingerprintID"; // đăng nhập với vân tay
  static const String getUserProfileURL = "/access/getloginuser";
  static const String registerFingerprintIDURL = "/Access/RegisterFingerprintID"; // đăng ký dấu vân tay lên hệ thống
  static const String getListStatusVerify = "/access/GetUserVerify"; // lấy danh sách trạng thái xác minh
  // static const String getListStatusVerify = "/Employee/GetUserVerify"; // lấy danh sách trạng thái xác minh
  static const String getPayslipOfYearURL = "/CusPrjPayslipData/SearchPayslipByEmployee";
  static const String checkVersionAppURL = "/AppActivation/GetAppInfo";
  static const String resetPassURL = "/AppActivation/ResetPass";
  static const String deleteUserURL = "/user/delete";
  static const String changePassword = "/access/changepass";
  static const String updatePassword = "/access/UpdatePassByUserEmail";
  static const String setPassword = "/access/ResetPassByPasswordChangeKeyV2";

  // Employee profile
  static const String employeeSearchURL = "/employee/search";
  static const String masterdeclareallURL = "/masterdeclareall/search";
  static const String empGetonedataURL = "/employee/getonedata";
  static const String uploadFileProfileURL = "/employee/uploadFileFormApp";
  static const String erpsearchempURL = "/decisiondayoff/search";
  static const String getlisttypedayoff = "/decisiondayoff/getlistloainghiphep";
  static const String getlisttimeslot ="/decisiondayoff/getlistkhungngaynghiphep";
  static const String empsavedayoff = "/decisiondayoff/save";
  static const String empDayOffByUser = "/decisiondayoff/SearchByUser";
  static const String empsearchemployee = "/employee/searchforuse";
  static const String empsearchcustomer = "/TaskCommon/GetListCustomer";
  static const String empsearchproject = "/taskCommon/GetListProject";
  static const String empsearchpeople = "/crmcommon/getlistuser";
  static const String empsavetaskplan = "/taskPlan/save";
  // Esignature
  static const String getListSignature = "/signature/search";
  static const String getOneDataSignature = "/signature/getonedata";
  static const String getListUser = "/crmCommon/getListUser";
  static const String saveSignature = "/signature/save";
  static const String updateSignature = "/signature/updatestatus";
  static const String getDefaultImageSign = "/signature/getDefaultImageSign";
  static const String getPositionByUser = "/signature/getPositionByUser";
  // Identification
  static const String getInfoTypeAuth = "/user/authenticator";


  // project cost
  static const String projectCostSearchURL = "/projectcost/search";

  // payslip
  static const String listPayslipUserURL = "/CusPrjPayslipData/ListPayslipUser";
  static const String getOnePayslipUserURL = "/CusPrjPayslipData/GetOnePayslipUser";

  // message
  static const String notifymessageURL = "/notify/message"; //nhắn tin
  static const String notifyUsersURL = "/notify/users"; // lấy danh sách người dùng
  static const String notifyUsersv2URL = "/notify/usersv2"; // lấy danh sách người dùng
  static const String   notifySearch = "/notify/search"; // lấy danh sách tin nhắn
  // lấy thông tin user
  static const String getSumDataByCode = "/Employee/GetSumDataByCode";
  // lấy thông tin user 
  static const String faceIdVerify = "/employee/ImageCompare"; // ImageCompareApp
  // api quản lí kho
  static const String getRpTonghopNXT = "/InvReport/GetRpTonghopNXT";
  static const String getRpDetailNXTmonth = "/InvReport/GetRpChitietNXTTheoThang";
  static const String getTrackingppeBalance = "/trackingppe/search";
  // TaskMngMai
  static const String getListMyTask = "/TaskMng/search";
  static const String getListTaskStatus = "/TaskCommon/GetListTaskStatus";
  static const String searchUserByCompany = "/TaskMng/SearchUserByCompany";
  static const String saveMyTask = "/TaskMng/save";
  static const String getOneTask = "/TaskMng/getonedata";
  static const String updateOneTask = "/TaskMng/updatestatus";
  // TaskMng plan
  static const String getListPlan = "/taskPlan/search";
  static const String getOnePlan = "/taskPlan/getOneData";
  static const String saveOnePlan = "/taskPlan/save";
  //api inventory
  static const String getInventoryShop = "/AppActivation/GetInventoryTracking"; // theo dõi kho
  static const String getInventoryShopSKU = "/AppActivationV2/GetInventoryTrackingShopSKU"; // theo dõi tồn kho SKU shop
  static const String getInventoryDetailSKU = "/AppActivationV2/GetInventoryTrackingDetailSKU"; // theo dõi tồn kho SKU chi tiết
  static const String getInventoryTop10SKU = "/AppActivationV2/GetInventoryTrackingTop10SKU"; // theo dõi tồn kho SKU top 10
  static const String getActRequestGift = "/ActRequestGift/Search"; // yêu cầu quà
  static const String getActDebtGift = "/ActGiftDebt/Search"; // nợ quà
  static const String getActTransferGift = "/ActStoreTransfer/SearchApp"; // chuyển quà
  static const String getActWareHouseHistoryURL = "/AppActivation/SearchListStoreBill"; // danh sách lịch sử kho
  static const String getActTrackingStatusBill = "/AppActivationV2/SearchTrackingStatusBillV2"; // danh sách yêu cầu duyệt
  static const String getSKUInventory = "/ActReportOOS/SearchApp"; // lấy danh sách dữ liệu SKU
  static const String updateSKUInventory = "/ActReportOOS/SaveApp"; // cập nhật dữ liệu tồn kho SKU

  static const String saveActRequestGift = "/ActRequestGift/SaveApp"; // tạo phiếu hết hàng
  // static const String saveActRequestGift = "/ActRequestGift/SaveApp"; // tạo phiếu hết hàng
  static const String saveActDebtGift = "/ActGiftDebt/SaveApp"; // tạo phiếu nợ quà
  // static const String saveActDebtGift = "/ActGiftDebt/SaveApp"; // tạo phiếu nợ quà
  static const String saveActTransferGift = "/ActStoreTransfer/Save"; // tạo phiếu chuyển kho
  // static const String saveActTransferGift = "/ActStoreTransfer/SaveApp"; // tạo phiếu chuyển kho
  static const String saveActRequestTransfer = "/AppActivation/SaveRequestChangePosition"; // tạo yêu cầu luân chuyển
  
  static const String saveActInputGift = "/ActStoreInput/Save"; // tạo phiếu nhập
  // static const String saveActInputGift = "/ActStoreInput/SaveApp"; // tạo phiếu nhập
  static const String saveActOutputGift = "/ActStoreOutput/Save"; // tạo phiếu xuất
  static const String confirmBillIn = "/ActStoreInput/ConfirmBill"; // xác nhận phiếu nhận
  static const String confirmBillOut = "/ActStoreOutput/ConfirmBill"; // xác nhận phiếu nhận
  static const String rejectBillOut = "/ActStoreOutput/RejectBill"; // xác nhận phiếu nhận
  static const String rejectBillIn = "/ActStoreInput/RejectBill"; // xác nhận phiếu nhận
  static const String getListConfigViewStoreBill = "/AppActivation/GetListConfigViewStoreBill"; // xác nhận phiếu nhận
  // static const String saveActOutputGift = "/ActStoreOutput/SaveApp"; // tạo phiếu xuất
  
  static const String updateActTransferGift = "/ActStoreTransfer/UpdateStatus"; // update trạng thái phiếu chuyển kho
  
  static const String getOneGiftRequest = "/ActRequestGift/GetOneData"; // lấy dữ liệu 1 phiếu yêu cầu quà
  static const String getOneGiftDebt = "/ActGiftDebt/GetOneData"; // xem chi tiết nợ quà
  static const String getOneGiftInput = "/ActStoreInput/GetOneDataApp"; // xem chi tiết phiếu nhập
  static const String getOneGiftOut = "/ActStoreOutput/GetOneDataApp"; // xem chi tiết phiếu xuất
  static const String getOneRequestTransfer = "/AppActivation/GetOneRequestChangePosition"; // xem chi tiết yêu cầu luân chuyển

  static const String getOneWareHouseTransfer = "/ActStoreTransfer/GetOneDataApp"; // lấy dữ liệu 1 phiếu chuyển
  
  static const String getListActprogramURL = "/actprogram/search"; // lấy danh sách các chương trình quà tặng
  static const String getListActShopURL = "/AppActivationV2/GetListStoreNShop"; // lấy danh sách các cửa hàng chương trình quà tặng
  // static const String getListActShopURL = "/AppActivationV2/SearchListShopsV2"; // lấy danh sách các cửa hàng chương trình quà tặng

  static const String getListEmpAct = "/AppActivation/GetListEmpByManager"; // lấy danh sách nhân viên
  static const String getListShiftAct = "/AppActivation/GetListShift"; // lấy danh sách ca làm việc
  static const String getListPositionAct = "/AppActivation/GetListPositionForRequest"; // lấy danh sách vị trí yêu cầu
  static const String getListProductAct = "/AppActivation/SearchListProducts"; // lây danh sách sản phầm theo loại
  static const String getListProgramAct = "/AppActivation/GetListProgram"; // chương trình inv
  static const String getListCustomerAct = "/AppActivation/GetListCustomer"; // khách hàng inv
  static const String getListReasonAct = "/AppActivation/GetListReasonDebt"; // lý do nợ inv
  static const String getListStatusRequestAct = "/AppActivation/GetListStatusRequestBill"; // status phiếu yêu cầu inv
  static const String getListStatusDebtAct = "/AppActivation/GetListStatusDebtBill"; // status nợ inv
  static const String getListStatusActInv = "/AppActivation/GetListStatusStoreOutputBill"; // status store inv
  static const String getListStatusApprovedActInv = "/AppActivation/GetListStatusApprovedBill"; // status duyệt/chưa duyệt store inv
  static const String getListStatusTransferActInv = "/AppActivation/GetListStatusStoreTransferBill"; // status phiếu chuyển inv
  static const String getListKindProductAct = "/InvCommon/GetListPrdKind"; // lấy danh sách loại hàng
  
  static const String getListProductActSellOut = "/AppActivation/GetListProduct"; // lấy danh sách sản phẩm doanh thu theo cửa hàng

 static const String getListKindInOutAct = "/AppActivation/SearchListKindInOut"; // loại hàng luân chuyển in
 static const String getListWareHouseAct = "/AppActivationV2/SearchListStoresV2"; // kho

 static const String approveTransfer = "/ActStoreTransfer/Approve"; // duyệt phiếu chuyển
 static const String approveInput = "/ActStoreInput/Approve"; // duyệt phiếu nhập
 static const String approveOutput = "/ActStoreOutput/Approve"; // duyệt phiếu xuất
 static const String approveDebt = "/ActGiftDebt/Approve"; // duyệt phiếu nợ
 static const String approveRequest = "/ActRequestGift/Approve"; // duyệt phiếu yêu cầu
 static const String approveRequestTransfer = "/AppActivation/UpdateSysApprovedRequestChangePosition"; // duyệt yêu cầu luân chuyển
 static const String confirmQtyStoreTransferURL = "/ActStoreTransfer/ConfirmQtyStoreTransfer"; // gửi dữ liệu confirm phiếu
 static const String getTransferByGiftRequestURL = "/AppActivation/AutoMappingDataFromRequestGiftToStoreTransfer"; // lấy dữ liệu phiếu chuyển kho, từ phiếu yêu cầu quà
 static const String getOutByGiftDebitURL = "/AppActivation/AutoMappingDataFromGiftDebtToStoreOutput"; // lấy dữ liệu phiếu xuất kho, từ phiếu nợ quà
 static const String getListProcessURL = "/AppActivation/GetListProcess"; // lấy dữ liệu tin tức
 static const String confirmReportOOSURL = "/ActReportOOS/ConfirmQtyReportOOS"; // xác nhận báo cáo oos (mode save)
 static const String rejectConfirmTransfer  = "/ActStoreTransfer/RejectConfirmInfo"; //Từ chối phiếu chuyển kho

  // thông báo
  static const String getListTagNotify = "/AppActivation/GetListTagNotify"; // lấy danh sách tags thông báo
  static const String getListNotify = "/AppActivation/SearchNotifyApp"; // lấy danh sách thông báo
  static const String updateNotifyStatus = "/AppActivation/NotifyAppUpdateStatus"; // cập nhật trạng thái thông báo

  // lấy thời gian hệ thống
  static const String getCurrentDateTimeServer = "/AppActivation/GetDateTimeNow";

  // Lấy domain api theo packagename
  static const String getAppDomain = "/AppActivationV2/GetAppDomain";
  
  // download hình ảnh logo , màu sắc app
  static const String getAppConfig = "/AppActivationV2/GetAppConfig";

  // Quảng cáo
  static const String getListAds = "/AppActivationV2/GetListAds";

  // Đào tạo webview
  static const String traineeSpiral = "https://trainee.spiral.com.vn/"; 
  static const String traineeAcacy = "https://trainee.acacy.com.vn/"; 
  
  static const String actGetProgramConfig = "/AppActivationV2/GetProgramConfig";
  static const String actRecordKey = "RECORD_WP_KEY";
  static const String getOneAsset = "/asset/getOneData";
  static const String getListAsset = "/asset/SearchYourAsset";
}

