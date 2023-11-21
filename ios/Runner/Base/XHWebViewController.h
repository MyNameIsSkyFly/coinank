//
//  XHWebViewController.h
//  UUKR
//
//  Created by ZXH on 2022/11/10.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "BaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHWebViewController : BaseViewController<JXCategoryListContentViewDelegate>

@property (strong, nonatomic)NSString *urlStr;

@property (assign, nonatomic)BOOL isHideRefresh;
@property (assign, nonatomic)BOOL isKLine;

@end

NS_ASSUME_NONNULL_END
