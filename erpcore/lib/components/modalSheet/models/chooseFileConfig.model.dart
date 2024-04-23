import 'package:file_picker/file_picker.dart';

class ChooseFileConfigModel{
  FileType type = FileType.any;
  bool formCamera = false;
  bool formDisk = false;
  bool isMultiple = false;
  List<String>? allowedExtensions = [];
  ChooseFileConfigModel({this.allowedExtensions,this.isMultiple = false,this.type = FileType.any,this.formCamera=false,this.formDisk=false});
}
