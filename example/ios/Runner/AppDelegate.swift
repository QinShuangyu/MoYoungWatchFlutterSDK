import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//      NKBluetoothManager.shared.setBluetoothConfig()
      
      GeneratedPluginRegistrant.register(with: self)
      //注册自己写的FlutterPlugin
//      if let registrar = self.registrar(forPlugin: "FlutterBlueToothPlugin") {
////          FlutterBlueToothPlugin.register(with: registrar)
//      }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
