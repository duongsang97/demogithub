import 'package:erp/src/screens/profile/pages/identify/pages/authencity/authencity.Controller.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/components/buttons/buttonDefault.Container.dart';

class AuthenticityScreen extends GetWidget<AuthenticityController>{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.all(15.0),
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Xác thực 2 bước", style: TextStyle(color: AppColor.nearlyBlack, fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 10.0),
                  Obx(() => FlutterSwitch (
                    showOnOff: true,
                    value: controller.authValue.value,
                    activeText: "Bật",
                    inactiveText: "Tắt",
                    inactiveColor: AppColor.brightRed,
                    activeColor: AppColor.greenMonth,
                    activeTextFontWeight: FontWeight.w700,
                    inactiveTextFontWeight: FontWeight.w700,
                    valueFontSize: 12,
                    height: 25,
                    width: 55,
                    toggleSize: 20,
                    onToggle: (val) {
                      controller.onChangedStatusAuth(val);
                    },
                  )),
                ],
              ),
            ),
            Obx(() => Visibility(
              visible: controller.authValue.value,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.listAuth.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index){
                  return _buildItemAuth(controller.listAuth[index], onChangeSelected: (val) {
                    controller.onChangedSelectMethod(val);
                  } );
                }  
              ),
            )),
            Obx(() => _buildQr(size, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildQr(Size size, BuildContext context) {
    Widget result = Container();
    result = Visibility(
      visible: controller.authValue.value && controller.isAuth.value == false,
      child: Column(
        children: [
          controller.googleAuthQR.value.isNotEmpty ? GestureDetector(
            onLongPress:(){
              controller.onOpenOptionImage();
            },
            child: Image.memory(controller.googleAuthQR.value, width: 160, height: 160, fit: BoxFit.cover)
          ) : Container(),
          Text("Sử dụng ${controller.getTitleAuth()} authenicator để quét QRCODE \n Nhấn giữ QRCODE để sao chép mã xác thực", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppColor.nearlyBlack)),
          SizedBox(
            width: size.width,
            child: Row(
              children: [
                Expanded(
                  child: TextInputComponent(
                    heightBox: 40,
                    title: "Khóa thiết lập", 
                    controller: controller.verifyCodeController,
                    icon: AnimatedContainer(
                      duration: Duration(milliseconds: 700), 
                      child: Icon(Icons.check_circle, size: 19, color: controller.getColorStatusCheck())
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                ButtonDefaultComponent(title: "Kiểm tra", onPress: () {
                  controller.onCheckAuthCode(type: controller.authMethod.value.code ?? "");
                }, width: 90, isLoading: controller.isLoading.value, )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ButtonDefaultComponent(title: "Thiết lập", onPress: () {
              controller.onSetAuthCode(type: controller.authMethod.value.code ?? "");
            }, width: 120, isLoading: controller.isLoading.value, ),
          )
        ],
      ),
    );
    return result;
  }

  Widget _buildItemAuth(ItemSelectDataActModel item, {Function(ItemSelectDataActModel)? onChangeSelected}) {
    Widget result = GestureDetector(
      onTap: (){
        if (onChangeSelected != null) {
          onChangeSelected(item);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColor.nearlyBlack),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Image.asset(item.linkFile ?? "", width: 25, height: 25)
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 5.0),
                child: Text(item.name ?? "", style: TextStyle(fontSize: 13, color: AppColor.nearlyBlack), textAlign: TextAlign.left)
              )
            ),
            Radio(value: item, groupValue: controller.authMethod.value, onChanged: (ItemSelectDataActModel? val) {
              if (onChangeSelected != null) {
                onChangeSelected(item);
              }
            })
          ],
        ),
      ),
    );
    return result;
  }
}