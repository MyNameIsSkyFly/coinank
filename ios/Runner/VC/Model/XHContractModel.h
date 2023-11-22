//
//  XHContractModel.h
//  UUKR
//
//  Created by ZXH on 2022/6/27.
//  Copyright © 2022 ZHX. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHContractModel : NSObject

@property (strong, nonatomic) NSString *baseCoin;
@property (strong, nonatomic) NSURL *coinImage;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) CGFloat priceChangeH24;
@property (assign, nonatomic) CGFloat priceChangeM5;
@property (assign, nonatomic) CGFloat priceChangeM15;
@property (assign, nonatomic) CGFloat priceChangeM30;
@property (assign, nonatomic) CGFloat priceChangeH1;
@property (assign, nonatomic) CGFloat priceChangeH2;
@property (assign, nonatomic) CGFloat priceChangeH4;
@property (assign, nonatomic) CGFloat priceChangeH6;
@property (assign, nonatomic) CGFloat priceChangeH8;
@property (assign, nonatomic) CGFloat priceChangeH12;
@property (assign, nonatomic) CGFloat openInterest;
@property (assign, nonatomic) CGFloat openInterestCh1;
@property (assign, nonatomic) CGFloat openInterestCh4;
@property (assign, nonatomic) CGFloat openInterestCh24;
@property (assign, nonatomic) CGFloat liquidationH1;
@property (assign, nonatomic) CGFloat liquidationH4;
@property (assign, nonatomic) CGFloat liquidationH12;
@property (assign, nonatomic) CGFloat liquidationH24;
@property (assign, nonatomic) CGFloat longRatio;
@property (assign, nonatomic) CGFloat shortRatio;
@property (assign, nonatomic) CGFloat buyTradeTurnover;
@property (assign, nonatomic) CGFloat sellTradeTurnover;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *exchangeName;
@property (assign, nonatomic) BOOL show;
@property (assign, nonatomic) BOOL follow;

@end

@interface XHContractModel2 : NSObject

@property (nonatomic, strong) NSString * baseCoin;
@property (nonatomic, strong) NSString * contractType;
@property (nonatomic, strong) NSString * exchangeName;
@property (nonatomic, assign) CGFloat expireAt;
@property (nonatomic, assign) CGFloat fundingRate;
@property (nonatomic, assign) CGFloat high24h;
@property (nonatomic, assign) CGFloat lastPrice;
@property (nonatomic, assign) CGFloat low24h;
@property (nonatomic, assign) CGFloat oiCcy;
@property (nonatomic, assign) CGFloat oiUSD;
@property (nonatomic, assign) CGFloat oiVol;
@property (nonatomic, assign) CGFloat open24h;
@property (nonatomic, assign) CGFloat priceChange24h;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, assign) CGFloat tradeTimes;
@property (nonatomic, assign) CGFloat turnover24h;
@property (nonatomic, assign) CGFloat vol24h;
@property (nonatomic, assign) CGFloat volCcy24h;

@end

NS_ASSUME_NONNULL_END
