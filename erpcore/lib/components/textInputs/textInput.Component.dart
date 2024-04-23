import 'package:erpcore/components/buttons/iconButton.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputComponent extends StatefulWidget {
  @override
  _TextInputComponentState createState() => _TextInputComponentState();
  String title="";
  String? placeholder="";
  TextEditingController controller = TextEditingController();
  bool isPassword;
  Widget? icon;
  TextInputType? keyboardType;
  Function? onEditingComplete;
  Function? onFieldSubmitted;
  TextInputAction? txtInputAction;
  FocusNode? focus;
  VoidCallback? forcusListen;
  bool enable;
  int maxLine;
  double heightBox;
  VoidCallback? onReader;
  VoidCallback? onVerify;
  Widget? iconOutSide;
  bool isVerified;
  bool? isVerifyLoading;
  VoidCallback? onTab;
  TextStyle? textStyle;
  List<PrCodeName>? inputFormattersCustom;
  Function(String)? onChanged;
  EdgeInsets? contentPadding;
  TextAlign? textAlign;
  Color? fillColor;
  double borderRadius;
  Function(TapDownDetails)? onTapDown;
  TextInputComponent({super.key, this.borderRadius = 10.0, required this.title,this.placeholder,required this.controller,this.isPassword= false,this.icon,this.keyboardType,this.onEditingComplete,this.txtInputAction,this.onFieldSubmitted,this.focus,this.enable=true,this.maxLine=1,this.heightBox=50, 
    this.onReader,this.onVerify,this.isVerified=false,this.onTab,this.textStyle,this.onChanged,this.isVerifyLoading=false,this.inputFormattersCustom, this.iconOutSide,this.contentPadding,this.textAlign,this.forcusListen,this.fillColor, this.onTapDown
  });
}

class _TextInputComponentState extends State<TextInputComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    if(widget.focus !=null && widget.forcusListen != null){
      
      widget.focus!.addListener((){
        widget.forcusListen!();
      });
    }
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void callBack(){

  }
  void onFieldSubmitted(String v){

  }

  List<TextInputFormatter> getInputFormatters(){
    List<TextInputFormatter> result = List<TextInputFormatter>.empty(growable: true);
    try{
      if(widget.inputFormattersCustom != null && widget.inputFormattersCustom!.isNotEmpty){
        for(PrCodeName item in widget.inputFormattersCustom??[]){
          try{
            if(int.parse(item.code??"-1") ==0){
              result.add(FilteringTextInputFormatter.deny(RegExp(item.name??""),replacementString: item.codeDisplay??""));
            }
            else if(int.parse(item.code??"-1") ==1){
              result.add(FilteringTextInputFormatter.allow(RegExp(item.name??""),replacementString: item.codeDisplay??""));
            }
            else if(int.parse(item.code??"-1") ==2){
              result.add(FilteringTextInputFormatter.digitsOnly);
            }
            else if(int.parse(item.code??"-1") ==3){
              result.add(FilteringTextInputFormatter.singleLineFormatter);
            }
            else if(int.parse(item.code??"-1") ==4){
              result.add(LengthLimitingTextInputFormatter(int.parse(item.name??"")));
            }
          }
          catch(ex){}
        }
      }
    }
    catch(ex){}
    return result;
  }

    Widget? _buildIconRightInput(){
    Widget? result;
    if(widget.onReader != null){
      result = GestureDetector(
        onTap: (){
          widget.onReader!();
        },
        child: const Icon(Icons.qr_code_scanner,size: 25,color: AppColor.brightBlue,),
      );
    }
    else if(widget.icon != null){
      result = widget.icon;
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: widget.heightBox,//??50
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){  
                if(widget.onTab!=null) {
                  widget.onTab!();
                }
                else if(widget.onReader != null){
                  widget.onReader!();
                }
              },
              onTapDown: (details) {
                if (widget.onTapDown != null) {
                  widget.onTapDown!(details);
                }
              },
              child: TextFormField(
                textAlign: widget.textAlign??TextAlign.left,
                inputFormatters: getInputFormatters(),
                onChanged: (String s){
                  if(widget.onChanged != null){
                    widget.onChanged!(s);
                  }
                },
                obscureText: widget.isPassword,
                maxLines: widget.maxLine,
                enabled: widget.enable,
                textInputAction:widget.txtInputAction ?? TextInputAction.done,
                keyboardType: widget.keyboardType ?? TextInputType.text,
                onFieldSubmitted: (String v){
                  if(widget.onFieldSubmitted != null){
                    widget.onFieldSubmitted!(v);
                  }
                },
                controller: widget.controller,
                focusNode: widget.focus,
                style: widget.textStyle,
                decoration: InputDecoration(
                  fillColor: widget.fillColor,
                  filled: widget.fillColor !=null,
                  //isDense: true,
                  labelText: widget.title,
                  contentPadding: widget.contentPadding?? const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
                  labelStyle: const TextStyle(fontSize: 15,color: AppColor.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius),),
                    borderSide: const BorderSide(color: AppColor.grey,width: 0.5,style: BorderStyle.solid)
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius),),
                    borderSide: const BorderSide(color: AppColor.brightRed,width: 0.5,style: BorderStyle.solid)
                  ),
                  focusedErrorBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius),),
                    borderSide: const BorderSide(color: AppColor.brightRed,width: 0.5,style: BorderStyle.solid)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius),),
                    borderSide: const BorderSide(color: AppColor.grey,width:0.5,style: BorderStyle.solid)
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius),),
                    borderSide: const BorderSide(color: AppColor.grey,width:0.5,style: BorderStyle.solid)
                  ),
                  suffixIcon: _buildIconRightInput(),
                  //contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: widget.placeholder ?? "Nhập giá trị..."),
              ),
            ),
          ),
          Visibility(
            visible: (widget.onVerify != null)?true:false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButtonComponent(
                  isLoading: widget.isVerifyLoading??false,
                  icon: widget.iconOutSide != null ? widget.iconOutSide! : Image.asset("assets/images/icons/send.png",width: 25,), 
                  onPress: (){
                    if(widget.onVerify != null){
                      widget.onVerify!();
                    }
                  }
                ),
              )
          ),
        ],
      )
    );
  }
}