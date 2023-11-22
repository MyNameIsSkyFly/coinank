//
//  XHOpenInterestVC.m
//  UUKR
//
//  Created by ZXH on 2023/9/1.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import "XHOpenInterestVC.h"
#import "HMSegmentedControl.h"
#import "XHHomeModel.h"
#import <WebKit/WebKit.h>
#import "XHPositionCell.h"
#import "XHPositionTopCell.h"
#import "XHContractMarketSearchVC.h"

@interface XHOpenInterestVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedView;
@property (weak, nonatomic) IBOutlet XHWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (nonatomic, strong)NSString *type;//类型
@property (strong, nonatomic)NSString *webTime;//时间
@property (strong, nonatomic)NSString *baseCoin;//币种
@property (strong, nonatomic)NSString *exchange;//交易所
@property (strong, nonatomic)NSArray *headerTitleArray;

@property (strong, nonatomic)NSArray <XHPositionModel *>*positionArray;

@property (strong, nonatomic) NSTimer *loadTimer;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation XHOpenInterestVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    self.title = MyLocalized(@"s_open_interest");
    // Do any additional setup after loading the view.
    
    self.baseCoin = @"BTC";
    self.webTime = @"1d";
    self.type = @"USD";
    
    self.exchange = @"";
    
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [ws getAllCurrency];
        [ws postOpenInterestDataAndType:ws.baseCoin];
        [ws getOpenInterestJSDataWith:ws.baseCoin andTime:ws.webTime andType:ws.type];
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.myTableView.mj_header = header;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"XHPositionCell" bundle:nil] forCellReuseIdentifier:@"XHPositionCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"XHPositionTopCell" bundle:nil] forCellReuseIdentifier:@"XHPositionTopCell"];
    
    [self setSegmentViewData];
    
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"t18" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:request];
    
    self.titleLB.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_exchange_oi"),self.baseCoin];
    
    [kNotificationCenter addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addStartTime];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.loadTimer){
        [self.loadTimer invalidate];
        self.loadTimer = nil;
    }
}

/// app进入后台
- (void)enterBackground{
    if (self.loadTimer){
        [self.loadTimer invalidate];
        self.loadTimer = nil;
    }
}

/// app返回前台
- (void)enterForeground{
    [self addStartTime];
}

// 添加开始刷新
- (void)addStartTime{
    if (!self.loadTimer){
        WeakSelf(ws);
        self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:30 block:^(NSTimer * _Nonnull timer) {
            if (!ws.isLoading){
                [ws postOpenInterestDataAndType:ws.baseCoin];
                [ws getOpenInterestJSDataWith:ws.baseCoin andTime:ws.webTime andType:ws.type];
            }
            
        } repeats:YES];
    }
}

- (void)setSegmentViewData{
    self.segmentedView.backgroundColor = [UIColor clearColor];
    self.segmentedView.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:kIsDark ? [UIColor whiteColor] : [UIColor darkGrayColor]};
    
    self.segmentedView.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:kIsDark ? [UIColor whiteColor] : [UIColor darkGrayColor]};
    self.segmentedView.selectionIndicatorBoxOpacity = 1;
    self.segmentedView.selectedSegmentIndex = 0;
    self.segmentedView.selectionIndicatorBoxColor = [UIColor colorNamed:@"rate_color"];
    self.segmentedView.selectionIndicatorLocation = 1;
    self.segmentedView.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedView.selectionIndicatorHeight = 0;
    
    self.segmentedView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.segmentedView.selectionStyle = HMSegmentedControlSelectionStyleBox;

    WeakSelf(ws);
    self.segmentedView.indexChangeBlock = ^(NSUInteger index) {
        ws.baseCoin = ws.headerTitleArray[index];
        ws.titleLB.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_exchange_oi"),ws.baseCoin];
        if (![ws.typeBtn.titleLabel.text isEqualToString:@"USD"]){
            [ws.typeBtn setTitle:ws.baseCoin forState:UIControlStateNormal];
        }
        [ws postOpenInterestDataAndType:ws.baseCoin];
        [ws getOpenInterestJSDataWith:ws.baseCoin andTime:ws.webTime andType:ws.type];
    };
}

- (void)getAllCurrency{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,HTTP_GET_ALL_CURRENCY_URL];
    WeakSelf(ws);
    [XHHttpTool requestWithType:HttpRequestTypeGet urlString:url parameters:@{} successBlock:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.success){
            ws.headerTitleArray = [NSArray arrayWithArray:baseModel.data];
            ws.segmentedView.sectionTitles = ws.headerTitleArray;
            
            NSData *json_data = [NSJSONSerialization dataWithJSONObject:baseModel.data options:NSJSONWritingPrettyPrinted error:nil];
            NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/exchangeList.json"];
            [json_data writeToFile:filePath atomically:YES];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [ws.myTableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.positionArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        XHPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XHPositionCell" forIndexPath:indexPath];
        if (self.positionArray) {
            XHPositionModel *model = self.positionArray[indexPath.row-1];
            cell.baseCoin = self.baseCoin;
            [cell setCellDataWithModel:model];
        }
        return cell;
    }else{
        XHPositionTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XHPositionTopCell" forIndexPath:indexPath];
        return cell;
    }
}

