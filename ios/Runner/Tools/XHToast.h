//
//  XHToast.h
//  JSXlink
//
//  Created by ZXH on 2022/5/10.
//  Copyright © 2022 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHToast.h"
#import "JDStatusBarNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHToast : NSObject
single_interface(XHToast)

- (void)showToastWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
