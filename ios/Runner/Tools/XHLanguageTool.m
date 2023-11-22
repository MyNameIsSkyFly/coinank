//
//  XHLanguageTool.m
//  JSX_NORGAS
//
//  Created by ZXH on 2022/2/22.
//

#import "XHLanguageTool.h"

static NSString *const UWUserLanguageKey = @"UserLanguageKey";

static XHLanguageTool *sharedModel;

@interface XHLanguageTool()

@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *language;

@end

@implementation XHLanguageTool

+ (void)setUserLanguage:(NSString *)userLanguage
{
    //跟随手机系统
    if (!userLanguage.length) {
        [self resetSystemLanguage];
        return;
    }
    //用户自定义
    [kUserDefaults setValue:userLanguage forKey:UWUserLanguageKey];
    [kUserDefaults setValue:@[userLanguage] forKey:@"AppleLanguages"];
    [kUserDefaults synchronize];
}

+ (NSString *)userLanguage
{
    return [kUserDefaults valueForKey:UWUserLanguageKey];
}

/**
 重置系统语言
 */
+ (void)resetSystemLanguage
{
    [kUserDefaults removeObjectForKey:UWUserLanguageKey];
    [kUserDefaults setValue:nil forKey:@"AppleLanguages"];
    [kUserDefaults synchronize];
}

@end
