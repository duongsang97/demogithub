import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';
import 'elements/tagItem.Element.dart';

class TagFilterComponent extends StatefulWidget {
  const TagFilterComponent({ Key? key,required this.tags,required this.onSelect,required this.tagSelected}) : super(key: key);
  final List<PrCodeName> tags;
  final PrCodeName tagSelected;
  final Function(PrCodeName) onSelect;
  @override
  State<TagFilterComponent> createState() => _TagFilterComponentState();
}

class _TagFilterComponentState extends State<TagFilterComponent> {
  late ScrollController controller;
  bool isShowBoxTag = false;
  double boxTagOpacity = 0.0;
  GlobalKey itemSelectedKey = GlobalKey();
  @override
  void initState() {
    controller = new ScrollController();
    controller.addListener(handleScroll);
    super.initState();
  }

  void handleScroll(){
    
    if(itemSelectedKey != null){
      RenderObject? box = context.findRenderObject();
      
    }
    if(controller.offset <=0){
      setState(() {
        isShowBoxTag = false;
      });
    }
    else if(controller.offset >=1 && !isShowBoxTag){
      setState(() {
        isShowBoxTag = true;
      });
    }
    if(controller.offset >=1 && controller.offset<=100){
      setState(() {
        boxTagOpacity=controller.offset/100;
      });
    }
    else{
      setState(() {
        boxTagOpacity=1;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.tags.map<Widget>((e) => 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TagItemElement(item: e,
                    selectedButton: widget.tagSelected,
                    onPress: (v){
                      widget.onSelect(v); 
                  },)
                )
              ).toList()
            ),
          ),
        ],
      )
    );
  }
}