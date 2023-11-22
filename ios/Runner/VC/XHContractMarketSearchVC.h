//
//  XHContractMarketSearchVC.h
//  UUKR
//
//  Created by ZXH on 2023/8/7.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHContractMarketSearchVC : BaseViewController

@property (copy, nonatomic)void (^clickChoose)(NSString *chooseStr);

@end

NS_ASSUME_NONNULL_END
