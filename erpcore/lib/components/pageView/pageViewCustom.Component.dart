import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class PageViewComponentCustom extends StatefulWidget {
  const PageViewComponentCustom({super.key,required this.list,required this.listTitle,required this.listBool,this.callback,this.title=""});
  final VoidCallback? callback;
  final List<Widget> list;
  final List<String> listTitle;
  final List<bool> listBool;
  final String title;
  @override
  State<PageViewComponentCustom> createState() => _PageViewComponentCustomState();
}
  late Size size;
  double bottomPadding = 0.0;
  PageController controller=PageController();
  const _kDuration = Duration(milliseconds: 0);
  const _kCurve = Curves.ease;

class _PageViewComponentCustomState extends State<PageViewComponentCustom> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return  Container(
      height: size.height*0.7,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical:10),
      child: Column(
        children: [
        Text(widget.title,style: TextStyle(color: AppColor.grey,fontSize: 16,fontWeight: FontWeight.bold),),
        Container(width:size.width*.6,child: Divider(height: 1,thickness: 2,color: AppColor.darkText,)),
        SizedBox(height: 5,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.listTitle.map((e) => 
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: widget.listTitle.indexOf(e)<=_currentStep?AppColor.brightBlue:AppColor.whiteColor
                    ),
                    child: Text(e,style: TextStyle(color: widget.listTitle.indexOf(e)<=_currentStep?AppColor.whiteColor:AppColor.darkText),),),
                  widget.listTitle.indexOf(e)!=widget.listTitle.indexOf(widget.listTitle.last)
                  ?Icon(Icons.double_arrow_sharp):SizedBox()
                ],
              ),
              ).toList(),
            ),
          ),
          Expanded(
            child: PageView(
            children:
              widget.list,
              scrollDirection: Axis.horizontal,         
              // reverse: true,
              // physics: BouncingScrollPhysics(),
              controller: controller,
              onPageChanged: (num){
                setState(() {
                  _currentStep=num;
                });
              }
          ),),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonDefaultComponent(onPress: (){setState(() {
                if(_currentStep>0){
                  _currentStep -=1;
                   controller.previousPage(
                        duration: _kDuration, curve: _kCurve);
                }
              });},title: "< Quay lại",width:size.width*.3),

              // ButtonDefaultComponent(onPress: (){setState(() {
              //   if(_currentStep<widget.list.length-1 && widget.listBool[_currentStep]){
              //     _currentStep += 1;
              //     controller.nextPage(duration: _kDuration, curve: _kCurve);
              //   }
              // }
              // );
              //   if(_currentStep==widget.list.length-1 && widget.listBool[_currentStep]){
              //     widget.callback;
              //   } 
              // },title: _currentStep<widget.list.length-1?"Tiếp tục >":"Lưu",width:size.width*.3)
              ElevatedButton(child: Text("Lưu"),onPressed: (){if(_currentStep==widget.list.length-1 && widget.listBool[_currentStep]){
                  widget.callback;
                }},)
            ],
          )
        ],
      ),
    );
        
  }
   tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    _currentStep < (widget.list.length - 1) ? setState(() => _currentStep += 1): null;
  }
  cancel(){
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
