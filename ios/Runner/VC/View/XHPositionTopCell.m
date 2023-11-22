//
//  XHPositionTopCell.m
//  UUKR
//
//  Created by ZXH on 2023/9/1.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import "XHPositionTopCell.h"

@implementation XHPositionTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.LB1.text = MyLocalized(@"s_exchange_name");
    self.LB2.text = MyLocalized(@"s_oi");
    self.LB3.text = MyLocalized(@"s_rate");
    self.LB4.text = MyLocalized(@"s_24h_chg");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
