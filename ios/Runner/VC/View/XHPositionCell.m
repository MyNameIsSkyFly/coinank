//
//  XHPositionCell.m
//  UUKR
//
//  Created by ZXH on 2022/6/24.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "XHPositionCell.h"

@interface XHPositionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;

@property (weak, nonatomic) IBOutlet UILabel *positionLB1;
@property (weak, nonatomic) IBOutlet UILabel *positionLB2;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *rateLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;

@property (weak, nonatomic) IBOutlet UILabel *lastRateLB;

@end

@implementation XHPositionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(XHPositionModel *)model{
    if ([model.exchangeName isEqualToString:@"ALL"]) {
        model.exchangeName = @"all";
    }
    _iconImageV.image = [UIImage imageNamed:model.exchangeName];
    _nameLB.text = model.exchangeName;
    
    if (model.coinValue) {
        NSString *value = [NSString suffixNumber:[NSNumber numberWithFloat:model.coinValue]];
        _positionLB1.text = [NSString stringWithFormat:@"$%@",value];
    }
    
    
    if (model.coinCount) {
//        NSNumberFormatter *formatter2 = [[NSNumberFormatter alloc]init];
//        formatter2.numberStyle = NSNumberFormatterCurrencyISOCodeStyle;
//        formatter2.positivePrefix = @"≈";// 前缀符号
//        formatter2.positiveSuffix = @"K BTC";// 后缀符号
//        formatter2.minimumFractionDigits = 1;// 最少展示位小数
//        NSNumber *value2 = [NSNumber numberWithFloat:model.coinCount*0.001];
//        _positionLB2.text = [formatter2 stringFromNumber:value2];
        
        NSString *value = [NSString suffixNumber:[NSNumber numberWithFloat:model.coinCount]];
        _positionLB2.text = [NSString stringWithFormat:@"≈%@ %@",value,self.baseCoin];
    }

    
    if (model.rate && _topViewConstraint) {
        [self p_changeMultiplierOfConstraint:_topViewConstraint multiplier:model.rate];
    }
    
    _rateLB.text = [NSString stringWithFormat:@"%.2f%@",model.rate*100,@"%"];
    
    _lastRateLB.text = [NSString stringWithFormat:@"%.2f%@",model.change24H*100,@"%"];
    if (model.change24H > 0) {
        _lastRateLB.textColor = kIsRedGreen ? [UIColor colorNamed:@"red_color"] : [UIColor colorNamed:@"green_color"];
    }else{
        _lastRateLB.textColor = kIsRedGreen ? [UIColor colorNamed:@"green_color"] : [UIColor colorNamed:@"red_color"];
    }
}

- (void)p_changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier {
    
    [NSLayoutConstraint deactivateConstraints:@[constraint]];
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    newConstraint.priority = constraint.priority;
    newConstraint.shouldBeArchived = constraint.shouldBeArchived;
    newConstraint.identifier = constraint.identifier;
    [NSLayoutConstraint activateConstraints:@[newConstraint]];
}

@end
