//
//  NSBundle+XH.m
//  JSX_NORGAS
//
//  Created by ZXH on 2022/2/22.
//

#import "NSBundle+XH.h"
#import "XHLanguageTool.h"
#import <objc/runtime.h>
#import <WebKit/WebKit.h>

@interface XHBundle : NSBundle

@end

@implementation NSBundle (XH)

+ (BOOL)isChineseLanguage
{
    NSString *currentLanguage = [self currentLanguage];
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)currentLanguage
{
    return [XHLanguageTool userLanguage] ? : [NSLocale preferredLanguages].firstObject;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //动态继承、交换，方法类似KVO，通过修改[NSBundle mainBundle]对象的isa指针，使其指向它的子类DABundle，这样便可以调用子类的方法；其实这里也可以使用method_swizzling来交换mainBundle的实现，来动态判断，可以同样实现。
        object_setClass([NSBundle mainBundle], [XHBundle class]);
    });
}

@end

@implementation XHBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    if ([XHBundle uw_mainBundle]) {
        return [[XHBundle uw_mainBundle] localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

+ (NSBundle *)uw_mainBundle
{
    if ([NSBundle currentLanguage].length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
        if (path.length) {
            return [NSBundle bundleWithPath:path];
        }
    }
    return nil;
}


//修改userAgent
+ (void)addToWebViewUserAgent:(NSString *)addAgent
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WKWebView *webView = [WKWebView new];
        [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable oldAgent, NSError * _Nullable error) {
            if (![oldAgent isKindOfClass:[NSString class]]) {
                // 为了避免没有获取到oldAgent，所以设置一个默认的userAgent
                // Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148
                oldAgent = [NSString stringWithFormat:@" ", [[UIDevice currentDevice] model], [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"]];
            }
            
            //自定义user-agent
            if (![oldAgent hasSuffix:addAgent]) {
                NSString *newAgent = [oldAgent stringByAppendingFormat:@" DWD_HSQ/%@",addAgent];
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newAgent}];
                // 一定要设置customUserAgent，否则执行navigator.userAgent拿不到oldAgent
                webView.customUserAgent = newAgent;
            }
        }];
    });
}

@end
