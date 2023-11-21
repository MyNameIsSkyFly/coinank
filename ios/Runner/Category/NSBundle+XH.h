//
//  NSBundle+XH.h
//  JSX_NORGAS
//
//  Created by ZXH on 2022/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (XH)


/// App语言是否为简体中文
+ (BOOL)isChineseLanguage;


/// 获取当前语言
+ (NSString *)currentLanguage;

@end

NS_ASSUME_NONNULL_END
