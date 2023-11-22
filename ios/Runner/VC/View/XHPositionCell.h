//
//  XHPositionCell.h
//  UUKR
//
//  Created by ZXH on 2022/6/24.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHPositionCell : UITableViewCell

@property (strong, nonatomic)NSString *baseCoin;//币种

- (void)setCellDataWithModel:(XHPositionModel *)model;



@end

NS_ASSUME_NONNULL_END
