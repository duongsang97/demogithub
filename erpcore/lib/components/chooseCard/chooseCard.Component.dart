import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';

class ChooseCardComponent extends StatefulWidget {
  const ChooseCardComponent({ Key? key,this.codeGroup,required this.funcGetCardbyCodeName}) : super(key: key);
  final String? codeGroup;
  final Function(String,String) funcGetCardbyCodeName;

  @override
  _ChooseCardComponentState createState() => _ChooseCardComponentState();
}

class _ChooseCardComponentState extends State<ChooseCardComponent> {

  final List<PrCodeName> listCard = List<PrCodeName>.empty(growable: true);
  late PrCodeName cardSelected;
  late Size size;
  bool isChoose = false;
  late PrCodeName cardInfo;
  //ProgressDialog pr;
  @override
  void initState() {
    listCard.addAll([
      PrCodeName(code: "VT",name:"Viettel"),
      PrCodeName(code: "MBF",name: "Mobifone"),
      PrCodeName(code: "VNP",name: "Vinaphone")
    ]);
    //pr = new ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true); 
    super.initState();
  }
  String getAssetImageByCode(String code){
    String result ="";
    switch(code){
      case "VT":
        result = "assets/images/viettel_100k.png";
      break;
      case "MBF":
        result = "assets/images/mobi_100k.png";
      break;
      case "VNP":
        result = "assets/images/vina_100k.png";
      break;

    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: (size.height*.4)+20,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: size.width,
            height: size.height*.4,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Material(
              child: Column(
                children:[
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: listCard.map((e) => _buildItemSelectCard(e)).toList()
                  ),
                  const SizedBox(height: 10,),
                  (cardInfo.code!= null && isChoose)?_buildCardInfo(cardInfo)
                  : _buildButton(),
                ]
              )
            )
          ),
          Positioned(
            top: 0,
            right: 10,
            child: _buildButtonClosePopup()
          )
        ],
      ),
    );
  }


  Widget _buildItemSelectCard(PrCodeName item){
    return GestureDetector(
      onTap: (){
        if(isChoose){

        }
        else{
          setState(() {
            cardSelected = item;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(getAssetImageByCode((item.code)!),
            width: size.width/4,
          ),
          Radio<PrCodeName>(
            value: item, 
            groupValue: cardSelected, 
            onChanged: (v){
              if(isChoose){
      
              }
              else{
                setState(() {
                  cardSelected = v!;
                });
              }
            }
          )
        ],
      ),
    );
  }

  Widget _buildButton(){
    return GestureDetector(
      onTap:() async{
        //await pr.show();
        //pr.update(message: "Đang lấy mã thẻ...");
        LoadingComponent.show(msg: "Đang lấy mã thẻ...");
        var card = await widget.funcGetCardbyCodeName(widget.codeGroup!,cardSelected.code!);
        LoadingComponent.dismiss();
        //await pr.hide();
        if(card != null && card.statusCode == 0){
          setState(() {
            isChoose = !isChoose;
            cardInfo = card.data;
          });
        }
        else{
          if(card!= null && card.statusCode==1){
            Alert.dialogShow("Thông báo",card.msg??"");
          }
          else{
            AlertControl.push("Có lỗi xảy ra, vui lòng liên hệ quản lý!", type: AlertType.ERROR);
          }
          
        }
            },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          borderRadius: const BorderRadius.all(Radius.circular(20.0))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: const Center(
          child: Text("Chọn",style: TextStyle(color: Colors.black,fontSize:16),),
        ),
      ),
    );
  }

  Widget _buildButtonClosePopup(){
    return GestureDetector(
      onTap:() async{
        var result = await Alert.showDialogConfirm("Thông báo","Bạn chắc chắn muốn đóng màn hình này?");
        if(result){
          Navigator.pop(context);
        }
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[900]
        ),
        child: const Center(
          child: Icon(Icons.close,size: 24,color: Colors.white,),
        ),
      ),
    );
  }

  Widget _buildCardInfo(PrCodeName item){
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(color: Colors.grey,width: 0.5)
      ),
      child: Column(
        children: [
          _buildLabelValue("Số seri:",item.code!),
          const SizedBox(height: 10,),
          _buildLabelValue("Mã thẻ:",item.name!),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value){
    return Row(
      children: [
        Text(label,style: const TextStyle(fontSize: 14),),
        const SizedBox(width: 10,),
        Text(value,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
      ],
    );
  }
}