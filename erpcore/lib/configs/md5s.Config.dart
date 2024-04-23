import 'package:erpcore/datas/appServiceAPI.Data.dart';

class Md5sConfig extends AppServiceAPIData{
  static const String evaluateSaveURL = "/evaluate/save"; // evaluate save
  static const String getEvaluateByDateURL = "/evaluate/search";
  static const String updateStatusEvaluateURL = "/evaluate/updatestatus";
  static const String getListCustomerURL = "/customer/search"; // lấy danh sách khách hàng
  static const String getListProjectURL = "/cusproject/search"; // lấy danh sách dự án
  static const String getListFactoryURL = "/EvaFactory/search"; // lấy danh sách nhà máy
  static const String getPartsByFactorySearchURL = "/EvaFactory/partsByFactorySearch"; // lấy danh sách bộ phận theo nhà máy
  static const String getAreasByPartsSearchURL = "/EvaAreas/areasByPartsSearch"; // lấy danh sách khu vực theo bộ phận
  static const String getListShiftURL = "/Evaluate/getListShift"; // lấy danh sách ca làm việc
  static const String getListEmployeeURL = "/Evaluate/SearchForUser"; // lấy danh sách nhân viên
  static const String getListCriteriaTypeURL = "/EvaCriteria/getTypeCriteria"; // lấy danh sách loại đánh giá
  static const String getListCriteriaDetailURL = "/EvaCriteria/search"; // lấy danh sách chi tiết loại đánh giá

}