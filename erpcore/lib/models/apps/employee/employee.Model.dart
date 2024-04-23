import 'package:erpcore/models/apps/PrDate.Model.dart';
import 'package:erpcore/models/apps/PrFileUpload.Model.dart';
import 'package:erpcore/models/apps/PrIdNo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';

class EmployeeModel {
  List<PrIdNoModel>? listOfIDNo;
  // List<Null> listOfPassport;
  // List<Null> listOfTel;
  // List<Null> listOfEmail;
  // List<Null> listOfNickName;
  // List<Null> listOfPIT;
  // List<Null> listOfInsBookNo;
  // List<Null> listOfMedcardNo;
  // List<Null> listOfAccidentIns;
  // List<Null> listOfVisa;
  // List<Null> listOfGPHanhNghe;
  // List<Null> listOfChungNhanATLD;
   List<PrFileUpload>? files;
  // List<Null> emergencyContact;
  // List<Null> famylyRef;
  // List<Null> modifyHistory;
  String? sId;
  String? globalCode;
  PrCodeName? company;
  List<PrCodeName>? customers;
  String? codeofCus;
  PrDate? startingDateCus;
  //List<WorkFors> workFors;
  // List<Null> departments;
  // List<Null> positions;
  // List<Null> managers;
  // List<Null> managersCus;
  String? code;
  String? empNo;
  String? name;
  String? nameHo;
  String? nameTenDem;
  String? nameTen;
  String? nameUS;
  PrCodeName? sex;
  String? birthDay;
  int? birthDayYear;
  int? birthDayMonth;
  int? birthDayDay;
  PrCodeName? married;
  PrCodeName? nation;
  PrCodeName? religion;
  PrCodeName? nationality;
  String? householdCode;
  //PlaceBirth placeBirth;
  //PlaceBirth nativeCountry;
  //PlaceBirth perAddress;
  //PlaceBirth temAddress;
  String? note;
  String? imageName;
  PrCodeName? language;
  PrDate? startingDate;
  PrDate? beginProbation;
  PrDate? endProbation;
  PrDate? startContractDate;
  PrDate? resignedDate;
  String? resignedNote;
  //VoucherCode resignedVoucherCode;
  PrCodeName? workingLocation;
  PrCodeName? kind;
  String? taxNumber;
  int? insAtOther;
  PrCodeName? insAgency;
  PrDate? beginDateIns;
  PrCodeName? pitScheme;
  PrCodeName? bankSystem;
  String? bankAccountNo;
  PrCodeName? bankBranch;
  int? payViaBank;
  PrDate? dangvienDate;
  String? dangvienNo;
  PrCodeName? dangvienTitle;
  String? dangvienPlace;
  PrDate? doanvienDate;
  String? doanvienNo;
  PrCodeName? doanvienTitle;
  String? doanvienPlace;
  PrDate? congdoanDate;
  String? congdoanNo;
  PrCodeName? congdoanTitle;
  String? congdoanPlace;
  int? congdoanFee;
  PrCodeName? education;
  PrCodeName? bloodGroup;
  int? height;
  int? weight;
  int? disabilities;
  String? healthNote;
  PrCodeName? saleArea;
  PrCodeName? saleRegion;
  PrCodeName? source;
  PrCodeName? source02;
  PrCodeName? costCenter;
  String? profilePlace;
  int? qcStatus;
  int? requireApplyCode;
  int? raCodeMustEdit;
  String? raCodeNote;
  int? isEmpOff;
  int? bhxh;
  int? bhxhInfoNeed;
  PrDate? aprCreateDate;
  String? aprCreateUser;
  int? aprCreateKindInput;
  int? syslock;
  int? sysStatus;
  int? sysApproved;
  int? isQC;
  PrDate? createDate;
  String? createUser;
  int? createKindInput;
  PrDate? modifyDate;
  String? modifyUser;
  int? modifyKindInput;
  int? mustCalSearch;
  int? mustCal01;
  int? mustSync01;
  int? sortOrder;

