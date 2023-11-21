#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "messages.h"
#import "BaseNavigationController.h"
#import "XHLanguageTool.h"

@interface AppDelegate ()<FLTMessageHostApi,UINavigationControllerDelegate>
@property (strong, nonatomic)UINavigationController *navigationController;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (!kTheme) {
        [kUserDefaults setObject:@"light" forKey:@"theme"];
        [kUserDefaults synchronize];
    }
    [GeneratedPluginRegistrant registerWithRegistry:self];
    FlutterViewController *controller = self.window.rootViewController;
    self.navigationController = [[BaseNavigationController alloc] initWithRootViewController:controller];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = self.navigationController;
    self.navigationController.delegate = self;
    [self.window makeKeyWindow];
    SetUpFLTMessageHostApi(controller.binaryMessenger, self);
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [navigationController.navigationBar setHidden:[viewController isKindOfClass:[FlutterViewController class]]];
}

- (void)changeDarkModeIsDark:(BOOL)isDark error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [kUserDefaults setObject:isDark ? @"night":@"light" forKey:@"theme"];
    [kUserDefaults synchronize];
    
}

- (void)changeLanguageLanguageCode:(nonnull NSString *)languageCode error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [XHLanguageTool setUserLanguage:[languageCode stringByReplacingOccurrencesOfString:@"_" withString:@"-"]];
}

- (void)changeUpColorIsGreenUp:(BOOL)isGreenUp error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [kUserDefaults setBool:!isGreenUp forKey:@"isRedGreen"];
    [kUserDefaults synchronize];
}

- (void)toBtcMarketRatioWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self pushWebVCWithTitle:MyLocalized(@"s_marketcap_ratio") urlStr:WEB_BTC_MARKET_CAP_URL];

}

- (void)toBtcProfitRateWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self pushWebVCWithTitle:MyLocalized(@"s_btc_profit") urlStr:WEB_BTC_INVESTMENT_RATE_URL];

}

- (void)toFundRateWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"toFundRateWithError");
    
}

- (void)toFuturesVolumeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self pushWebVCWithTitle:MyLocalized(@"s_futures_vol_24h") urlStr:WEB_VOL_24H_URL];
}

- (void)toGrayScaleDataWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self pushWebVCWithTitle:MyLocalized(@"s_grayscale_data") urlStr:WEB_FEARGREED_URL];

}

- (void)toGreedIndexWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self pushWebVCWithTitle:MyLocalized(@"s_greed_index") urlStr:WEB_BTC_GRAYSCALE_URL];

}

- (void)toLiqMapWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"toLiqMapWithError");
    
}

- (void)toLongShortAccountRatioWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self pushWebVCWithTitle:MyLocalized(@"s_longshort_ratio") urlStr:WEB_LONGSHORTNUMBER_URL];
}

- (void)toOiChangeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"toOiChangeWithError");
    
}

- (void)toPriceChangeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"toPriceChangeWithError");
    
}

- (void)toTakerBuyLongShortRatioWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"toTakerBuyLongShortRatioWithError");
}

- (void)toTotalOiWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [self pushWebVCWithTitle:MyLocalized(@"s_liqmap") urlStr:WEB_LIQ_MAP_CHAR_URL];
}

-(void) pushWebVCWithTitle:(NSString* )title urlStr:(NSString* )urlStr {
    XHWebViewController *controller = [[XHWebViewController alloc] init];
    controller.urlStr = [NSString stringWithFormat:@"%@/%@%@",kH5Prefix,[NSString getLanguageSir],urlStr];
    controller.title = title;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

