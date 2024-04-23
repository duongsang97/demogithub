import 'package:erpcore/components/buttons/buttonDefault.Container.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';

class DynamicPopupMenuComponent extends StatefulWidget {
  const DynamicPopupMenuComponent({super.key,required this.child,this.boxDialog, this.isCenter = false});
  final Widget child;
  final Widget? boxDialog;
  final bool isCenter;
  @override
  State<DynamicPopupMenuComponent> createState() => _DynamicPopupMenuComponentState();
}

class _DynamicPopupMenuComponentState extends State<DynamicPopupMenuComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTapDown: (TapDownDetails detail){
        if(widget.boxDialog != null){
          showDialog(context: context,
            //anchorPoint:detail.localPosition,
            useSafeArea: true,
            traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
            builder: (BuildContext context){
              return Stack(
                children: [
                  Positioned(
                    top: detail.localPosition.dy + 30,
                    right: !widget.isCenter ?  detail.localPosition.dy : 10,
                    left: widget.isCenter ? 10 : null,
                    child: widget.boxDialog?? const SizedBox()
                  )
                ],
              );
            },
          );
        }
      },
    );
  }
}