  EmployeeModel({PrDate? aprCreateDate,int? aprCreateKindInput,String? aprCreateUser,String? bankAccountNo,PrCodeName? bankBranch,PrCodeName? bankSystem,
    PrDate? beginDateIns,PrDate? beginProbation,int? bhxh,int? bhxhInfoNeed,String? birthDay,int? birthDayDay,int? birthDayMonth,int? birthDayYear,PrCodeName? bloodGroup,String? code,
    String? codeofCus,PrCodeName? company,PrDate? congdoanDate,int? congdoanFee,String? congdoanNo,String? congdoanPlace,PrCodeName? congdoanTitle,PrCodeName? costCenter,PrDate? createDate,int? createKindInput,List<PrCodeName>? customers,String? empNo,String? imageName,String? name,PrCodeName? sex,
    List<PrIdNoModel>? listOfIDNo,List<PrFileUpload>? files,String? createUser,PrDate? dangvienDate,String? dangvienNo,String? dangvienPlace,PrCodeName? dangvienTitle,int? disabilities,PrDate? doanvienDate,String? doanvienNo,String? doanvienPlace,PrCodeName? doanvienTitle,PrCodeName? education,
    PrDate? endProbation,String? globalCode,String? healthNote,int? height,String? householdCode,PrCodeName? insAgency,int? insAtOther,int? isEmpOff,int? isQC,PrCodeName? kind,PrCodeName? language,PrCodeName? married,PrDate? modifyDate,int? modifyKindInput,
    String? modifyUser,int? mustCal01,int? mustCalSearch,int? mustSync01,String? nameHo,String? nameTen,String? nameTenDem,String? nameUS,PrCodeName? nation,PrCodeName? nationality,String? note,int? payViaBank,PrCodeName? pitScheme,String? profilePlace,int? qcStatus,int? raCodeMustEdit,String? raCodeNote,PrCodeName? religion,int? requireApplyCode,PrDate? resignedDate,String? resignedNote,String? sId,
    PrCodeName? saleArea,PrCodeName? saleRegion,int? sortOrder,PrCodeName? source,PrCodeName? source02,PrDate? startContractDate,PrDate? startingDate,PrDate? startingDateCus,int? sysApproved,int? sysStatus,int? syslock,String? taxNumber,int? weight,PrCodeName? workingLocation,
  }){
    this.listOfIDNo = listOfIDNo??List<PrIdNoModel>.empty(growable: true);
    // this.listOfPassport = listOfPassport??[];
    // this.listOfTel = listOfTel??[];
    // this.listOfEmail = listOfEmail??[];
    // this.listOfNickName = listOfNickName??[];
    // this.listOfPIT = listOfPIT??[];
    // this.listOfInsBookNo = listOfInsBookNo??[];
    // this.listOfMedcardNo = listOfMedcardNo??[];
    // this.listOfAccidentIns = listOfAccidentIns??[];
    // this.listOfVisa = listOfVisa??[];
    // this.listOfGPHanhNghe = listOfGPHanhNghe??[];
    // this.listOfChungNhanATLD = listOfChungNhanATLD??[];
    this.files = files??List<PrFileUpload>.empty(growable: true);
    // this.emergencyContact = emergencyContact??[];
    // this.famylyRef = famylyRef??[];
    // this.modifyHistory = modifyHistory??[];
    this.sId = sId??"";
    this.globalCode = globalCode??"";
    this.company = company??PrCodeName();
    this.customers = customers??List<PrCodeName>.empty(growable: true);
    this.codeofCus = codeofCus??"";
    this.startingDateCus = startingDateCus??PrDate();
    // this.workFors = workFors??List<WorkFors>.empty(growable: true);
    // this.departments = departments??[];
    // this.positions = positions??[];
    // this.managers = managers??[];
    // this.managersCus = managersCus??[];
    this.code = code??"";
    this.empNo = empNo??"";
    this.name = name??"";
    this.nameHo = nameHo??"";
    this.nameTenDem = nameTenDem??"";
    this.nameTen = nameTen??"";
    this.nameUS = nameUS??"";
    this.sex = sex??PrCodeName();
    this.birthDay = birthDay??"";
    this.birthDayYear = birthDayYear??0;
    this.birthDayMonth = birthDayMonth??0;
    this.birthDayDay = birthDayDay??0;
    this.married = married??PrCodeName();
    this.nation = nation??PrCodeName();
    this.religion = religion??PrCodeName();
    this.nationality = nationality??PrCodeName();
    this.householdCode = householdCode??"";
    //this.placeBirth = placeBirth??PlaceBirth();
    //this.nativeCountry = nativeCountry??PlaceBirth();
    //this.perAddress = perAddress??PlaceBirth();
    //this.temAddress = temAddress??PlaceBirth();
    this.note = note??"";
    this.imageName = imageName??"";
    this.language = language??PrCodeName();
    this.startingDate = startingDate??PrDate();
    this.beginProbation = beginProbation??PrDate();
    this.endProbation = endProbation??PrDate();
    this.startContractDate = startContractDate??PrDate();
    this.resignedDate = resignedDate??PrDate();
    this.resignedNote = resignedNote??"";
    //this.resignedVoucherCode = resignedVoucherCode??VoucherCode();
    this.workingLocation = workingLocation??PrCodeName();
    this.kind = kind??PrCodeName();
    this.taxNumber = taxNumber??"";
    this.insAtOther = insAtOther??0;
    this.insAgency = insAgency??PrCodeName();
    this.beginDateIns = beginDateIns??PrDate();
    this.pitScheme = pitScheme??PrCodeName();
    this.bankSystem = bankSystem??PrCodeName();
    this.bankAccountNo = bankAccountNo??"";
    this.bankBranch = bankBranch??PrCodeName();
    this.payViaBank = payViaBank??0;
    this.dangvienDate = dangvienDate??PrDate();
    this.dangvienNo = dangvienNo??"";
    this.dangvienTitle = dangvienTitle??PrCodeName();
    this.dangvienPlace = dangvienPlace??"";
    this.doanvienDate = doanvienDate??PrDate();
    this.doanvienNo = doanvienNo??"";
    this.doanvienTitle = doanvienTitle??PrCodeName();
    this.doanvienPlace = doanvienPlace??"";
    this.congdoanDate = congdoanDate??PrDate();
    this.congdoanNo = congdoanNo??"";
    this.congdoanTitle = congdoanTitle??PrCodeName();
    this.congdoanPlace = congdoanPlace??"";
    this.congdoanFee = congdoanFee??0;
    this.education = education??PrCodeName();
    this.bloodGroup = bloodGroup??PrCodeName();
    this.height = height??0;
    this.weight = weight??0;
    this.disabilities = disabilities??0;
    this.healthNote = healthNote??"";
    this.saleArea = saleArea??PrCodeName();
    this.saleRegion = saleRegion ??PrCodeName();
    this.source = source??PrCodeName();
    this.source02 = source02??PrCodeName();
    this.costCenter = costCenter??PrCodeName();
    this.profilePlace = profilePlace??"";
    this.qcStatus = qcStatus??0;
    this.requireApplyCode = requireApplyCode??0;
    this.raCodeMustEdit = raCodeMustEdit??0;
    this.raCodeNote = raCodeNote??"";
    this.isEmpOff = isEmpOff??0;
    this.bhxh = bhxh??0;
    this.bhxhInfoNeed = bhxhInfoNeed??0;
    this.aprCreateDate = aprCreateDate??PrDate();
    this.aprCreateUser = aprCreateUser??"";
    this.aprCreateKindInput = aprCreateKindInput??0;
    this.syslock = syslock??0;
    this.sysStatus = sysStatus??0;
    this.sysApproved = sysApproved??0;
    this.isQC = isQC??0;
    this.createDate = createDate??PrDate();
    this.createUser = createUser??"";
    this.createKindInput = createKindInput??0;
    this.modifyDate = modifyDate??PrDate();
    this.modifyUser = modifyUser??"";
    this.modifyKindInput = modifyKindInput??0;
    this.mustCalSearch = mustCalSearch??0;
    this.mustCal01 = mustCal01??0;
    this.mustSync01 = mustSync01??0;
    this.sortOrder = sortOrder??0;
  }

