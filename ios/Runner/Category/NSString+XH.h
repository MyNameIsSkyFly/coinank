//
//  NSString+XH.h
//  UUKR
//
//  Created by ZXH on 2022/6/20.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XH)

// 是否包含某个字符串
- (BOOL)containsString:(NSString *)aString;

// 清空字符串中的空白字符
- (NSString *)trimString;

// 是否空字符串
- (BOOL)isEmptyString;

//浮点数处理并去掉多余的0
+(NSString *)stringDisposeWithFloat:(float)floatValue;

// 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key;

// 删除符号：()-空格
- (NSString*)trimSymbol;

// 从第一个不是零的字符开始截取字符串
- (NSString *)trimFrontZeroCharacter;

// 判断手机号码是否正确
- (BOOL)isPhoneNum;

// 判断是否是邮箱
- (BOOL)isEmail;

// 判断是否是纯数字
- (BOOL)isPureNum;

// 判断长度是否处于num1和num2之间
- (BOOL)isLengthBetween:(int)num1 and:(int)num2;
//8位及以上数字+字母的组合
- (BOOL)isLegalPsword;

/// 对浮点数四舍五入返回字符串
/// @param num 浮点数
/// @param position 保留位数
-(NSString *)notRounding:(float)num afterPoint:(int)position;


/// 获取当前app语言缩写
+ (NSString *)getLanguageSir;

/// 字典转json
/// @param dict 字典
+ (NSString *)stringWithDict:(NSDictionary *)dict;

-(CGRect)getRectWithFontSize:(CGFloat)fontSize;


/// 大数字转小格式
/// @param number 数字
+ (NSString*) suffixNumber:(NSNumber*)number;



/// 去掉浮点数后面多余的0
/// @param testNumber 输入的数字
+ (NSString*)removeFloatAllZeroByString:(NSString *)testNumber;

/// 科学计数文字转位正常文字
/// @param num 文字
+ (NSString *)formartScientificNotationWith:(double)num;



/// 科学计数的文字转为正常
/// @param doubleVal 科学计数文字
+ (NSString*)getStringFrom:(double )doubleVal;

/**
 *  获取字符串宽度
 */
- (CGFloat)getStringWidthWithFont:(UIFont *)font;
/**
 *  获取字符串高度
 */
- (CGFloat)getStringHeightWithFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
