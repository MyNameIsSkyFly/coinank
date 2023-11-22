//
//  XHToast.m
//  JSXlink
//
//  Created by ZXH on 2022/5/10.
//  Copyright © 2022 ZXH. All rights reserved.
//

#import "XHToast.h"

@implementation XHToast

single_implementation(XHToast)

- (void)showToastWithText:(NSString *)text{
//    [WHToast setCornerRadius:18];
//    [WHToast showMessage:text originY:kScreen_Height/2+100 duration:2 finishHandler:^{
//        
//    }];
    [JDStatusBarNotificationPresenter.sharedPresenter presentWithText:text dismissAfterDelay:2 includedStyle:JDStatusBarNotificationIncludedStyleDark];
}

@end