  factory EmployeeModel.fromJson(Map<String, dynamic>? json) {
    late EmployeeModel result = EmployeeModel();
    if (json != null){
    result = EmployeeModel(
      aprCreateDate: PrDate.fromJson(json["aprCreateDate"]),
      aprCreateKindInput: (json["aprCreateKindInput"])??0,
      aprCreateUser: (json["aprCreateUser"])??"",
      bankAccountNo: (json["bankAccountNo"])??"",
      bankBranch: PrCodeName.fromJson(json["bankBranch"]),
      bankSystem: PrCodeName.fromJson(json["bankSystem"]),
      beginDateIns: PrDate.fromJson(json["beginDateIns"]),
      beginProbation: PrDate.fromJson(json["beginProbation"]),
      bhxh: (json["bhxh"])??0,
      bhxhInfoNeed: (json["bhxhInfoNeed"])??0,
      birthDay: (json["birthDay"])??"",
      bloodGroup: PrCodeName.fromJson(json["bloodGroup"]),
      code: (json["code"])??"",
      codeofCus: (json["codeofCus"])??"",
      company: PrCodeName.fromJson(json["company"]),
      congdoanDate: PrDate.fromJson(json["congdoanDate"]),
      congdoanFee: (json["congdoanFee"])??0,
      congdoanNo: (json["congdoanNo"])??"",
      congdoanPlace: (json["congdoanPlace"])??"",
      congdoanTitle: PrCodeName.fromJson(json["congdoanTitle"]),
      costCenter: PrCodeName.fromJson(json["costCenter"]),
      createDate: PrDate.fromJson(json["createDate"]),
      createKindInput: json["createKindInput"],
      customers: PrCodeName.fromJsonList(json["customers"]),
      empNo: (json["empNo"])??"",
      imageName: (json["imageName"])??"",
      name: (json["name"])??"",
      sex: PrCodeName.fromJson(json["sex"]),
      files: PrFileUpload.fromJsonList(json["files"]),
      listOfIDNo: PrIdNoModel.fromJsonList(json["listOfIDNo"])
    );
    }
    return result;
  }



