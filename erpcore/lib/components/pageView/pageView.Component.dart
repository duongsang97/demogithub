import 'package:flutter/material.dart';

class PageViewComponent extends StatefulWidget {
  const PageViewComponent({super.key,required this.list,this.callback});
  final VoidCallback? callback;
  final List list;
  @override
  State<PageViewComponent> createState() => _PageViewComponentState();
}
  double bottomPadding = 0.0;
class _PageViewComponentState extends State<PageViewComponent> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  late Size size ;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return  Column(
      children: [
        Expanded(
          child: Stepper(
          controlsBuilder: (context, details) => Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            _currentStep>0?Expanded(
              child: ElevatedButton(
                onPressed: details.onStepCancel,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.arrow_back_ios_rounded),
                    Text("Quay về"),
                  ],
                ),
              ),
            ):SizedBox(width: size.width*0.4,),
            const SizedBox(width:5),
             _currentStep < (widget.list.length - 1)?Expanded(
               child: ElevatedButton(
                onPressed: details.onStepContinue,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Tiếp tục'),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
                           ),
             )
            :Expanded(
              child: ElevatedButton(
                onPressed: widget.callback,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Lưu'),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              ),
            ),
                    ],),
          ),
            type: stepperType,
            physics: const ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue:  continued,
            onStepCancel: cancel,
            steps: widget.list.map<Step>((e) => 
             Step(
                title: Text(e['name'],style: const TextStyle(fontSize: 13),),
                content: Column(
                  children: <Widget>[e['widget']],
                ),
                isActive: _currentStep >= 0,
                state: _currentStep >= widget.list.indexOf(e) ?
                StepState.complete : StepState.disabled,
              ),
            ).toList()
          ),
        ),
      ],
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
