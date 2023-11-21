//
//  BaseViewController.m
//  UUKR
//
//  Created by ZXH on 2022/6/16.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    //[backButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.view.backgroundColor = [UIColor colorNamed:@"white_color"];
    if (kIsDark) {
        self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }else{
        self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }

}

- (void)backItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
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


- (void)dealloc{
    [kNotificationCenter removeObserver:self];
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"%@ 被释放了",className);
}

@end
