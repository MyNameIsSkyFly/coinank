//
//  XHHudTool.h
//  UUKR
//
//  Created by ZXH on 2022/6/20.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHHudTool : NSObject
single_interface(XHHudTool)


- (void)show;

- (void)showWithLoadingtext:(NSString *)text;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
