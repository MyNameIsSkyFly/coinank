//
//  XHWebViewController.m
//  UUKR
//
//  Created by ZXH on 2022/11/10.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "XHWebViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "GGWkCookie.h"
#import "JHUD.h"

@interface XHWebViewController ()<WKNavigationDelegate,WKUIDelegate,GGWkWebViewDelegate>
@property (strong, nonatomic)WKWebView *webview;
@property (strong, nonatomic)NSMutableArray *cookies;


@property WKWebViewJavascriptBridge* bridge;
@property (strong, nonatomic)UIView *loadAddView;
@property (nonatomic) JHUD *hudView;

@end

@implementation XHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_interactivePopDisabled = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.view addSubview:self.webview];
    [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.webview.UIDelegate = self;
    self.webview.navigationDelegate = self;
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.webview setOpaque:NO];//这里暗黑模式去白边作用很大
    self.webview.backgroundColor = [UIColor colorNamed:@"white_color"];
    
    [self.webview reloadCookie];
    // 设置cookie代理
    self.webview.cookieDelegate = self;
    // 开启自定义cookie（在loadRequest前开启）
    [self.webview startCustomCookie];
    
    
    [self addCookieName:@"theme" value:kTheme path:@"/" domain:kUniappDomain toUserContent:self.webview.configuration.userContentController];
    [self addCookieName:@"i18n_redirected" value:[NSString getLanguageSir] path:@"/" domain:kUniappDomain toUserContent:self.webview.configuration.userContentController];
    if (kToken){
        [self addCookieName:@"COINSOHO_KEY" value:kToken path:@"/" domain:kUniappDomain toUserContent:self.webview.configuration.userContentController];
    }
    
    if (kIsRedGreen){
        [self addCookieName:@"green-up" value:@"false" path:@"/" domain:kUniappDomain toUserContent:self.webview.configuration.userContentController];
    }else{
        [self addCookieName:@"green-up" value:@"true" path:@"/" domain:kUniappDomain toUserContent:self.webview.configuration.userContentController];
    }
    
    [self.webview addSubview:self.loadAddView];

    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    WeakSelf(ws);
    [self.webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSString *newUserAgent = [result stringByAppendingFormat:@"%@", @"CoinsohoWeb"];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUserAgent}];
        ws.webview.customUserAgent = newUserAgent;
    }];
    
    
    if (!self.isHideRefresh){
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
            [ws.webview reload];
        }];
        header.backgroundColor = [UIColor colorNamed:@"white_color"];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        //header.stateLabel.hidden = YES;
        [header beginRefreshing];
        self.webview.scrollView.mj_header = header;
    }
    
    if (_bridge) { return; }
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webview];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(kLoginData);
    }];
    
    [_bridge registerHandler:@"openUrl" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //NSLog(@"dataFrom JS : %@",data);
        NSString *url = [NSString stringWithFormat:@"%@%@",kH5Prefix,data];
        XHWebViewController *controller = [[XHWebViewController alloc] init];
        controller.urlStr = url;
        controller.hidesBottomBarWhenPushed = YES;
        [ws.navigationController pushViewController:controller animated:YES];
        
        //responseCallback([NSString stringWithFormat:@"已经收到了你的URL信息---%@",data]);
    }];
    
//    [_bridge registerHandler:@"openLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
//        if (!kIslogin) {
//            XHLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil]instantiateViewControllerWithIdentifier:@"XHLoginViewController"];
//            loginVC.hidesBottomBarWhenPushed = YES;
//            [ws.navigationController pushViewController:loginVC animated:YES];
//        }
//    }];
    
//    [_bridge registerHandler:@"openKLineChart" handler:^(id data, WVJBResponseCallback responseCallback) {
//        //NSLog(@"openKLineChart --- %@",data);
//        XHContractModel *model = [XHContractModel modelWithJSON:data];
////        XHKLineViewController *kLineVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"XHKLineViewController"];
////        kLineVC.chooseModel = model;
////        kLineVC.hidesBottomBarWhenPushed = YES;
////        [ws.navigationController pushViewController:kLineVC animated:YES];
//        
//        [kNotificationCenter postNotificationName:@"kPushKlineWebVCNotice" object:nil userInfo:@{@"exchangeName":model.exchangeName,@"symbol":model.symbol}];
//        
//    }];

//    [kNotificationCenter addObserver:self selector:@selector(reloadKline:) name:@"kPushKlineWebVCNotice" object:nil];
    
//    [kNotificationCenter addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    
//    [kNotificationCenter addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (self.isKLine){
        [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-30);
        }];
    }
}

- (void)reloadKline:(NSNotification *)notice{
    [self.webview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-30);
    }];
    NSString *exchangeName = notice.userInfo[@"exchangeName"];
    NSString *symbol = notice.userInfo[@"symbol"];
    
    NSDictionary *dict = @{@"exchangeName":exchangeName,
                           @"symbol":symbol,
                           @"productType":@"",
    };
    [self.bridge callHandler:@"iosOpenKLine" data:[NSString stringWithDict:dict] responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
}

///// app进入后台
//- (void)enterBackground{
//    XHConfigModel.sharedXHConfigModel.klineLeaveTime = [NSDate date].timeIntervalSince1970;
//}
//
///// app返回前台
//- (void)enterForeground{
//    double timeStamp = [NSDate date].timeIntervalSince1970;
//    double closeTimeStamp = XHConfigModel.sharedXHConfigModel.klineLeaveTime;
//
//    if (self.isKLine && timeStamp - closeTimeStamp > 15){
//        [self.webview reload];
//    }
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.isKLine){
        usleep(2000);
        self.tabBarController.selectedIndex = 0;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (UIView *)listView{
    return self.view;
}


-(UIView *)loadAddView{
    if (!_loadAddView) {
        _loadAddView = [[UIView alloc]initWithFrame:self.view.bounds];
        _loadAddView.backgroundColor = [UIColor colorNamed:@"white_color"];
        [self.hudView showAtView:self.webview hudType:JHUDLoadingTypeCircle];
    }
    return _loadAddView;
}

- (JHUD *)hudView{
    if (!_hudView) {
        _hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
        _hudView.messageLabel.text = MyLocalized(@"s_loading");
        _hudView.messageLabel.textColor = [UIColor systemBlueColor];
        _hudView.indicatorBackGroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.0];
        _hudView.indicatorForegroundColor = [UIColor systemBlueColor];
        
    }
    return _hudView;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.loadAddView removeFromSuperview];
    [self.hudView hide];
    
    [self.webview.scrollView.mj_header endRefreshing];
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

- (WKWebView *)webview{
    if (!_webview){
//        // 创建一个WKWebViewConfiguration实例
//        WKWebViewConfiguration *configuration = WKWebViewConfiguration.new;
//
//        // 创建一个WKProcessPool实例，用于共享缓存和cookie等信息
//        WKProcessPool *processPool = [[WKProcessPool alloc] init];
//        configuration.processPool = processPool;
//
//        // 配置缓存行为
//        WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
//        WKWebsiteDataStore *nonPersistentDataStore = [WKWebsiteDataStore nonPersistentDataStore];
//        configuration.websiteDataStore = dataStore;
//        configuration.websiteDataStore = nonPersistentDataStore;
        _webview = [[WKWebView alloc]initWithFrame:CGRectZero];
        _webview.backgroundColor = UIColor.clearColor;
    }
    return _webview;
}

@end
