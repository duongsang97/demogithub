import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageViewNavigatorModel {
  String name;
  String router;
  Transition? transition;
  Widget Function() page;
  Bindings? binding;
  PageViewNavigatorModel({required this.router,this.transition,required this.page,this.binding,required this.name});
}