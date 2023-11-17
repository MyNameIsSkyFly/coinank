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
    func toLiqMapWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toLongShortAccountRatioWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toTakerBuyLongShortRatioWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toOiChangeWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toPriceChangeWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toGreedIndexWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toBtcMarketRatioWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toFuturesVolumeWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toBtcProfitRateWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toGrayScaleDataWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
    func toFundRateWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        
    }
    
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

