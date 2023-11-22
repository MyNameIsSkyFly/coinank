//
//  XHLongsShortRatioTopCell.m
//  UUKR
//
//  Created by ZXH on 2023/8/9.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import "XHLongsShortRatioTopCell.h"

@implementation XHLongsShortRatioTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.LB1.text = MyLocalized(@"s_exchange_name");
    self.LB2.text = MyLocalized(@"s_longs");
    self.LB3.text = MyLocalized(@"s_shorts");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
