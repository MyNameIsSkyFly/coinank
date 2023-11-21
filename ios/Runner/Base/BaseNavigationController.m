//
//  BaseNavigationController.m
//  UUKR
//
//  Created by ZXH on 2022/6/17.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorNamed:@"white_color"];
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    // 背景色
    appearance.backgroundColor = [UIColor colorNamed:@"white_color"];
    //appearance.backgroundImage = [UIImage imageNamed:@"navbar_bg"];
    // 去掉半透明效果
    //appearance.backgroundEffect = nil;
    // 标题字体颜色及大小
    appearance.titleTextAttributes = @{
        NSForegroundColorAttributeName : [UIColor colorNamed:@"title_color"],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
    };
    // 设置导航栏下边界分割线透明
    appearance.shadowImage = [[UIImage alloc] init];
    // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
    appearance.shadowColor = [UIColor clearColor];
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    self.navigationController.navigationBar.standardAppearance = appearance;
    
    self.navigationBar.barStyle = UIBarStyleDefault;
    if ([kTheme isEqualToString:@"night"]) {
        self.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }else{
        self.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    //设置文字主题
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName : [UIColor colorNamed:@"title_color"],
                                  NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                  
                                  }];
    
    //[bar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //修改所有UIBarButtonItem的外观
    [UIBarButtonItem appearance].tintColor = [UIColor colorNamed:@"title_color"];
    [bar setTintColor:[UIColor colorNamed:@"title_color"]];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}


@end