/// 请求合约持仓数据
- (void)postOpenInterestDataAndType:(NSString *)type{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,HTTP_GET_POSITION_URL];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [paraments setObject:type forKey:@"baseCoin"];
    WeakSelf(ws);
    self.isLoading = YES;
    [XHHttpTool requestWithType:HttpRequestTypeGet urlString:url parameters:paraments successBlock:^(BaseModel * _Nonnull baseModel) {
        ws.isLoading = NO;
        if (baseModel.success) {
            ws.positionArray = [NSArray modelArrayWithClass:[XHPositionModel class] json:baseModel.data];
            [ws.myTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }
        [ws.myTableView.mj_header endRefreshing];
        if (ws.loadTimer){
            [ws.loadTimer invalidate];
            ws.loadTimer = nil;
        }
        [ws addStartTime];
    } failureBlock:^(NSError * _Nonnull error) {
        [ws.myTableView.mj_header endRefreshing];
    }];
}

//请求多空比js交互数据
- (void)getOpenInterestJSDataWith:(NSString *)exchangeName andTime:(NSString *)webTime andType:(NSString *)type{
    //self.webView.hidden = YES;
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,HTTP_GETPOSITION_JS_URL];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [paraments setObject:webTime forKey:@"interval"];
    [paraments setObject:type forKey:@"type"];
    [paraments setObject:exchangeName forKey:@"baseCoin"];
    [paraments setObject:@"200" forKey:@"size"];
    
    WeakSelf(ws);
    [XHHttpTool requestWithType:HttpRequestTypeGet urlString:url parameters:paraments successBlock:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.success) {
            
            NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
            [map setObject:ws.exchange forKey:@"exchangeName"];
            [map setObject:ws.webTime forKey:@"interval"];
            [map setObject:ws.baseCoin forKey:@"baseCoin"];
            [map setObject:[NSString getLanguageSir] forKey:@"locale"];
            [map setObject:MyLocalized(@"s_price") forKey:@"price"];
            
            //NSString *json = [NSString stringWithDict:map];
            //NSLog(@"json ==%@",json);#import "XHHttpTool.h"
            
            NSDictionary *dict = @{@"dataParams":baseModel.modelToJSONObject,
                                   @"platform":@"ios",
                                   @"dataType":@"openInterest",
                                   @"dataOptions":map
            };
            //NSLog(@"--%@",dict);
            //ws.webView.hidden = NO;
            [ws.webView.bridge callHandler:@"iosSetChartData" data:[NSString stringWithDict:dict] responseCallback:^(id responseData) {
                NSLog(@"from js: %@", responseData);
            }];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}

- (IBAction)clickSearch:(id)sender {
    XHContractMarketSearchVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"XHContractMarketSearchVC"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    WeakSelf(ws);
    vc.clickChoose = ^(NSString * _Nonnull chooseStr) {
        ws.baseCoin = chooseStr;
        ws.titleLB.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_exchange_oi"),ws.baseCoin];
        if (![ws.typeBtn.titleLabel.text isEqualToString:@"USD"]){
            [ws.typeBtn setTitle:chooseStr forState:UIControlStateNormal];
        }
        [ws postOpenInterestDataAndType:ws.baseCoin];
        [ws getOpenInterestJSDataWith:ws.baseCoin andTime:ws.webTime andType:ws.type];
        
        NSIndexSet *indexes = [ws.headerTitleArray indexesOfObjectsPassingTest:^BOOL(NSString *obj, NSUInteger idx, BOOL *stop) {
            return [obj isEqualToString:chooseStr];
        }];
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            ws.segmentedView.selectedSegmentIndex = idx;
        }];
    };
}

- (IBAction)clickTimeButton:(UIButton *)sender {
   
    BaseAlertController *alertController = [BaseAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (sender == self.timeBtn){
        [alertController setActionWithArray:@[@"15m",@"30m",@"1h",@"2h",@"4h",@"12h",@"1d"]];
    }else if (sender == self.exchangeBtn){
        [alertController setActionWithArray:@[@"ALL",@"Binance",@"Okex",@"Bybit",@"CME",@"Bitget",@"Bitmex",@"Bitfinex",@"Gate",@"Deribit",@"Huobi",@"Kraken"]];
    }else if (sender == self.typeBtn){
        [alertController setActionWithArray:@[@"USD",self.baseCoin]];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:MyLocalized(@"s_cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    WeakSelf(ws);
    alertController.clickActionBlock = ^(NSInteger index, NSString * _Nonnull str) {
        if (sender == ws.timeBtn){
            [ws.timeBtn setTitle:str forState:UIControlStateNormal];
            ws.webTime = str;
        }else if (sender == ws.exchangeBtn){
            [ws.exchangeBtn setTitle:str forState:UIControlStateNormal];
            if ([str isEqualToString:@"ALL"]){
                ws.exchange = @"";
            }else{
                ws.exchange = str;
            }
        }else if (sender == ws.typeBtn){
            [ws.typeBtn setTitle:str forState:UIControlStateNormal];
            ws.type = str;
        }
        [ws getOpenInterestJSDataWith:ws.baseCoin andTime:ws.webTime andType:ws.type];
    };
}


@end
