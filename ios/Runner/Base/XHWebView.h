//
//  XHWebView.h
//  UUKR
//
//  Created by ZXH on 2023/8/9.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHWebView : WKWebView

@property WKWebViewJavascriptBridge* bridge;

@end

NS_ASSUME_NONNULL_END
