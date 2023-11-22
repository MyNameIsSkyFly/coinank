//
//  XHWebView.m
//  UUKR
//
//  Created by ZXH on 2023/8/9.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import "XHWebView.h"
#import "GGWkCookie.h"
#import "JHUD.h"

@interface XHWebView ()<GGWkWebViewDelegate,WKNavigationDelegate>

@property (strong, nonatomic)UIView *loadAddView;
@property (nonatomic) JHUD *hudView;
@property (strong, nonatomic)NSMutableArray *cookies;

@end

@implementation XHWebView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self settingWebView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self settingWebView];
}

/// webview
- (void)settingWebView{
    
    [self setOpaque:NO];//这里暗黑模式去白边作用很大
    self.backgroundColor = [UIColor colorNamed:@"white_color"];
    
    self.backgroundColor = [UIColor colorNamed:@"white_color"];
    self.navigationDelegate = self;
    //[self addSubview:self.loadAddView];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self reloadCookie];
    // 设置cookie代理
    self.cookieDelegate = self;
    // 开启自定义cookie（在loadRequest前开启）
    [self startCustomCookie];
    
    [self addCookieName:@"theme" value:kTheme path:@"/" domain:kUniappDomain toUserContent:self.configuration.userContentController];
    [self addCookieName:@"i18n_redirected" value:[NSString getLanguageSir] path:@"/" domain:kUniappDomain toUserContent:self.configuration.userContentController];
    if (kToken){
        [self addCookieName:@"COINSOHO_KEY" value:kToken path:@"/" domain:kUniappDomain toUserContent:self.configuration.userContentController];
    }
    
    if (kIsRedGreen){
        [self addCookieName:@"green-up" value:@"false" path:@"/" domain:kUniappDomain toUserContent:self.configuration.userContentController];
    }else{
        [self addCookieName:@"green-up" value:@"true" path:@"/" domain:kUniappDomain toUserContent:self.configuration.userContentController];
    }
    
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self];
    [_bridge setWebViewDelegate:self];
    
    self.scrollView.bounces = NO;
    
    NSMutableDictionary *cookieDict = [NSMutableDictionary dictionary];
    [cookieDict setObject:kTheme forKey:@"theme"];
    [cookieDict setObject:[NSString getLanguageSir] forKey:@"i18n_redirected"];
    //NSLog(@"%@",cookieDict);
    NSString *cookieStr = [NSString stringWithDict:cookieDict];
    
    [self.bridge callHandler:@"setCookie" data:cookieStr responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    WeakSelf(ws);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ws.loadAddView removeFromSuperview];
        [ws.hudView hide];
    });
}

-(void)addCookieName:(NSString *)name value:(NSString *)value path:(NSString *)path domain:(NSString *)domain toUserContent:(WKUserContentController *)userContentController{
    name = name?:@"";
    value = value?:@"";
    path = path?:@"/";
    domain = domain?:@"";
    NSString *cookieValue = [NSString stringWithFormat:@"'%@=%@;path=%@;domain=%@';", name,value,path,domain];
    if (!self.cookies) {
        self.cookies = [NSMutableArray array];
    }
    [self.cookies addObject:[cookieValue stringByReplacingOccurrencesOfString:@"'" withString:@""]];
    cookieValue = [NSString stringWithFormat:@"document.cookie = %@",cookieValue];
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: cookieValue injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    
    for (NSHTTPCookie * cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        if ([cookie.name isEqualToString:name] && [cookie.value isEqualToString:value] && [cookie.domain isEqualToString:domain]) {
            return;
        }
    }
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:name forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:domain forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:path forKey:NSHTTPCookiePath];
    NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    NSLog(@"%@",[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
    
}

#pragma mark -- GGWkWebViewDelegate
/// 代理方法中设置 app自定义的cookie
- (NSDictionary *)webviewSetAppCookieKeyAndValue {

    NSMutableDictionary *cookieDict = [NSMutableDictionary dictionary];
    [cookieDict setObject:kTheme forKey:@"theme"];
    [cookieDict setObject:[NSString getLanguageSir] forKey:@"i18n_redirected"];
    if (!kIsRedGreen){
        [cookieDict setObject:@"false" forKey:@"green-up"];
    }else{
        [cookieDict setObject:@"true" forKey:@"green-up"];
    }
    //NSLog(@"%@",cookieDict);
    return cookieDict;
}

-(UIView *)loadAddView{
    if (!_loadAddView) {
        _loadAddView = [[UIView alloc]initWithFrame:self.bounds];
        _loadAddView.backgroundColor = [UIColor colorNamed:@"white_color"];
        [self.hudView showAtView:self hudType:JHUDLoadingTypeCircle];
    }
    return _loadAddView;
}

- (JHUD *)hudView{
    if (!_hudView) {
        _hudView = [[JHUD alloc]initWithFrame:self.bounds];
        _hudView.messageLabel.text = MyLocalized(@"s_loading");
        _hudView.messageLabel.textColor = [UIColor systemBlueColor];
        _hudView.indicatorBackGroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.0];
        _hudView.indicatorForegroundColor = [UIColor systemBlueColor];
        
    }
    return _hudView;
}

@end
