//
//  XHPriceChangesVC2.m
//  UUKR
//
//  Created by ZXH on 2023/6/28.
//  Copyright © 2023 ZHX. All rights reserved.
//


#import "XHPriceChangesVC2.h"
#import "XHContractModel.h"
#import "AroundCell.h"
#import "CTHeadCellView.h"

@interface XHPriceChangesVC2 ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) AroundCell *aroundCell;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic,assign) float cellLastX; //最后的cell的移动距离

@property (nonatomic, strong) NSString *sortType;
@property (nonatomic, strong) NSString *sortBy;
@property (nonatomic, strong) UIButton *selectedButton;

@property (strong, nonatomic)NSMutableArray <XHContractModel *>*listArray;
@property (strong, nonatomic)NSArray *headerArray;

@property (strong, nonatomic) NSTimer *loadTimer;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation XHPriceChangesVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorNamed:@"white_color"];
    
    if (self.isPriceCharge){
        self.title = MyLocalized(@"s_price_chg");
    }else{
        self.title = MyLocalized(@"s_oi_chg");
    }
    
    self.sortType = @"descend";
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHight + CT_HEAD_CELLVIEW_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - CT_HEAD_CELLVIEW_HEIGHT - kNavAndStatusHight) style:UITableViewStylePlain];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    //self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.myTableView];
    
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [ws get24HPriceDataWith:ws.sortType andSortBy:ws.sortBy];
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.myTableView.mj_header = header;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:@"tapCellScrollNotification" object:nil];
    
    
    [self setHeaderData];
    
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
                [ws reloadData];
            }
            
        } repeats:YES];
    }
}

- (void)setHeaderData{
    if (self.isPriceCharge){
        self.headerArray = @[[NSString stringWithFormat:@"%@($)",MyLocalized(@"s_price")],
                        [NSString stringWithFormat:@"%@(5m)",MyLocalized(@"s_price_chg")],
                        [NSString stringWithFormat:@"%@(15m)",MyLocalized(@"s_price_chg")],
                        [NSString stringWithFormat:@"%@(30m)",MyLocalized(@"s_price_chg")],
                        [NSString stringWithFormat:@"%@(1h)",MyLocalized(@"s_price_chg")],
                        [NSString stringWithFormat:@"%@(4h)",MyLocalized(@"s_price_chg")],
                        [NSString stringWithFormat:@"%@(24h)",MyLocalized(@"s_price_chg")]
        ];
    }else{
        self.headerArray = @[[NSString stringWithFormat:@"%@($)",MyLocalized(@"s_price")],
                        [NSString stringWithFormat:@"%@($)",MyLocalized(@"s_oi_vol")],
                        [NSString stringWithFormat:@"%@(1H)",MyLocalized(@"s_oi_chg")],
                        [NSString stringWithFormat:@"%@(4H)",MyLocalized(@"s_oi_chg")],
                        [NSString stringWithFormat:@"%@(24H)",MyLocalized(@"s_oi_chg")]
        ];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHight, kScreenWidth, CT_HEAD_CELLVIEW_HEIGHT)];
    
    UILabel *titleLbl = [UILabel new];
    titleLbl.frame = CGRectMake(0, 0, CT_HEAD_CELLVIEW_WIDTH, CT_HEAD_CELLVIEW_HEIGHT);
    titleLbl.text = @"Coin";
    titleLbl.font = [UIFont boldSystemFontOfSize:16];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.backgroundColor = [UIColor colorNamed:@"white_color"];
    [headerView addSubview:titleLbl];
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CT_HEAD_CELLVIEW_WIDTH, 0, self.view.bounds.size.width-CT_HEAD_CELLVIEW_WIDTH, CT_HEAD_CELLVIEW_HEIGHT)];
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.backgroundColor = [UIColor colorNamed:@"white_color"];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    
    NSArray *topArr = self.headerArray;
    WeakSelf(ws);
    [topArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CTHeadCellView *headView = [[CTHeadCellView alloc] initWithFrame:(CGRect){0+(CT_HEAD_CELLVIEW_WIDTH)*idx,0,CT_HEAD_CELLVIEW_WIDTH,CT_HEAD_CELLVIEW_HEIGHT}];
        [headView.titleBtn setTitle:topArr[idx] forState:UIControlStateNormal];
        [headView.titleBtn addTarget:ws action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
        if (_isPriceCharge){
            headView.titleBtn.tag = 200 + idx;
        }else{
            headView.titleBtn.tag = 100 + idx;
        }
        [ws.topScrollView addSubview:headView];
        
    }];
    self.topScrollView.contentSize = CGSizeMake(CT_HEAD_CELLVIEW_WIDTH * topArr.count, 0);
    self.topScrollView.delegate = self;
    [self.topScrollView setContentOffset:CGPointMake(self.cellLastX, 0) animated:NO];
    
    [headerView addSubview:self.topScrollView];
    [self.view addSubview:headerView];
}


- (void)reloadData{
    [self get24HPriceDataWith:self.sortType andSortBy:self.sortBy];
}


/// 请求价格数据
- (void)get24HPriceDataWith:(NSString *)sortType andSortBy:(NSString *)sortBy{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,HTTP_GET_INSTRUMENTS_URL];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [paraments setObject:@"1" forKey:@"page"];
    [paraments setObject:@"100" forKey:@"size"];
    [paraments setObject:sortType forKey:@"sortType"];
    if (sortBy.length){
        [paraments setObject:sortBy forKey:@"sortBy"];
    }
