//
//  AroundCell.m
//  AroundVC
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "AroundCell.h"

@implementation AroundCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:@"tapCellScrollNotification" object:nil];
    }
    return self;
}

- (void)setCellDataWithModel:(XHContractModel *)model andIsPriceCharge:(BOOL)isPriceCharge{
    
    [self.contentView removeAllSubviews];
    
    NSMutableArray *rightArray = [NSMutableArray array];
    
    [rightArray addObject:@{@"text":[NSString getStringFrom:model.price],
                            @"text_color":[UIColor colorNamed:@"text_default"]
                          }];
    if (isPriceCharge){
        
        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.priceChangeM5,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.priceChangeM5]
                              }];
        
        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.priceChangeM15,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.priceChangeM15]
                              }];
        
        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.priceChangeM30,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.priceChangeM30]
                              }];
        
        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.priceChangeH1,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.priceChangeH1]
                              }];
        

        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.priceChangeH4,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.priceChangeH4]
                              }];

        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.priceChangeH24,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.priceChangeH24]
                              }];
    }else{
        NSNumber *value1 = [NSNumber numberWithFloat:model.openInterest];
        [rightArray addObject:@{@"text":[NSString suffixNumber:value1],
                                @"text_color":[UIColor colorNamed:@"text_default"]
                              }];
    
        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.openInterestCh1*100,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.openInterestCh1]
                              }];
        
        
        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.openInterestCh4*100,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.openInterestCh4]
                              }];
        
        [rightArray addObject:@{@"text":[NSString stringWithFormat:@"%.2f%@",model.openInterestCh24*100,@"%"],
                                @"text_color":[XHTools getColorWithNumber:model.openInterestCh24]
                              }];
        
    }
    
    self.nameView = [UIView new];
    self.nameView.frame = CGRectMake(0, 0, CT_HEAD_CELLVIEW_WIDTH, CT_HEAD_CELLVIEW_HEIGHT);
    [self.contentView addSubview:self.nameView];
    
    UIImageView *iconImageV = [UIImageView new];
    [iconImageV sd_setImageWithURL:model.coinImage];
    [self.nameView addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameView).offset(8);
        make.centerY.equalTo(self.nameView);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *nameLB = [UILabel new];
    nameLB.textColor = [UIColor colorNamed:@"text_default"];
    nameLB.font = [UIFont systemFontOfSize:14];
    nameLB.text = model.baseCoin;
    nameLB.textAlignment = 1;
    [self.nameView addSubview:nameLB];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.nameView);
        make.left.equalTo(iconImageV.mas_right).offset(0);
    }];
    
    
    self.rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CT_HEAD_CELLVIEW_WIDTH, 0, [UIScreen mainScreen].bounds.size.width-CT_HEAD_CELLVIEW_WIDTH, CT_HEAD_CELLVIEW_HEIGHT)];
    
    [rightArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(CT_HEAD_CELLVIEW_WIDTH * idx, 0, CT_HEAD_CELLVIEW_WIDTH, CT_HEAD_CELLVIEW_HEIGHT);
        label.text = obj[@"text"];
        label.textColor = obj[@"text_color"];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self.rightScrollView addSubview:label];
    }];
    
    self.rightScrollView.showsVerticalScrollIndicator = NO;
    self.rightScrollView.showsHorizontalScrollIndicator = NO;
    self.rightScrollView.contentSize = CGSizeMake(CT_HEAD_CELLVIEW_WIDTH * rightArray.count, 0);
    [self.rightScrollView setContentOffset:CGPointMake(_lastX, 0) animated:NO];
    self.rightScrollView.delegate = self;
    
    [self.contentView addSubview:self.rightScrollView];
    
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightScrollView addGestureRecognizer:tapGes];
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isNotification = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _lastX = scrollView.contentOffset.x;
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapCellScrollNotification" object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _lastX = scrollView.contentOffset.x;
    // 避开自己发的通知，只有手指拨动才会是自己的滚动
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapCellScrollNotification" object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification
{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj!=self) {
        _isNotification = YES;
        [_rightScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    }else{
        _isNotification = NO;
    }
    obj = nil;
}

#pragma mark - 点击事件
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    __weak typeof (self) weakSelf = self;
    if (self.tapCellClick) {
        NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:weakSelf];
        weakSelf.tapCellClick(indexPath);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
