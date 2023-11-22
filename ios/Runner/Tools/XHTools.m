//
//  XHTools.m
//  UUKR
//
//  Created by ZXH on 2023/4/7.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import "XHTools.h"

@implementation XHTools


/// 根据价格获取需要显示的颜色
/// - Parameter number: 价格
+ (UIColor *)getColorWithNumber:(CGFloat)number{
    UIColor *color = [UIColor colorNamed:@"text_default"];
    if (number>0){
        color = kIsRedGreen ? [UIColor colorNamed:@"red_color"] : [UIColor colorNamed:@"green_color"];
    }else{
        color = kIsRedGreen ? [UIColor colorNamed:@"green_color"] : [UIColor colorNamed:@"red_color"];
    }
    return color;
}

/// 资金费率颜色
/// - Parameter number: 费率
+ (UIColor *)getColorWithFundRateNumber:(CGFloat)number{
    UIColor *color = [UIColor colorNamed:@"text_default"];
    if (number *100 > 0.01){
        color = [UIColor colorNamed:@"red_color"];
    }
    if (number *100 < 0.01){
        color = [UIColor colorNamed:@"green_color"];
    }
    return color;
}

@end
