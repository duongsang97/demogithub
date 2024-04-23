import 'package:flutter/material.dart';

class StringLabelValueComponent extends StatefulWidget {
  const StringLabelValueComponent({ Key? key ,this.label,this.value,this.labelStyle,this.valueStyle}) : super(key: key);
  final String? label;
  final String? value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  @override
  State<StringLabelValueComponent> createState() => _StringLabelValueComponentState();
}

class _StringLabelValueComponentState extends State<StringLabelValueComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child : RichText(
        text: TextSpan(
          text: widget.label,
          style:  widget.labelStyle,
          children: <TextSpan>[
            TextSpan(text: widget.value, style: widget.valueStyle),
          ],
        ),
      )
    );
  }
}