import 'package:cached_network_image/cached_network_image.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/activations/game/chooseGift.Model.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/utility/image.Utility.dart';

class ChooseGiftComponent extends StatefulWidget {
  const ChooseGiftComponent({ Key? key,this.codeGroup,@required this.listData,required this.funcChooseGift}) : super(key: key);
  final String? codeGroup;
  final List<List<ChooseGiftInfoModel>>? listData;
  final Function(String,List<ChooseGiftInfoModel>) funcChooseGift;
  @override
  _ChooseGiftComponentState createState() => _ChooseGiftComponentState();
}

class _ChooseGiftComponentState extends State<ChooseGiftComponent> {
  List<ChooseGiftInfoModel> giftsSelected = List<ChooseGiftInfoModel>.empty(growable: true);
  bool isChoose = false;
  late Size size;
  //ProgressDialog pr;
   @override
  void initState() {
    // khởi tạo list chọn mặc định
    giftsSelected = List<ChooseGiftInfoModel>.generate((widget.listData != null)?widget.listData!.length:0, (index) => ChooseGiftInfoModel());
    super.initState();
  }


  void onSelectGift(ChooseGiftInfoModel v,int indexGroup){
    try{
      setState(() {
        giftsSelected[indexGroup] = v;
      });
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "onSelectGift chooseGift.Component");
    }
  }

  ChooseGiftInfoModel getItemSelectedByIndexGroup(int indexGroup){
   late ChooseGiftInfoModel result;
    try{
      var temp = giftsSelected[indexGroup];
      result = temp;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getItemSelectedByIndexGroup chooseGift.Component");
    }
    return result;
  }

  bool verifyItemGiftSelect(ChooseGiftInfoModel item){
    late bool result = false;
    try{
      if((item.code != null && item.code!.isNotEmpty) && (item.name != null && item.name!.isNotEmpty)){
        result = true;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "verifyItemGiftSelect chooseGift.Component");
    }
    return result;
  }

  Future<bool> verifyListSelected() async{
    bool result = false;
    try{
      int itemSelectInvalid = 0;
      int totalSelect = widget.listData!.length;
      for(var item in giftsSelected){
        if(verifyItemGiftSelect(item)){
          itemSelectInvalid++;
        }
      }
      
      var resultQuestion = await Alert.showDialogConfirm("Thông báo","Bạn đã chọn $itemSelectInvalid/$totalSelect loại sản phẩm, tiếp tục?");
      if(resultQuestion){
        result= true;
      }
      else{
        result = false;
      }
        }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "verifyListSelected chooseGift.Component");
    }
    return result;
  }
  

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: (size.height*.8)+20,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: size.width,
            height: size.height*.8,
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
                  Expanded(
                    child: (widget.listData != null && widget.listData!.isNotEmpty)?ListView.builder(
                      itemCount: widget.listData!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index){
                        var item = widget.listData?[index];
                        return _buildGroupGift(item!,index);
                      },
                    ):const Text("Không có dữ liệu")
                  ),
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: isChoose?false:true,
                    child: _buildButton(),
                  )
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


  Widget _buildItemSelectGift(ChooseGiftInfoModel item,int indexGroup){
    return GestureDetector(
      onTap: (){
        if(isChoose){
        }
        else{
          onSelectGift(item,indexGroup);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: (giftsSelected.contains(item))?AppColor.azureColor:AppColor.whiteColor,
          border: (giftsSelected.contains(item))?Border.all():null,
          borderRadius: const BorderRadius.all(Radius.circular(10.0))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Radio<ChooseGiftInfoModel>(
                value: item, 
                groupValue: getItemSelectedByIndexGroup(indexGroup), 
                onChanged: (v){
                  if(isChoose){

                  }
                  else{
                    onSelectGift(item,indexGroup);
                  }
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: (item.image != null && item.image!.isNotEmpty)
                  ? GestureDetector(
                    onTap: (){
                      Alert.dialogPhotoView(context,networkImage: handURLImageString(item.image));
                    },
                    child: CachedNetworkImage(
                      imageUrl: ImageUtils.getURLImage(handURLImageString(item.image)), 
                      imageBuilder: (context, imageProvider) => Image(image: imageProvider,),
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )
                  )
                  :const Icon(Icons.image_not_supported)
                ),
                const SizedBox(width: 10,),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${item.name??""} ${(item.total != null)?("(x${item.total})"):""}",style: const TextStyle(fontWeight: FontWeight.bold),),
                        Text(item.note??"",
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.black,fontSize: 13,),
                        ),
                      ],
                    )
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton(){
    return GestureDetector(
      onTap:() async{
        if(await verifyListSelected()){
          LoadingComponent.show();
          var result = await widget.funcChooseGift(widget.codeGroup!,giftsSelected);
          LoadingComponent.dismiss();
          if(result.statusCode == 0){
            AlertControl.push(result.msg??"",type: AlertType.SUCCESS);
            setState(() {
              isChoose = !isChoose;
            });
          }
          else if(result.statusCode == 1){
            AlertControl.push(result.msg??"",type: AlertType.ERROR);
          }
          else{
            AlertControl.push("Có lỗi xảy ra, vui lòng thử lại!",type: AlertType.ERROR);
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
        var result = await Alert.showDialogConfirm("Thông báo","Bạn chắc chắn muốn đóng cửa sổ này!");
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

  Widget _buildGroupGift(List<ChooseGiftInfoModel> listGift, int indexGroup){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 0.4)
      ),
      child: Column(
        children: [
          Text("Bộ sản phẩm ${indexGroup+1}",style: const TextStyle(
            color: AppColor.brightBlue,fontSize: 16,fontWeight: FontWeight.bold
          ),),
          const Divider(thickness: 1,color: AppColor.grey,height: 1,),
          const SizedBox(height: 5,),
          ListView.builder(
            shrinkWrap: true,
            itemCount: listGift.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                child: _buildItemSelectGift(listGift[index],indexGroup),
              );
            }
          )
        ],
      ),
    );
  }



  
}