import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';

class DevModeScreen extends StatefulWidget {
  const DevModeScreen({super.key});

  @override
  State<DevModeScreen> createState() => _DevModeScreenState();
}

class _DevModeScreenState extends State<DevModeScreen> {
  bool isDevMode =false;
  TextEditingController txtServerURLController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      isDevMode = PreferenceUtility.getBool(AppKey.keyDevMode);
      txtServerURLController.text = PreferenceUtility.getString(AppKey.keyServerDevModeURL);
      if(txtServerURLController.text.isEmpty){
        txtServerURLController.text = getServerName(false);
        PreferenceUtility.saveString(AppKey.keyServerDevModeURL,txtServerURLController.text);
      }
      setState(() {});
    });
    super.initState();
  }
  @override
  void dispose() {
    txtServerURLController.dispose();
    super.dispose();
  }
  void changeDevModeStatus(bool status) async{
    isDevMode = !isDevMode;
    await PreferenceUtility.saveBool(AppKey.keyDevMode,isDevMode);
    if(!isDevMode){
      PreferenceUtility.saveString(AppKey.keyServerDevModeURL,getServerName(false));
    }
    setState(() {});
  }
  void save() async{
    bool question = await Alert.showDialogConfirm("Lưu ý","Sự thay đổi cấu hình này có thể khiến các chức năng của ứng dụng không hoạt động");
    if(question){
      await PreferenceUtility.saveString(AppKey.keyServerDevModeURL,txtServerURLController.text);
      AlertControl.push("Thành công", type: AlertType.SUCCESS);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20,bottom: 10,left: 5,right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Trạng thái: "),
              const SizedBox(width: 10,),
              Switch(
                value: isDevMode,
                activeColor: Colors.red,
                onChanged: changeDevModeStatus
              ),
            ],
          ),
          if(isDevMode)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              TextInputComponent(
                heightBox: 45,
                title: "Server URL *", 
                placeholder: "Nhập giá trị",
                controller: txtServerURLController,
              ),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonDefaultComponent(
                  title: "Lưu", 
                  onPress: (){
                    save();
                  }
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}