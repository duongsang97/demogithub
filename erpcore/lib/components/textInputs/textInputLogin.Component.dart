import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class TextInputLoginComponent extends StatefulWidget {
  const TextInputLoginComponent({super.key,required this.txtController,this.hintText="",required this.icon,this.isPassword=false});
  final TextEditingController txtController;
  final bool isPassword;
  final String hintText;
  final Icon icon;
  @override
  State<TextInputLoginComponent> createState() => _TextInputLoginComponentState();
}

class _TextInputLoginComponentState extends State<TextInputLoginComponent> {
  bool isShowPassword = false;
  @override
  void initState() {
    setState(() {
      isShowPassword = widget.isPassword;
    });
    super.initState();
  }
  
  Widget get iconEye{
    if(isShowPassword){
      return const Icon(Icons.visibility_outlined);
    }
    else{
      return const Icon(Icons.visibility_off_outlined);
    }
  }
  Widget? get suffixIcon{
    Widget? result;
    if(widget.isPassword){
      result = GestureDetector(
        onTap: (){
          setState(() {
            isShowPassword = !isShowPassword;
          });
        },
        child: iconEye,
      );
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        //color: Colors.white,
        //border: Border.all()
        border: Border(
          bottom: BorderSide( //                    <--- top side
            color: AppColor.nearlyBlack.withOpacity(0.6),
            width: 0.5,
          ),
        ),
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        obscureText: isShowPassword,
        controller: widget.txtController,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: widget.icon,
          hintText: widget.hintText,
          suffixIcon: suffixIcon
        )
      ),
    );
  }
}
