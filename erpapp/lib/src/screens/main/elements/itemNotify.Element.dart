import 'package:flutter/material.dart';

class ItemNotifyElement extends StatefulWidget {
  ItemNotifyElement({super.key,required this.icon,required this.callback,this.isNoti = false,this.child});
  final String icon;
  final VoidCallback callback;
  final bool isNoti; //true => hiện nút đỏ , false => ẩn nút đỏ
  final Widget? child;//chấm đỏ góc phải => số lượng những tin chưa đọc ( > 0 : hiện , <= 0 : ẩn)
  @override
  State<ItemNotifyElement> createState() => _ItemNotifyElementState();
}

class _ItemNotifyElementState extends State<ItemNotifyElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.callback(),
      child: Stack(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Center(
              child: Image.asset(
                widget.icon,
                height: 20,
                width: 20,
              ),
            ),
          ),
          widget.isNoti == true
          ? (widget.child??SizedBox())
          : SizedBox(),
        ],
      ),
    );
  }
}
