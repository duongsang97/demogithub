import 'dart:async';
import 'dart:io' show Platform;
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/buttons/buttonLogin.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoxVerifyOTPComponent extends StatefulWidget {
  const BoxVerifyOTPComponent({ Key? key ,this.onPress,this.email,this.numberPhone,this.reSend,this.oTPTimeOut =60,this.oTPLength=4,this.note="",this.otp="",this.showOTP=0}) : super(key: key);  final Function(String)? onPress;
  final String? email;
  final String? numberPhone;
  final VoidCallback? reSend;
  final int oTPTimeOut;
  final int oTPLength;
  final int showOTP; // hiển thị OTP khi có lỗi nhà mạng
  final String otp; // otp
  final String note; // ghi chú
  @override
  State<BoxVerifyOTPComponent> createState() => _BoxVerifyOTPComponentState();
}

class _BoxVerifyOTPComponentState extends State<BoxVerifyOTPComponent> {
  List<FocusNode> listFocus = new List<FocusNode>.empty(growable: true);
  List<TextEditingController> listTextController = new List<TextEditingController>.empty(growable: true);
  late Size size;
  late Timer timer;
  int start = 59;
  String finalOTPCode ="";
  void handleOTPForm(){
    for(var i =0;i<widget.oTPLength;i++){
      listTextController.add(new TextEditingController());
      listFocus.add(new FocusNode());
      listFocus[i].addListener(() {
        if (listFocus[i].hasFocus){
          listTextController[i].clear();
        }
      });
    }
  }

  @override
  void initState() {
    start = widget.oTPTimeOut;
    handleOTPForm();
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       startTimer();
    });
  }

  @override
  void dispose() {
    try{
      timer.cancel();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "dispose otpVerify.Component");
    }
    super.dispose();
  }

     // xử lý thời gian đếm ngược OTP
  void startTimer() 
  {
    start =widget.oTPTimeOut;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec,(Timer timer) {
        if (start == 0) {
          timer.cancel();
        } else {
           setState(() {
            start --;
          });
        }
      },
    );
  }

  String getObjectSendTo(){
    String obj ="số điện thoại";
    try{
      if(widget.numberPhone != null && widget.numberPhone!.isNotEmpty){
        obj = "số điện thoại ${widget.numberPhone!}";
      }
      else if(widget.email != null && widget.email!.isNotEmpty){
         obj = "email ${widget.numberPhone!}";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getObjectSendTo otpVerify.Component");
    }
    return obj;
  }

  bool validateOTPInput(){
    for(var item in listTextController){
      if(item.text.isEmpty){
        return false;
      }
    }
    return true;
  }
  String handleOTP(){
    String result = "";
    for(var item in listTextController){
      result+=item.text;
    }
    return result;
  }

  List<Widget> handleOTPBoxRender(){
    List<Widget> result = List<Widget>.empty(growable: true);
    for(int i =0;i<listTextController.length;i++){
      if(i+1 != listTextController.length){
        result.add( _buildTextFeild(generateKeyCode(),listTextController[i],listFocus[i],true,nextFocus: listFocus[i+1]),);
      }
      else{
        finalOTPCode = generateKeyCode();
        result.add( _buildTextFeild(finalOTPCode,listTextController[i],listFocus[i],true,onSucess: () async{

         }),);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      height: size.height*.7,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            const Text("XÁC NHẬN OTP",style: TextStyle(color: AppColor.brightBlue,fontWeight: FontWeight.bold,fontSize: 16),),
            const SizedBox(height: 5,),
            Text("Mã OTP vừa được gửi đến ${getObjectSendTo()} của Quý Khách, Vui lòng nhập OTP xác nhận",
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColor.grey,fontSize: 14),
            ),
            const SizedBox(height: 30,),
            buildBoxInputOTP(),
            const SizedBox(height: 20,),
            // Text("Hiệu lực còn 150s",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: type: AlertType.ERROR,fontSize: 14),
            // ),
            const SizedBox(height: 10,),
            ButtonLoginComponent(
              btnLabel: "Xác thực",
              onPressed: (){
                if(widget.onPress != null && validateOTPInput()){
                  widget.onPress!(handleOTP());
                }
                else{
                  AlertControl.push("OTP không đúng định dạng", type: AlertType.ERROR);
                }
              },
            ),
            const SizedBox(height: 10,),
            Visibility(
              visible: (start != 0),
              child: Text("OTP hết hiệu lực trong ${start}s",style: const TextStyle(color: AppColor.brightRed),)
            ),
            Visibility(
              visible: (start == 0),
              child: TextButton(
                child: const Text("Gửi lại mã OTP",style: TextStyle(
                  color: AppColor.jadeColor
                ),),
                onPressed: (){
                  if(widget.reSend != null){
                    widget.reSend!();
                    startTimer();
                  }
                },
              )
            ),
            Visibility(
              visible: widget.showOTP==1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RichText(
                  text: TextSpan(
                    text: widget.note,
                    style: const TextStyle(fontSize: 14,),
                    children: <TextSpan>[
                      TextSpan(text: widget.otp,style: const TextStyle(fontSize: 15,color: AppColor.brightRed,fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoxInputOTP(){
    return Center(
      child: GridView(
        padding: const EdgeInsets.symmetric(vertical: 5),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: listTextController.length,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 6.0,
        ),
        shrinkWrap: true,
        children: handleOTPBoxRender()
      ),
    );
  }
  // Widget _buildItemOTPInput(){
  //   return Container(
  //     height: 50,
  //     width: 50,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.rectangle,
  //       color: AppColor.azureColor,
  //       border: Border.all(color: AppColor.grey,width: 0.3)
  //     ),
  //     child: TextField(
  //       textAlign: TextAlign.center,
  //       textInputAction: TextInputAction.next,
  //       maxLength: 1,
        
  //     ),
  //   );
  // }

   Widget _buildTextFeild(String code,TextEditingController controller,FocusNode focus,bool autoFocus,{FocusNode? nextFocus,VoidCallback? onSucess}){
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
          color: AppColor.azureColor,
          border: Border.all(color: AppColor.grey,width: 0.3)
        ),
        child:  Center(
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            onFieldSubmitted: (v)
            {
              if(onSucess != null){
                onSucess();
              }
            },
            focusNode: focus,
            onTap: (){
              if(controller.text.isNotEmpty){
                controller.clear();
              }
            },
            onChanged: (value){
              if(value.isNotEmpty && nextFocus!= null)
              {
                FocusScope.of(context).requestFocus(nextFocus);
              }
              else{
                if(code == finalOTPCode){
                  onSucess!();
                }
              }
            },
            autofocus: autoFocus,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textInputAction: TextInputAction.done,
            keyboardType: Platform.isIOS?const TextInputType.numberWithOptions(signed: true, decimal: true): TextInputType.number,
            controller: controller,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.grey,fontSize: listTextController.length<=4?18:20,fontWeight: FontWeight.w600,),
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintStyle: TextStyle(color: AppColor.grey,fontSize: 15),
            ),
          ),
        )
    );
  }
}