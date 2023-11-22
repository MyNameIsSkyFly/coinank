//
//  XHHttpTool.m
//  UUKR
//
//  Created by ZXH on 2022/6/20.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import "XHHttpTool.h"
#import "AFHTTPSessionManager.h"

NSInteger const kAFNetworkingTimeoutInterval = 15;

@implementation XHHttpTool

static AFHTTPSessionManager *aManager;

+ (AFHTTPSessionManager *)sharedAFManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aManager = [AFHTTPSessionManager manager];
        //以下三项manager的属性根据需要进行配置
        aManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        
        aManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置超时时间
        aManager.requestSerializer.timeoutInterval = kAFNetworkingTimeoutInterval;
    });
    return aManager;
}

+ (void)requestWithType:(HttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(HTTPRequestSuccessBlock)successBlock
           failureBlock:(HTTPRequestFailedBlock)failureBlock
{
    if (urlString == nil)
    {
        return;
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    NSLog(@"\n%@\n%@",urlString,parameters);
    
    
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    [headerDict setObject:@"ios" forKey:@"client"];
    if (kToken) {
        [headerDict setObject:kToken forKey:@"token"];
    }
    
    if (type == HttpRequestTypeGet)
    {
        [[self sharedAFManager] GET:urlString parameters:parameters headers:headerDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [kHudTool hide];
            if (successBlock)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                NSLog(@"%@",dict);
                BaseModel *baseModel = [BaseModel modelWithDictionary:dict];
                successBlock(baseModel);
                if (!baseModel.success) {
                    [self showErrorInfoWithErrorCode:baseModel.code errinfo:baseModel.msg];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [kHudTool hide];
            if (error.code !=-999) {
                if (failureBlock)
                {
                    failureBlock(error);
                    [self showErrorInfoWithErrorCode:error.code errinfo:error.localizedDescription];
                }
            }
            else{
                NSLog(@"取消队列了");
            }
        }];
    }
    
    if (type == HttpRequestTypePost)
    {
        
        [[self sharedAFManager] POST:urlString parameters:parameters headers:headerDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [kHudTool hide];
            if (successBlock)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                //NSLog(@"%@",dict);
                BaseModel *baseModel = [BaseModel modelWithDictionary:dict];
                successBlock(baseModel);
                if (!baseModel.success) {
                    [self showErrorInfoWithErrorCode:baseModel.code errinfo:baseModel.msg];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [kHudTool hide];
            if (error.code !=-999) {
                if (failureBlock)
                {
                    failureBlock(error);
                    [self showErrorInfoWithErrorCode:error.code errinfo:error.localizedDescription];
                }
            }
            else{
                NSLog(@"取消队列了");
            }
        }];
    }
}

+(void)cancelDataTask
{
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:[self sharedAFManager].dataTasks];
    for (NSURLSessionDataTask *taskObj in dataTasks) {
        [taskObj cancel];
    }
}

/// 暂时错误提示
/// @param code 错误码
/// @param errinfo 提示信息
+ (void)showErrorInfoWithErrorCode:(NSInteger)code errinfo:(NSString *)errinfo{
    switch (code) {
        case 400://用户名登录失效
            [kToastTool showToastWithText:errinfo];
            [self logOut];
            break;
//        case 430://用户名不存在
//            [kToastTool showToastWithText:MyLocalized(@"用户名不存在")];
//            break;
        case 431://密码错误
            [kToastTool showToastWithText:MyLocalized(@"密码错误")];
            break;
        case 433://验证码错误
            [kToastTool showToastWithText:MyLocalized(@"s_verify_code_error")];
            break;
        case 434:
            [kToastTool showToastWithText:MyLocalized(@"此邮箱已注册")];
            break;
        case 436:
            [kToastTool showToastWithText:MyLocalized(@"验证码已发送，请勿再点击")];
            break;
        case -1001:
            [kToastTool showToastWithText:MyLocalized(@"请求超时")];
            break;
        case -1020:
            [kToastTool showToastWithText:MyLocalized(@"网络连接失败")];
            break;
        case -1009://未联网
            [kToastTool showToastWithText:MyLocalized(@"网络连接失败")];
            break;
        default:
            [kToastTool showToastWithText:errinfo];
            break;
    }
}

+ (void)logOut{
    [kUserDefaults removeObjectForKey:@"loginData"];
    [kUserDefaults removeObjectForKey:@"userName"];
    [kUserDefaults removeObjectForKey:@"token"];
    [kUserDefaults removeObjectForKey:@"password"];
    [kUserDefaults removeObjectForKey:@"isLogin"];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        XHTabBarController *_tabbar = [[XHTabBarController alloc]initWithContext:@""];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        appDelegate.window.rootViewController = _tabbar;
//    });
}

@end
