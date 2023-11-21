//
//  NSString+XH.m
//  UUKR
//
//  Created by ZXH on 2022/6/20.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "NSString+XH.h"

@implementation NSString (XH)

// 清空字符串中的空白字符
- (NSString *)trimString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 是否空字符串
- (BOOL)isEmptyString
{
    return (self.length == 0);
}


// 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)containsString:(NSString *)aString
{
    NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
    return range.location != NSNotFound;
}

- (NSString *)trimFrontZeroCharacter{
    NSString *string = self;
    int i = 0;
    for (i = 0; i < self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (character != 48) {
            break;
        }
    }
    string = [string substringFromIndex:i];
    return string;
}




// 删除符号
- (NSString*)trimSymbol
{
    NSString *string = self;
    if ([self containsString:@"-"]) {
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([self containsString:@" "]) {
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([string containsString:@"("]) {
        string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([self containsString:@")"]) {
        string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return string;
}


// 判断手机号码是否正确
- (BOOL)isPhoneNum
{
    // 1.去掉空格，取出第一个数字
    NSString *phone = [self trimSymbol];
    NSString *prefix = nil;
    if (phone.length > 0) {
        prefix = [phone substringToIndex:1];
    } else {
        prefix = @"";
    }
    
    if (phone.length != 11 || (![prefix  isEqual: @"1"] || ![phone isPureNum])) {
        // 2.1 号码没有11位、或者首个数据不是1、或者不是纯数字组成
        return 0;
    } else {
        // 2.2 号码正确
        return 1;
    }
}

// 判断是否是邮箱
- (BOOL)isEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}


// 判断是否是纯数字
- (BOOL)isPureNum
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//是否包含字母
- (BOOL)isContainsNum{
    NSString *regex1 = @".*[0-9]+.*";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    
    return  [pred1 evaluateWithObject:self];
}


//浮点数处理并去掉多余的0
+ (NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%f",floatValue];
    long len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        //s.substring(0, len - i - 1);
        return [str substringToIndex:[str length]-1];
    }
    else
    {
        return str;
    }
}

// 判断密码是否正确
- (BOOL)isLengthBetween:(int)num1 and:(int)num2
{
    int max = (num1 > num2) ? num1 : num2;
    int min = (num1 > num2) ? num2 : num1;
    if (self.length <= max || self.length >= min) {
        return 1;
    } else {
        return 0;
    }
}



//8位及以上数字+字母的组合
- (BOOL)isLegalPsword{
    return ![self isPureNum] && self.length >= 8 && [self isContainsNum] && self.length <= 20;
}



/// 对浮点数四舍五入返回字符串
/// @param num 浮点数
/// @param position 保留位数
-(NSString *)notRounding:(float)num afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:num];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

/// 获取当前app语言缩写
+ (NSString *)getLanguageSir{
    if ([[NSBundle currentLanguage] isEqualToString:@"en"]) {
        return @"en";
    }else if ([[NSBundle currentLanguage] containsString:@"zh-Hant"]){
        return @"zh-tw";
    }else if ([[NSBundle currentLanguage] containsString:@"zh-Hans"]){
        return @"zh";
    }else if ([[NSBundle currentLanguage] containsString:@"ja"]){
        return @"ja";
    }else if ([[NSBundle currentLanguage] containsString:@"ko"]){
        return @"ko";
    }
    return @"zh";
}

/// 字典转json
/// @param dict 字典
+ (NSString *)stringWithDict:(NSDictionary *)dict{
    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}


-(CGRect)getRectWithFontSize:(CGFloat)fontSize {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
    return rect;
}



/// 大数字转小格式
/// @param number 数字
+ (NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"";

    long long num = [number longLongValue];

    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );

    num = llabs(num);

    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];

    int exp = (int) (log10l(num) / 3.f); //log10l(1000));

    NSArray* units = @[@"K",@"M",@"B",@"T",@"P",@"E"];
    if ([[NSBundle currentLanguage] containsString:@"zh"]){
        NSString *unitStr = [units objectAtIndex:(exp-1)];
        CGFloat numFloat = (num / pow(1000, exp));
        if ([unitStr isEqualToString:@"K"]){
            if (numFloat*1000 > 10000){
                return [NSString stringWithFormat:@"%@%.2f万",sign,numFloat*1000/10000];
            }
            return [NSString stringWithFormat:@"%@%.2f",sign,numFloat*1000];
        }else if ([unitStr isEqualToString:@"M"]){
            if (numFloat*100 > 10000){
                return [NSString stringWithFormat:@"%@%.2f亿",sign,numFloat*100/10000];
            }
            return [NSString stringWithFormat:@"%@%.2f万",sign,numFloat*100];
        }else if ([unitStr isEqualToString:@"B"]){
            return [NSString stringWithFormat:@"%@%.2f亿",sign,numFloat*10];
        }else if ([unitStr isEqualToString:@"T"]){
            return [NSString stringWithFormat:@"%@%.2f亿",sign,numFloat*10000];
        }
        return [NSString stringWithFormat:@"%@%.2f%@",sign,numFloat, unitStr];
    }
    return [NSString stringWithFormat:@"%@%.2f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}



/// 去掉浮点数后面多余的0
/// @param testNumber 输入的数字
+ (NSString*)removeFloatAllZeroByString:(NSString *)testNumber{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}


/// 科学计数文字转位正常文字
/// @param num 文字
+ (NSString *)formartScientificNotationWith:(double)num{
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle = NSNumberFormatterNoStyle;
    
    NSString * string = [formatter stringFromNumber:[NSNumber numberWithDouble:num]];
    
    return string;
    
}

+ (NSString*)getStringFrom:(double)doubleVal {
    NSString* stringValue = @"0.00";
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.usesSignificantDigits = true;
    formatter.maximumSignificantDigits = 100000000000;
    formatter.groupingSeparator = @"";
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    stringValue = [formatter stringFromNumber:[NSNumber numberWithDouble:doubleVal]];
    
    return stringValue;
}

- (CGFloat)getStringWidthWithFont:(UIFont *)font{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(2000, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}


- (CGFloat)getStringHeightWithFont:(UIFont *)font{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(2000, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}

@end
