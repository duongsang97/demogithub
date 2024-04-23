import 'package:flutter/material.dart';

class DataTableCustomComponent extends StatefulWidget {
  const DataTableCustomComponent({super.key,this.border,this.columnWidths,this.columnStyle,this.alignment,
   required this.column,required this.rows
  });
  final TableBorder? border;
  final Map<int, TableColumnWidth>? columnWidths;
  final BoxDecoration? columnStyle;
  final TableCellVerticalAlignment? alignment;
  final List<Widget> column;
  final List<TableRow> rows;
  @override
  State<DataTableCustomComponent> createState() => _DataTableCustomComponentState();
}

class _DataTableCustomComponentState extends State<DataTableCustomComponent> {
  List<TableRow> getTableData(){
    List<TableRow> result = List<TableRow>.empty(growable: true);
    result.insert(0, TableRow(
      decoration: widget.columnStyle,
      children: widget.column
    ));
    result.addAll(widget.rows);
    return result;
  }
  Map<int, TableColumnWidth> getColumnWidthDefault(){
    Map<int, TableColumnWidth> result = {};
    for(var i = 0;i< widget.column.length;i++){
      result.addAll({i:IntrinsicColumnWidth()});
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    var tableData = getTableData();
    return Container(
      alignment: Alignment.center,
      child: Table(  
        defaultVerticalAlignment: widget.alignment??TableCellVerticalAlignment.middle,
        columnWidths: widget.columnWidths??getColumnWidthDefault(),
        border: widget.border,  
        children: tableData,
      )
    );
  }
}