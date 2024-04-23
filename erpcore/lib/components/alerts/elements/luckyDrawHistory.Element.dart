 import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';

class LuckyDrawHistoryElement extends StatefulWidget {
  const LuckyDrawHistoryElement({ Key? key,required this.groupCode,required this.funcGetHistoryLuckyDraw }) : super(key: key);
  final String groupCode;
  final Function(String) funcGetHistoryLuckyDraw;
  @override
  _LuckyDrawHistoryElementState createState() => _LuckyDrawHistoryElementState();
}

class _LuckyDrawHistoryElementState extends State<LuckyDrawHistoryElement> {
  late Size size;
  late List<PrCodeName> listData;
  @override
  void initState() {
    listData = List<PrCodeName>.empty(growable: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      //await pr.show();
      //pr.update(message: "Lấy danh sách lịch sử ...");
      LoadingComponent.show(msg: "Lấy danh sách lịch sử ...");
      var data = await widget.funcGetHistoryLuckyDraw(widget.groupCode);
      LoadingComponent.dismiss();
      if(data.statusCode == 0){
        setState(() {
          listData = data.data;
        });
      }
      else{
        Alert.dialogShow("Thông báo",data.msg??"");
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height*.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Lịch sử quay thưởng",style: TextStyle(fontSize: 16),),
          const SizedBox(height: 10,),
            Expanded(
              child: Scrollbar(
                child: (listData.isNotEmpty)?
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listData.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: _buildItemHistory(index+1,listData[index]),
                    );
                  }
                ):const Center(child: Text("Không có lịch sử quay thưởng"),)
              )
            )
          ],
        ),
      )
    );
  }
  Widget _buildItemHistory(int index,PrCodeName item){
    return Text("$index. ${item.name??""} - ${item.codeDisplay??""}");
  }
}