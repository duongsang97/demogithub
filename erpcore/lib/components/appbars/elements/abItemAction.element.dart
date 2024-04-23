import 'package:flutter/material.dart';

class AbItemActionElement extends StatefulWidget {
  const AbItemActionElement({super.key,required this.icon,required this.callback,this.isNoti = false,this.child
  });
  final Widget icon;
  final VoidCallback callback;
  final bool isNoti;
  final Widget? child;

  @override
  State<AbItemActionElement> createState() => _AbItemActionElementState();
}

class _AbItemActionElementState extends State<AbItemActionElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.callback(),
      child: Stack(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
            ),
            child: Center(
              child: widget.icon
            ),
          ),
          widget.isNoti == true ? (widget.child??const SizedBox()): const SizedBox(),
        ],
      ),
    );
  }
}