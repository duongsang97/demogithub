import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class SendBoxElement extends StatefulWidget {
  const SendBoxElement({ Key? key,this.onSend,this.txtController}) : super(key: key);
  final VoidCallback? onSend;
  final TextEditingController? txtController;
  @override
  State<SendBoxElement> createState() => _SendBoxElementState();
}

class _SendBoxElementState extends State<SendBoxElement> {
  late Size size;
  double safeBottomPadding =0.0;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    safeBottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      constraints: BoxConstraints(
        minHeight: 80,
        maxHeight: 200,
        maxWidth: size.width,
      ),
      width: size.width,
      padding: EdgeInsets.only(bottom: safeBottomPadding),
      decoration: const BoxDecoration(
        boxShadow: [
        ],
        color: AppColor.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10,),
          Expanded(
            child: Container(
              child: _buildSendInput(),
            )
          ),
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              if(widget.onSend != null){
                widget.onSend!();
              }
            },
            child: Image.asset("assets/images/icons/send.png",height: 30,width: 30,)
          ),
          const SizedBox(width: 10,)
        ],
      ),
    );
  }

  Widget _buildSendInput(){
    return Container(
      height: 40,
      child: TextFormField(
        onChanged: (v)=>{

        },
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(color: AppColor.grey),
        decoration: const InputDecoration(
          hintText: "nhập nội dung",
          hintStyle: TextStyle(color: AppColor.grey,fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0),),
            borderSide: BorderSide(color: AppColor.grey,width: 2,style: BorderStyle.solid)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0),),
            borderSide: BorderSide(color: AppColor.grey,width: 2,style: BorderStyle.solid)
          ),
        ),
        controller: widget.txtController,
      )
    );
  }
}