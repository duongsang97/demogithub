import UIKit
import Flutter
import FirebaseCore
import workmanager
import app_links
import flutter_local_notifications
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let helperChannel = FlutterMethodChannel(name: "erp.native/helper",binaryMessenger:controller.binaryMessenger)
      helperChannel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
          if(call.method == "record"){
              result("record")
          }
          else if(call.method == "recordReceiver"){
              result("get path")
          }
          else if(call.method == "getFreeStorage"){
              if let bytes = deviceRemainingFreeSpaceInBytes() {
                  result("\(bytes)")
              } else {
                  result("-1")
              }
          }
          else if(call.method == "getTimeSettingStatus"){
              let autoTime = checkAutoTimeSetting()
              result("\(autoTime)")
          }
          else if(call.method == "getCameraLensType"){
              if let arguments = call.arguments as? [String: Any] {
                  if let cameraID = arguments["cameraId"] as? String{
                      if let lensInfo = getLensInfo(for: cameraID) {
                          result("\(lensInfo)")
                      } else {
                          result("null")
                      }
                  }
                  else{
                      result("null")
                  }
              }
              else{
                  
              }
              
          }
          else{
              result("Command not exists!")
          }
          
      }

      // đóng
      // Retrieve the link from the parameters
    if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
    // We have a link, propagate it to your Flutter app
        AppLinks.shared.handleLink(url: url)
    }
    // Notification config    
    if #available(iOS 10.0, *) {
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }
    // firebase config
    FirebaseApp.configure()
    WorkmanagerPlugin.registerTask(withIdentifier: "task-sync-data-erp")
    GMSServices.provideAPIKey("AIzaSyDU6L0yPWwj7ay6PDcQ_t9Ybu5-YtbJC7k")
    GeneratedPluginRegistrant.register(with: self)
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
