import 'dart:io';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';

class StorageUtility{
  static Future<double> getSizeDBStorage(String dbPath) async {
    double size = 0.0;
    try {
      if (dbPath.isNotEmpty) {
        var directory = Directory(dbPath);
        if (await directory.exists()) {
          var listFile = directory.listSync();
          for (var file in listFile) {
            if (await file.exists() && file.path.isNotEmpty ) {
              final sizeSubFile = File(file.path).lengthSync();
              size += sizeSubFile;
            }
          }
        }
      } 
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getSizeDBStorage");
      return size;
    }
    return size;
  }

  static Future<double> getSizeFilesStorage(String filesPath) async {
    double size = 0.0;
    try {
      if (filesPath.isNotEmpty) {
        var directory = Directory(filesPath);
        if (await directory.exists()) {
          var listFile = directory.listSync();
          for (var file in listFile) {
            var subDirectory = Directory(file.path);
              if (await subDirectory.exists()) {
                var listSubFile = subDirectory.listSync();
                for (var subFile in listSubFile) {
                  if (await subFile.exists() && subFile.path.isNotEmpty ) {
                    final sizeSubFile = File(subFile.path).lengthSync();
                    size += sizeSubFile;
                  }
                }
              }
          }
        }
      } 
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getSizeFilesStorage");
      return size;
    }
    return size;
  }

  static Future<bool> deleteFilesByDate(String filesPath, TextEditingController txtFromDateDeleteController, TextEditingController txtToDateDeleteController) async {
    if (filesPath.isNotEmpty) {
      var directory = Directory(filesPath);
        if (await directory.exists()) {
        var listFile = directory.listSync();
        LoadingComponent.show(msg: "Đang xóa dữ liệu...");
        if (txtFromDateDeleteController.text.isNotEmpty && txtToDateDeleteController.text.isNotEmpty) {
          DateTime fromDate = DateTime.parse(txtFromDateDeleteController.text);
          DateTime toDate = DateTime.parse(txtToDateDeleteController.text);
          bool hasDelete = false;
          for (var file in listFile) {
            List<String> temp = file.path.split('/');
            if (DateTime.tryParse(temp[temp.length - 1]) != null) {
              var time = DateTime.tryParse(temp[temp.length - 1]);
              if (!time!.isBefore(fromDate) && !time.isAfter(toDate) && !time.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
                hasDelete = true;
                file.deleteSync(recursive: true);
              } 
            }
          }
          if (hasDelete) {
            LoadingComponent.dismiss();
            return true;
          } else {
            LoadingComponent.dismiss();
            return false;
          }
        }
        LoadingComponent.dismiss();
        }
        return false;
    } else {
      LoadingComponent.dismiss();
      return false;
    }
  }

  static Future<int> checkTypePath(String path) async{
    var temp = FileSystemEntity.typeSync(path);
    if (temp == FileSystemEntityType.file) {
      return 1;
    } else if (temp == FileSystemEntityType.directory) {
      return 0;
    } else {
      return -1;
    }
  }
}