//
//  XHHudTool.m
//  UUKR
//
//  Created by ZXH on 2022/6/20.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "XHHudTool.h"
#import "MBProgressHUD.h"


@interface XHHudTool() <MBProgressHUDDelegate>
{
    
    BOOL _flag;
}

@property (strong, nonatomic)MBProgressHUD *hud;

@end

@implementation XHHudTool
single_implementation(XHHudTool)

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc]initWithView:[kAppDelegate window]];
        _hud.delegate = self;
        _hud.detailsLabel.font = [UIFont boldSystemFontOfSize:14];
        _hud.label.adjustsFontSizeToFitWidth = YES;
        _hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHud)];
        [_hud addGestureRecognizer:tap];
    }
    return _hud;
}

- (void)hideHud{
    WeakSelf(ws);
    dispatch_async(dispatch_get_main_queue(), ^{
        ws.hud.detailsLabel.text = nil;
        [ws.hud removeFromSuperview];
        ws.hud.userInteractionEnabled =  YES;
    });
}

- (void)show{
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.userInteractionEnabled =  YES;
    [[kAppDelegate window] addSubview:self.hud];
    [self.hud showAnimated:YES];
}

- (void)showWithLoadingtext:(NSString *)text{
    if (text) {
        self.hud.detailsLabel.text = text;
    } else {
        self.hud.label.text = nil;
    }
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.userInteractionEnabled =  YES;
    [[kAppDelegate window] addSubview:self.hud];
    [self.hud showAnimated:YES];
}

- (void)hide{
    [self hideHud];
}

@end
