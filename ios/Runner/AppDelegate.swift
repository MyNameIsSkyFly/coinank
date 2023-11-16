import UIKit
import Flutter


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let api = MessageHostApi()
        SetUpFLTMessageHostApi(controller.binaryMessenger, api)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

class MessageHostApi: NSObject,FLTMessageHostApi {
    func toTotalOiWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        print("toTotalOiWithError")
    }
    
    func changeDarkModeIsDark(_ isDark: Bool, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        print("changeDarkModeIsDark")
        
    }
    
    func changeLanguageLanguageCode(_ languageCode: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        print("changeLanguageLanguageCode")
        
    }
    
    func changeUpColorIsGreenUp(_ isGreenUp: Bool, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        print("changeUpColorIsGreenUp")
        
    }
    
    
}

