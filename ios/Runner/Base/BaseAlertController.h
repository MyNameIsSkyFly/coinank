//
//  BaseAlertController.h
//  UUKR
//
//  Created by ZXH on 2022/7/30.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseAlertController : UIAlertController

@property (copy, nonatomic)void (^clickActionBlock)(NSInteger index, NSString *str);


- (void)setActionWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
