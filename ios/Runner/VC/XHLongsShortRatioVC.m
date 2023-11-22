//
//  XHLongsShortRatioVC.m
//  UUKR
//
//  Created by ZXH on 2023/8/9.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import "XHLongsShortRatioVC.h"
#import "XHContractMarketSearchVC.h"
#import "HMSegmentedControl.h"
#import "XHHomeModel.h"
#import "XHShortRateCell.h"
#import "XHLongsShortRatioTopCell.h"
#import <WebKit/WebKit.h>

@interface XHLongsShortRatioVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedView;
@property (weak, nonatomic) IBOutlet XHWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn2;
@property (weak, nonatomic) IBOutlet UILabel *titleLB1;
@property (weak, nonatomic) IBOutlet UILabel *titleLB2;


@property (nonatomic, strong)NSString *type;
@property (strong, nonatomic)NSString *longsortTime;
@property (strong, nonatomic)NSString *webTime;
@property (strong, nonatomic)NSArray *headerTitleArray;

@property (strong, nonatomic)NSArray <XHShortRateModel *>*shortRateArray;

@property (strong, nonatomic) NSTimer *loadTimer;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation XHLongsShortRatioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = MyLocalized(@"s_buysel_longshort_ratio");
    // Do any additional setup after loading the view.
    
    self.type = @"BTC";
    self.longsortTime = @"5m";
    self.webTime = @"5m";
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [ws getAllCurrency];
        [ws postShortRateData:ws.longsortTime andType:ws.type];
        [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.myTableView.mj_header = header;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"XHShortRateCell" bundle:nil] forCellReuseIdentifier:@"XHShortRateCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"XHLongsShortRatioTopCell" bundle:nil] forCellReuseIdentifier:@"XHLongsShortRatioTopCell"];
    
    [self setSegmentViewData];
    
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"t18" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:request];
    
    self.titleLB1.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_buysel_longshort_ratio"),self.type];
    self.titleLB2.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_takerbuy_longshort_ratio_chart"),self.type];
    
    [kNotificationCenter addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
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
        self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:5 block:^(NSTimer * _Nonnull timer) {
            if (!ws.isLoading){
                [ws postShortRateData:ws.longsortTime andType:ws.type];
                [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
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
        ws.type = ws.headerTitleArray[index];
        ws.titleLB1.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_buysel_longshort_ratio"),ws.type];
        ws.titleLB2.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_takerbuy_longshort_ratio_chart"),ws.type];
        [ws postShortRateData:ws.longsortTime andType:ws.type];
        [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
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
    return self.shortRateArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        XHShortRateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XHShortRateCell" forIndexPath:indexPath];
        if (self.shortRateArray) {
            XHShortRateModel *model = self.shortRateArray[indexPath.row-1];
            [cell setCellDataWithModel:model];
        }
        return cell;
    }else{
        XHLongsShortRatioTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XHLongsShortRatioTopCell" forIndexPath:indexPath];
        return cell;
    }
}

/// 请求多空比数据
- (void)postShortRateData:(NSString *)longSortTime andType:(NSString *)type{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,HTTP_GET_SHORTRATE_URL];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [paraments setObject:longSortTime forKey:@"interval"];
    [paraments setObject:type forKey:@"baseCoin"];
    WeakSelf(ws);
    self.isLoading = YES;
    [XHHttpTool requestWithType:HttpRequestTypeGet urlString:url parameters:paraments successBlock:^(BaseModel * _Nonnull baseModel) {
        ws.isLoading = NO;
        if (baseModel.success) {
            ws.shortRateArray = [NSArray modelArrayWithClass:[XHShortRateModel class] json:baseModel.data];
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
- (void)getShortRateJSDataWith:(NSString *)exchangeName andTime:(NSString *)longSortTime andType:(NSString *)type{
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,HTTP_GETSHORTRATE_JS_URL];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [paraments setObject:longSortTime forKey:@"interval"];
    [paraments setObject:type forKey:@"baseCoin"];
    [paraments setObject:exchangeName forKey:@"exchangeName"];
    
    WeakSelf(ws);
    [XHHttpTool requestWithType:HttpRequestTypeGet urlString:url parameters:paraments successBlock:^(BaseModel * _Nonnull baseModel) {
        if (baseModel.success) {
            XHShortRateModel *model = [XHShortRateModel modelWithDictionary:baseModel.data];
            NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
            [map setObject:model.exchangeName forKey:@"exchangeName"];
            [map setObject:model.interval forKey:@"interval"];
            [map setObject:model.baseCoin forKey:@"baseCoin"];
            [map setObject:[NSString getLanguageSir] forKey:@"locale"];
            [map setObject:MyLocalized(@"s_price") forKey:@"price"];
            [map setObject:MyLocalized(@"s_longs") forKey:@"seriesLongName"];
            [map setObject:MyLocalized(@"s_shorts") forKey:@"seriesShortName"];
            [map setObject:MyLocalized(@"s_longshort_ratio") forKey:@"ratioName"];
            
            //NSString *json = [NSString stringWithDict:map];
            //NSLog(@"json ==%@",json);
            
            NSDictionary *dict = @{@"dataParams":baseModel.modelToJSONObject,
                                   @"platform":@"ios",
                                   @"dataType":@"realtimeLongShort",
                                   @"dataOptions":map
            };
            NSLog(@"--%@",dict);
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
        ws.type = chooseStr;
        ws.titleLB1.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_buysel_longshort_ratio"),ws.type];
        ws.titleLB2.text = [NSString stringWithFormat:@"%@(%@)",MyLocalized(@"s_takerbuy_longshort_ratio_chart"),ws.type];
        [ws postShortRateData:ws.longsortTime andType:ws.type];
        [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
        
        NSIndexSet *indexes = [ws.headerTitleArray indexesOfObjectsPassingTest:^BOOL(NSString *obj, NSUInteger idx, BOOL *stop) {
            return [obj isEqualToString:chooseStr];
        }];
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            ws.segmentedView.selectedSegmentIndex = idx;
        }];
    };
}

- (IBAction)clickTimeButton:(UIButton *)sender {
    WeakSelf(ws);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"5m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender == ws.timeBtn1){
            ws.longsortTime = @"5m";
            [ws postShortRateData:ws.longsortTime andType:ws.type];
            [ws.timeBtn1 setTitle:ws.longsortTime forState:UIControlStateNormal];
        }else{
            ws.webTime = @"5m";
            [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
            [ws.timeBtn2 setTitle:ws.webTime forState:UIControlStateNormal];
        }
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"15m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender == ws.timeBtn1){
            ws.longsortTime = @"15m";
            [ws postShortRateData:ws.longsortTime andType:ws.type];
            [ws.timeBtn1 setTitle:ws.longsortTime forState:UIControlStateNormal];
        }else{
            ws.webTime = @"15m";
            [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
            [ws.timeBtn2 setTitle:ws.webTime forState:UIControlStateNormal];
        }
    }];
    
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"30m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender == ws.timeBtn1){
            ws.longsortTime = @"30m";
            [ws postShortRateData:ws.longsortTime andType:ws.type];
            [ws.timeBtn1 setTitle:ws.longsortTime forState:UIControlStateNormal];
        }
        else{
            ws.webTime = @"30m";
            [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
            [ws.timeBtn2 setTitle:ws.webTime forState:UIControlStateNormal];
        }
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"1h" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender == ws.timeBtn1){
            ws.longsortTime = @"1h";
            [ws postShortRateData:ws.longsortTime andType:ws.type];
            [ws.timeBtn1 setTitle:ws.longsortTime forState:UIControlStateNormal];
        }else{
            ws.webTime = @"1h";
            [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
            [ws.timeBtn2 setTitle:ws.webTime forState:UIControlStateNormal];
        }
    }];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"2h" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender == ws.timeBtn1){
            ws.longsortTime = @"2h";
            [ws postShortRateData:ws.longsortTime andType:ws.type];
            [ws.timeBtn1 setTitle:ws.longsortTime forState:UIControlStateNormal];
        }else{
            ws.webTime = @"2h";
            [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
            [ws.timeBtn2 setTitle:ws.webTime forState:UIControlStateNormal];
        }
    }];
    
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"4h" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender == ws.timeBtn1){
            ws.longsortTime = @"4h";
            [ws postShortRateData:ws.longsortTime andType:ws.type];
            [ws.timeBtn1 setTitle:ws.longsortTime forState:UIControlStateNormal];
        }else{
            ws.webTime = @"4h";
            [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
            [ws.timeBtn2 setTitle:ws.webTime forState:UIControlStateNormal];
        }
    }];
    
    UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"12h" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender == ws.timeBtn1){
            ws.longsortTime = @"12h";
            [ws postShortRateData:ws.longsortTime andType:ws.type];
            [ws.timeBtn1 setTitle:ws.longsortTime forState:UIControlStateNormal];
        }else{
            ws.webTime = @"12h";
            [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
            [ws.timeBtn2 setTitle:ws.webTime forState:UIControlStateNormal];
        }
    }];
    
    UIAlertAction *action8 = [UIAlertAction actionWithTitle:@"1d" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender == ws.timeBtn1){
            ws.longsortTime = @"1d";
            [ws postShortRateData:ws.longsortTime andType:ws.type];
            [ws.timeBtn1 setTitle:ws.longsortTime forState:UIControlStateNormal];
        }else{
            ws.webTime = @"1d";
            [ws getShortRateJSDataWith:@"Binance" andTime:ws.webTime andType:ws.type];
            [ws.timeBtn2 setTitle:ws.webTime forState:UIControlStateNormal];
        }
        
    }];
                                                   
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:MyLocalized(@"s_cancel") style:UIAlertActionStyleCancel handler:nil];
    
    BaseAlertController *alertController = [BaseAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [alertController addAction:action5];
    [alertController addAction:action6];
    [alertController addAction:action7];
    [alertController addAction:action8];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
