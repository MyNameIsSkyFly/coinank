//
//  BaseModel.h
//  UUKR
//
//  Created by ZXH on 2022/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

@property (assign, nonatomic) int code;
@property (strong, nonatomic) id data;
@property (strong, nonatomic) NSString *ext;
@property (strong, nonatomic) NSString *msg;
@property (assign, nonatomic) BOOL success;

@end

NS_ASSUME_NONNULL_END
