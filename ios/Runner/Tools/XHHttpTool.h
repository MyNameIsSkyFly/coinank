//
//  XHHttpTool.h
//  UUKR
//
//  Created by ZXH on 2022/6/20.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 请求类型的枚举 */
typedef NS_ENUM(NSUInteger, HttpRequestType)
{
    /** get请求 */
    HttpRequestTypeGet = 0,
    /** post请求 */
    HttpRequestTypePost
};

/**
 http通讯成功的block

 @param baseModel 返回的数据
 */
typedef void (^HTTPRequestSuccessBlock)(BaseModel *baseModel);

/**
 http通讯失败后的block

 @param error 返回的错误信息
 */
typedef void (^HTTPRequestFailedBlock)(NSError *error);


//超时时间
extern NSInteger const kAFNetworkingTimeoutInterval;

@interface XHHttpTool : NSObject

/**
 *  网络请求的实例方法
 *
 *  @param type         get / post (项目目前只支持这倆中)
 *  @param urlString    请求的地址
 *  @param parameters   请求的参数
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)requestWithType:(HttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(HTTPRequestSuccessBlock)successBlock
           failureBlock:(HTTPRequestFailedBlock)failureBlock;

/**
 取消队列
 */
+(void)cancelDataTask;

@end

NS_ASSUME_NONNULL_END
