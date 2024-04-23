import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/components/selectBox/selectFile.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';

class BoxChooseUserComponent extends StatefulWidget {
  const BoxChooseUserComponent({ Key? key,required this.listData,required this.onSelect,this.title=""}) : super(key: key);
  final String title;
  final List<PrCodeName> listData;
  final Function(PrCodeName) onSelect;
  @override
  State<BoxChooseUserComponent> createState() => _BoxChooseUserComponentState();
}

class _BoxChooseUserComponentState extends State<BoxChooseUserComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,style: const TextStyle(
          color: AppColor.grey,fontWeight: FontWeight.bold,fontSize: 15
        ),),
        const SizedBox(height: 10,),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: (widget.listData.length + 1),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildIconAddUser();
            } else {
              var item = widget.listData[index - 1];
              return _buildItemUserOverview(item);
            }
          }
        ),
      ],
    );
  }

  Widget _buildIconAddUser() {
    return GestureDetector(
      onTap: () {
        ModalSheetComponent.showBarModalBottomSheet(
          SelectFileBoxComponent(onSelectedType: (v){widget.onSelect(PrCodeName(code: "",name: ""));},),
          formSize:0.4,
          expand: true,
          enableDrag: true
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppColor.azureColor,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 0.1, color: AppColor.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(5, 0), // changes position of shadow
              ),
            ]),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 30,
            color: AppColor.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildItemUserOverview(PrCodeName item){
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(20.0)
        ),
        color: AppColor.jadeColor.withOpacity(0.6)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Row(
        children: [
          _buildNodeStatus(AppColor.azureColor),
          const SizedBox(width: 10,),
          const Text("Nhân viên 1")
        ],
      ),
    );
  }

  Widget _buildNodeStatus(Color nodeColor){
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: nodeColor,
        shape: BoxShape.circle
      ),
    );
  }
}