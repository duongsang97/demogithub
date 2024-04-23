// import 'package:erp/src/models/apps/itemMenuInfo.Model.dart';
// import 'package:flutter/material.dart';

// class ItemMenuDrawer extends StatelessWidget{
//   final ItemMenuInfoModel item;
//   ItemMenuDrawer({Key? key,required this.item}):super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: (){},
//       style: TextButton.styleFrom(
//         foregroundColor: (item.selected)! ? Color(0x44000000) : null,
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           item.icon!,
//           item.widthBox!,
//           Expanded(
//             child: Text(
//               item.nameDisplay??'',
//               style: item.titleStyle,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }