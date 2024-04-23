import 'package:flutter/material.dart';

class OverlayUtils{
  static final OverlayUtils _singleton = OverlayUtils._();
  static OverlayUtils get instance => _singleton;
  OverlayUtils._();
  static final List<Widget> _overlayChildren = List<Widget>.empty(growable: true);
  static TransitionBuilder init({TransitionBuilder? builder,}){
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, OverlayWidget(child: child,children: _overlayChildren,));
      } else {
        return OverlayWidget(child: child,children: _overlayChildren,);
      }
    };
  }

  static void pushChild(List<Widget> children){
    _overlayChildren.addAll(children);
  }

}

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key,this.child,this.children});
  final Widget? child;
  final List<Widget>? children;
  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {

  List<Widget> get boxContain{
    List<Widget> result = List<Widget>.empty(growable: true);
    if(widget.child != null){
      result.add(widget.child!);
    }
    if(widget.children != null && widget.children!.isNotEmpty){
      result.addAll(widget.children!);
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child:  Stack(
        alignment: Alignment.center,
        children: boxContain
      ),
    );
  }
}