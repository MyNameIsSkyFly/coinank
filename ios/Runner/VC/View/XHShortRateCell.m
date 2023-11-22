//
//  XHShortRateCell.m
//  UUKR
//
//  Created by ZXH on 2022/6/24.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "XHShortRateCell.h"

@interface XHShortRateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *leftrateLB;
@property (weak, nonatomic) IBOutlet UILabel *rightrateLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewEqalWithd;

@property (nonatomic, strong) NSLayoutConstraint *currentConstraint;

@end

@implementation XHShortRateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(XHShortRateModel *)model{
    _iconImageV.image = [UIImage imageNamed:model.exchangeName];
    if ([model.exchangeName isEqualToString:@"All"]){
        _iconImageV.image = [UIImage imageNamed:@"all"];
    }
    _nameLB.text = model.exchangeName;
    _leftrateLB.text = [NSString stringWithFormat:@"%.2f%@",model.longRatio*100,@"%"];
    _rightrateLB.text = [NSString stringWithFormat:@"%.2f%@",model.shortRatio*100,@"%"];
    //NSLog(@"%f",model.longRatio);
    if (model.longRatio && _topViewEqalWithd) {
        [self p_changeMultiplierOfConstraint:_topViewEqalWithd multiplier:0];
        [self p_changeMultiplierOfConstraint:_topViewEqalWithd multiplier:model.longRatio];
    }
    
    _topView.backgroundColor = kIsRedGreen ? [UIColor colorNamed:@"red_color"] : [UIColor colorNamed:@"green_color"];
    _bottomView.backgroundColor = kIsRedGreen ? [UIColor colorNamed:@"green_color"] : [UIColor colorNamed:@"red_color"];
    
}

- (void)p_changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier {
    if (self.currentConstraint != nil) {
        [NSLayoutConstraint deactivateConstraints:@[self.currentConstraint]];
    }

    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    newConstraint.priority = constraint.priority;
    newConstraint.shouldBeArchived = constraint.shouldBeArchived;
    newConstraint.identifier = constraint.identifier;

    [NSLayoutConstraint activateConstraints:@[newConstraint]];
    self.currentConstraint = newConstraint;
}


@end
