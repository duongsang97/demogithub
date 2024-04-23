import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:erp/src/screens/systemInfo/systemInfo.Controller.dart';
import 'package:get/get.dart';
import 'package:erpcore/utility/app.Utility.dart';

class AppSizeInfoElement extends StatelessWidget {
  const AppSizeInfoElement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SystemInfoController>();
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container( alignment: Alignment.centerLeft, child: const Text("Thông tin dung lượng", style: TextStyle(color: AppColor.laSalleGreen, fontSize: 18, fontWeight: FontWeight.w700),)),
          const SizedBox(height: 10),
          Obx(() => AppSizeItem(title: "Dung lượng còn lại hệ thống", content: formatBytes(controller.convertGBtoBytes(controller.freeStorage.value.toInt()), 2))),
          const SizedBox(height: 5),
          Obx(() => AppSizeItem(title: "Dung lượng ứng dụng đã sử dụng", content: formatBytes(controller.appSize.value, 2), isDelete: true,onDelete: () {
            controller.onDeleteFiles();
          }, )), 
          const SizedBox(height: 5),
          Obx(() => AppSizeDetailItem(title: "Chi tiết dung lượng ứng dụng",  pieSeriesList: controller.pieChartSizeApp.value, contentFirst: controller.dbStorage.value, contentSecond: controller.filesStorage.value, subFirstContent: "Dữ liệu DB", subSecondContent: "Dữ liệu khác (ảnh, ghi âm ...)")),
          const SizedBox(height: 5,),
          Obx(() => AppSizeChart(title: "Biểu đồ ${controller.txtFromDateController.text} - ${controller.txtToDateController.text}", barSeriesList: controller.barChartSizeApp.value, onCallBack: () {
            controller.onOpenFilter();
          },))
        ],
      ),
    );
  }
}

class AppSizeItem extends StatelessWidget {
  const AppSizeItem({
    super.key,
    required this.title,
    required this.content,
    this.isDelete = false,
    this.onDelete
  });
  final String title;
  final String content;
  final bool isDelete;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: const EdgeInsets.only(bottom: 5.0), child: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16))),
        Row(
          children: [
            const Icon(Icons.circle, size: 8, color: Colors.black),
            const SizedBox(width: 5.0),
            Text(content, style: const TextStyle(color: Colors.black, fontSize: 16)),
          ],
        ),
        Visibility(
          visible: isDelete,
          child: GestureDetector(
            onTap:() {
              if (onDelete != null) {
                onDelete!();
              }
            },
            child: Container(
              width: Get.width / 2.7,
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), 
                color: AppColor.cardinalRed.withOpacity(0.1)
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10.0),
              child: Text("Xóa bộ nhớ", style: TextStyle(fontSize: 13, color: AppColor.cardinalRed.withOpacity(.7), fontWeight: FontWeight.w600),),
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}

class AppSizeDetailItem extends StatelessWidget {
  const AppSizeDetailItem({
    super.key,
    required this.title,
    required this.contentFirst,
    required this.contentSecond,
    required this.subFirstContent,
    required this.subSecondContent,
    required this.pieSeriesList,
  });
  final String title;
  final String contentFirst;
  final String contentSecond;
  final String subFirstContent;
  final String subSecondContent;
  final List<charts.Series<dynamic, String>> pieSeriesList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: const EdgeInsets.only(bottom: 5.0), child: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16))),
        Row(
          children: [
            const Icon(Icons.circle, size: 8, color: Colors.black),
            const SizedBox(width: 5.0),
            Text("$subFirstContent: " , style: const TextStyle(color: Colors.black, fontSize: 16)),
            const SizedBox(width: 5.0),
            Text(contentFirst, style: const TextStyle(color: Colors.black, fontSize: 16)),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.circle, size: 8, color: Colors.black),
            const SizedBox(width: 5.0),
            Text("$subSecondContent: " , style: const TextStyle(color: Colors.black, fontSize: 16)),
            const SizedBox(width: 5.0),
            Expanded(child: Text(contentSecond, style: const TextStyle(color: Colors.black, fontSize: 16))),
          ],
        ),
        const SizedBox(height: 5.0,),
        SizedBox(
          height: 350,
          width: Get.width,
          child: charts.PieChart<String>(pieSeriesList,
          animate: false,
          behaviors: pieSeriesList.isNotEmpty ? [
              charts.DatumLegend(
                legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 4,
                showMeasures: true,
                measureFormatter: (num? value) {
                  return value == null ? '-' : formatBytes(value.toInt(), 2);
                },
              ),
            ] : []
          ),
        ),
        const Divider()
      ],
    );
  }
}

class AppSizeChart extends StatelessWidget {
  const AppSizeChart({super.key, required this.title, required this.barSeriesList, this.onCallBack});

  final String title;
  final List<charts.Series<dynamic, String>> barSeriesList;
  final Function()? onCallBack;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(margin: const EdgeInsets.only(bottom: 5.0), child: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16))),
            Expanded(child: GestureDetector(onTap: (){
              if (onCallBack!= null) {
                onCallBack!();
              }
            }, child: Container(alignment: Alignment.centerRight, child: const Icon(Icons.filter_alt, size: 26, color: AppColor.greenMonth)))),
          ],
        ),
        SizedBox(
          height: 300,
          width: 300,
          child:  charts.BarChart(
              barSeriesList,
              animate: true,
              vertical: false,             
              barRendererDecorator: charts.BarLabelDecorator(
               insideLabelStyleSpec: charts.TextStyleSpec(fontSize: 13, color: charts.ColorUtil.fromDartColor(Colors.white), fontWeight: "bold")),
              domainAxis:  const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
              primaryMeasureAxis:
                const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec(),  ),
              behaviors: barSeriesList.isNotEmpty ? [
                charts.SlidingViewport(charts.SelectionModelType.action,),
                charts.PanBehavior(),
              ] : [],
            ) 
          
        )
      ],
    );
  }  
}



