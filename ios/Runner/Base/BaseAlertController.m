//
//  BaseAlertController.m
//  UUKR
//
//  Created by ZXH on 2022/7/30.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "BaseAlertController.h"

@interface BaseAlertController ()

@end

@implementation BaseAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setActionWithArray:(NSArray *)array{
    WeakSelf(ws);
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.clickActionBlock){
                self.clickActionBlock(idx,obj);
            }
        }];
        [self addAction:action];
    }];
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle{
    
    if ([kTheme isEqualToString:@"night"]) {
        return UIUserInterfaceStyleDark;
    }else{
        return UIUserInterfaceStyleLight;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if ([kTheme isEqualToString:@"night"]) {
        return UIStatusBarStyleLightContent;
    }else{
        return UIStatusBarStyleDarkContent;
    }
}

@end
