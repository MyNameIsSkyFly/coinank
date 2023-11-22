//
//  AroundCell.h
//  AroundVC
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#define CT_HEAD_CELLVIEW_WIDTH 110
#define CT_HEAD_CELLVIEW_HEIGHT 50

#import <UIKit/UIKit.h>
#import "XHContractModel.h"

@interface AroundCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic,assign) float lastX; 

@property (strong, nonatomic) UIView * _Nullable nameView;
@property (strong, nonatomic) UIScrollView *_Nullable rightScrollView;

@property (nonatomic, strong) UITableView *_Nullable tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) void(^ _Nullable tapCellClick)(NSIndexPath * _Nullable indexPath);

- (void)setCellDataWithModel:(XHContractModel *_Nullable)model andIsPriceCharge:(BOOL)isPriceCharge;

@end
