import 'package:firebase_performance/firebase_performance.dart';

class PerformanceUtils{
  static final PerformanceUtils _performanceUtils = PerformanceUtils._();
  static PerformanceUtils get instance => _performanceUtils;
  static FirebasePerformance? firePer;
  PerformanceUtils._(){
    
  }
  
  Future<FirebasePerformance> get firebasePer async{
    if(firePer == null || (firePer != null && !await firePer!.isPerformanceCollectionEnabled())){
      firePer = FirebasePerformance.instance;
    }
    return firePer!;
  }
}