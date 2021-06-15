import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var url = "";
    var navigationController = UINavigationController()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let webviewChannel = FlutterMethodChannel(name: "webviewChannel",binaryMessenger: controller.binaryMessenger)
    navigationController = UINavigationController(rootViewController: controller)
    navigationController.setNavigationBarHidden(true, animated: false)
    self.window!.rootViewController = navigationController
    self.window!.makeKeyAndVisible()
    webviewChannel.setMethodCallHandler({ [self]
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if(call.method == "webview"){
            var dic = NSDictionary();
            dic = call.arguments as! NSDictionary;
            print(dic["username"] ?? "");
            let vc = WKWViewController(nibName: "WKWViewController", bundle: nil)
            vc.dic = dic as! NSMutableDictionary
            navigationController.pushViewController(vc, animated: false)
                // Set the window’s root view controller
            self.window!.rootViewController = navigationController
                // Present the window
            self.window!.makeKeyAndVisible()
        }else {
            result("")
        }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//    private func openEPub(strPath: String, conteroller: UIViewController) {
//        let vc = WKWViewController() //change this to your class name
//        UIApplication.shared.windows.first?.rootViewController
//        self.present(vc, animated: true, completion: nil)
//    }
    
    func SwitchViewController() {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let navigationController = UINavigationController(rootViewController: controller)
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
   }
}
