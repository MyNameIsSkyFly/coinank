//
//  Macro.h
//  UUKR
//
//  Created by ZXH on 2022/6/10.
//

#ifndef Macro_h
#define Macro_h

#define MyLocalized(val)          NSLocalizedString((val), nil)
#define kIsPortrait (UIApplication.sharedApplication.windows.firstObject.windowScene.interfaceOrientation == UIDeviceOrientationPortrait)

#define kAppDelegate        (AppDelegate *)[UIApplication sharedApplication].delegate
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kApplication        [UIApplication sharedApplication]
#define kToastTool          [XHToast sharedXHToast]
#define kHudTool            [XHHudTool sharedXHHudTool]



#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kNavAndStatusHight  (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)

#define WeakSelf(weakSelf)      __weak __typeof(&*self)    weakSelf  = self;
#define StrongSelf(strongSelf)  __strong __typeof(&*self) strongSelf = weakSelf;



#endif /* Macro_h */