//    if ([sortBy isEqualToString:@"openInterest"]){
//        url = [NSString stringWithFormat:@"%@%@",kApiPrefix,HTTP_GET_INSTRUMENTS2_URL];
//        [paraments setObject:@"3000000~" forKey:@"openInterest"];
//        [paraments setValue:@(0) forKey:@"isFollow"];
//        [paraments setObject:@"oi" forKey:@"type"];
//    }

    if (self.isPriceCharge){
        [paraments setObject:@"priceChangeH24" forKey:@"sort"];
    }else{
        [paraments setObject:@"openInterestCh24" forKey:@"sort"];
        url = [NSString stringWithFormat:@"%@%@",kApiPrefix,HTTP_GET_INSTRUMENTS2_URL];
        [paraments setObject:@"3000000~" forKey:@"openInterest"];
        [paraments setValue:@(0) forKey:@"isFollow"];
        [paraments setObject:@"oi" forKey:@"type"];
    }
    
    WeakSelf(ws);
    self.isLoading = YES;
    [XHHttpTool requestWithType:HttpRequestTypeGet urlString:url parameters:paraments successBlock:^(BaseModel * _Nonnull baseModel) {
        ws.isLoading = NO;
        if (baseModel.success){
            NSArray <XHContractModel *>*dataArray = [NSArray modelArrayWithClass:[XHContractModel class] json:baseModel.data[@"list"]];
            ws.listArray = dataArray.modelCopy;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
            [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    _aroundCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!_aroundCell) {
        _aroundCell = [[AroundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [_aroundCell setCellDataWithModel:self.listArray[indexPath.row] andIsPriceCharge:self.isPriceCharge];
    
    _aroundCell.tableView = self.myTableView;
    __weak typeof(self) weakSelf = self;
    _aroundCell.tapCellClick = ^(NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    
    
    return _aroundCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选中");
    
    XHContractModel *model = self.listArray[indexPath.row];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.flutterApi toKLineExchangeName:model.exchangeName symbol:model.symbol baseCoin:model.baseCoin productType:nil completion:^(FlutterError * error) {
        
    }];
    [self.navigationController popViewControllerAnimated:false];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

/// 点击title
/// - Parameter btn: 按钮
- (void)clickTitle:(UIButton *)btn{
    if (btn != self.selectedButton) {
        [self.selectedButton setImage:[UIImage imageNamed:@"triangle_down_default"] forState:UIControlStateNormal];
    }
    
    NSString *sortType = @"descend";
    NSString *sortBy = [self disPoseSortbyWith:btn];
    
    UIImage *currentImage = btn.currentImage;
    if ([currentImage isEqual:[UIImage imageNamed:@"triangle_down_default"]]) {
        [btn setImage:[UIImage imageNamed:@"triangle_up_selected"] forState:UIControlStateNormal];
        sortType = @"ascend";
    } else if ([currentImage isEqual:[UIImage imageNamed:@"triangle_up_selected"]]) {
        [btn setImage:[UIImage imageNamed:@"triangle_down_selected"] forState:UIControlStateNormal];
        sortType = @"descend";
    } else if ([currentImage isEqual:[UIImage imageNamed:@"triangle_down_selected"]]) {
        [btn setImage:[UIImage imageNamed:@"triangle_down_default"] forState:UIControlStateNormal];
        sortType = @"descend";
        sortBy = @"";
    }
    
    self.selectedButton = btn;
    
    self.sortType = sortType;
    self.sortBy = sortBy;
    [self get24HPriceDataWith:self.sortType andSortBy:self.sortBy];
}

#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint offSet = _aroundCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        _aroundCell.rightScrollView.contentOffset = offSet;
    }
    if ([scrollView isEqual:self.myTableView]) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapCellScrollNotification" object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
    }
    
}


-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    float y = [noticeInfo[@"cellOffY"] floatValue];
    self.cellLastX = x;
    CGPoint offSet = self.topScrollView.contentOffset;
    offSet.x = x;
    offSet.y = y;
    self.topScrollView.contentOffset = offSet;
    obj = nil;
}


- (NSString *)disPoseSortbyWith:(UIButton *)btn{
    NSString *sortby = @"";
    if (_isPriceCharge){
        switch (btn.tag - 200) {
            case 0:
                sortby = @"price";
                break;
            case 1:
                sortby = @"priceChangeM5";
                break;
            case 2:
                sortby = @"priceChangeM15";
                break;
            case 3:
                sortby = @"priceChangeM30";
                break;
            case 4:
                sortby = @"priceChangeH1";
                break;
            case 5:
                sortby = @"priceChangeH4";
                break;
            case 6:
                sortby = @"priceChangeH24";
                break;
                
            default:
                break;
        }
    }else{
        switch (btn.tag - 100) {
            case 0:
                sortby = @"price";
                break;
            case 1:
                sortby = @"openInterest";
                break;
            case 2:
                sortby = @"openInterestCh1";
                break;
            case 3:
                sortby = @"openInterestCh4";
                break;
            case 4:
                sortby = @"openInterestCh24";
                break;
            default:
                break;
        }
    }
    return sortby;
}

@end
