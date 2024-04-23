import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlRenderComponent extends StatefulWidget {
  const HtmlRenderComponent({ Key? key,this.contentHTML,this.fontColor}) : super(key: key);
  final String? contentHTML;
  final Color? fontColor;
  @override
  State<HtmlRenderComponent> createState() => _HtmlRenderComponentState();
}

class _HtmlRenderComponentState extends State<HtmlRenderComponent> {
  String handleContentHTML(){
    return "<!DOCTYPE html><html><body>${(widget.contentHTML??"")}</body></html>";
  }

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      
      handleContentHTML(),
      onTapUrl: (String url){
        try{
          launchUrl(Uri.parse(url));
        }
        catch(ex){
          AppLogsUtils.instance.writeLogs(ex,func: "build htmlRender.Component");
        }
        return true;
      },
      onErrorBuilder: (context, element, error){
        AlertControl.push("Có lỗi xảy ra trong quá trình xử lý", type: AlertType.ERROR);
      },
      onTapImage: (p0){
      },
    );
  }
}