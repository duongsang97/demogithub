import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class ButtonWaitingForApprovalComponent extends StatefulWidget {
  const ButtonWaitingForApprovalComponent({super.key,this.isLoading=false,required this.onPressBrowser,required this.onPressRefuse});
  final bool isLoading;
  final VoidCallback onPressBrowser;
  final VoidCallback onPressRefuse;
  @override
  State<ButtonWaitingForApprovalComponent> createState() => _ButtonWaitingForApprovalComponentState();
}

class _ButtonWaitingForApprovalComponentState extends State<ButtonWaitingForApprovalComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ButtonDefaultComponent(
          isLoading: widget.isLoading,
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          backgroundColor:AppColor.jadeColor,
          title:"Duyệt",
          onPress: (){
            widget.onPressBrowser();
          }
        ),
        ButtonDefaultComponent(
          isLoading: widget.isLoading,
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          backgroundColor:AppColor.brightRed,
          title:"Từ chối",
          onPress: (){
            widget.onPressRefuse();
          }
        )
      ],
    );
  }
}