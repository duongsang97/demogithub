import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:flutter/material.dart';

class SelectFileBoxComponent extends StatefulWidget {
  const SelectFileBoxComponent({ Key? key ,this.onSelectedType, this.selectTypeFile, this.isChooseImage = false, this.isCreatePDF = false}) : super(key: key);
  final Function(String)? onSelectedType;
  final ItemSelectDataActModel? selectTypeFile;
  final bool isChooseImage;
  final bool isCreatePDF;
  @override
  State<SelectFileBoxComponent> createState() => _SelectFileBoxComponentState();
}

class _SelectFileBoxComponentState extends State<SelectFileBoxComponent> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        )
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      height: size.height*.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: !widget.isChooseImage ? [
              _buildActionButton("file","assets/images/icons/folder.png","File"),
              if (widget.isCreatePDF == true) 
                _buildActionButton("createPDF","assets/images/icons/add_pdf.png","Tạo PDF"),
              if (widget.selectTypeFile == null || (widget.selectTypeFile != null && widget.selectTypeFile?.code == "1"))
                _buildActionButton("image","assets/images/icons/camera.png","Chụp hình"),
              if (widget.selectTypeFile == null || (widget.selectTypeFile != null && widget.selectTypeFile?.code == "1"))
                _buildActionButton("gallery","assets/images/icons/gallery.png","Thư viện")
            ] : [
              _buildActionButton("image","assets/images/icons/camera.png","Chụp hình"),
              _buildActionButton("gallery","assets/images/icons/gallery.png","Thư viện")
            ],
          ),
        ],
      )
    );
  }

  Widget _buildActionButton(String type,String image, String label){
    return GestureDetector(
      onTap: (){
        if(widget.onSelectedType != null){
          widget.onSelectedType!(type);
        }
      },
      child: Column(
        children: [
          Image.asset(image,height: 40,width: 40,color: AppColor.jadeColor.withOpacity(0.8),),
          Text(label,style: const TextStyle(color: AppColor.grey,fontSize: 15),)
        ],
      )
    );
  }
}
//"assets/images/icons/folder.png