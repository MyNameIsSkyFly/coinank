#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "XHLanguageTool.h"

@interface AppDelegate ()<FLTMessageHostApi>

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
    SetUpFLTMessageHostApi(controller.binaryMessenger, self);
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
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


- (void)saveLoginInfoUserInfoWithBaseEntityJson:(nonnull NSString *)userInfoWithBaseEntityJson error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error { 
    [kUserDefaults setObject:userInfoWithBaseEntityJson forKey:@"loginData"];
}

- (void)toAndroidFloatingWindowWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
}


@end