  static List<EmployeeModel> fromJsonList(List? list) {
    if (list == null) return [];
    return list.map((item) => EmployeeModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "aprCreateDate": this.aprCreateDate!=null?(this.aprCreateDate!.toJson()):{},
      "aprCreateKindInput": (this.aprCreateKindInput)??0,
      "aprCreateUser": (this.aprCreateUser)??"",
      "bankAccountNo": (this.bankAccountNo)??"",
      "bankBranch": this.bankBranch!=null?(this.bankBranch!.toJson()):{},
      "bankSystem": this.bankSystem!=null?(this.bankSystem!.toJson()):{},
      "beginDateIns": this.beginDateIns!=null?(this.beginDateIns!.toJson()):{},
      "beginProbation": this.beginProbation!=null?(this.beginProbation!.toJson()):{},
      "bhxh": (this.bhxh)??0,
      "bhxhInfoNeed": (this.bhxhInfoNeed)??0,
      "birthDay": (this.birthDay)??"",
      "bloodGroup": this.bloodGroup!=null?(this.bloodGroup!.toJson()):{},
      "code": (this.code)??"",
      "codeofCus": (this.codeofCus)??"",
      "company": this.company!=null?(this.company!.toJson()):{},
      "congdoanDate": this.congdoanDate!=null?(this.congdoanDate!.toJson()):{},
      "congdoanFee": (this.congdoanFee)??0,
      "congdoanNo": (this.congdoanNo)??"",
      "congdoanPlace":(this.congdoanPlace)??"",
      "congdoanTitle": this.congdoanTitle!=null?(this.congdoanTitle!.toJson()):{},
      "costCenter": this.costCenter!=null?(this.costCenter!.toJson()):{},
      "createDate": this.createDate!=null?(this.createDate!.toJson()):{},
      "createKindInput": (this.createKindInput)??0,
      "customers": (this.customers)??List<PrCodeName>.empty(growable: true),
      "empNo": (this.empNo)??"",
      "imageName": (this.imageName)??"",
      "name": (this.name)??"",
      "sex": this.sex!=null?(this.sex!.toJson()):{},
    };
    return map;
  }
}