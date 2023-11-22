//
//  XHTools.h
//  UUKR
//
//  Created by ZXH on 2023/4/7.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHTools : NSObject

/// 根据价格获取需要显示的颜色
/// - Parameter number: 价格
+ (UIColor *)getColorWithNumber:(CGFloat)number;


/// 资金费率颜色
/// - Parameter number: 费率
+ (UIColor *)getColorWithFundRateNumber:(CGFloat)number;

@end

NS_ASSUME_NONNULL_END
