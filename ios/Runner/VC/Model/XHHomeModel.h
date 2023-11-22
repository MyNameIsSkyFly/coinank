//
//  XHHomeModel.h
//  UUKR
//
//  Created by ZXH on 2022/6/23.
//  Copyright © 2022 ZHX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHHomeModel : NSObject

@end

//资金费率
@interface XHFundingRateModel : NSObject

@property (strong, nonatomic) NSString *baseCoin;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *exchangeName;
@property (assign, nonatomic) CGFloat ufundingRate;
@property (assign, nonatomic) CGFloat cfundingRate;
@property (assign, nonatomic) CGFloat fundingRate;

@end

//多空比
@interface XHShortRateModel : NSObject

@property (strong, nonatomic) NSString *baseCoin;
@property (strong, nonatomic) NSString *exchangeName;
@property (assign, nonatomic) NSString *interval;
@property (assign, nonatomic) CGFloat sellTradeTurnover;
@property (assign, nonatomic) CGFloat buyTradeTurnover;
@property (assign, nonatomic) CGFloat longRatio;
@property (assign, nonatomic) CGFloat shortRatio;
@property (strong, nonatomic) NSArray *longRatios;
@property (strong, nonatomic) NSArray *shortRatios;
@property (strong, nonatomic) NSArray *tss;

@end

//持仓
@interface XHPositionModel : NSObject

@property (strong, nonatomic) NSString *baseCoin;
@property (strong, nonatomic) NSString *exchangeName;
@property (assign, nonatomic) CGFloat rate;
@property (assign, nonatomic) CGFloat change1H;
@property (assign, nonatomic) CGFloat change4H;
@property (assign, nonatomic) CGFloat change24H;
@property (assign, nonatomic) CGFloat coinCount;
@property (assign, nonatomic) CGFloat coinValue;
@property (assign, nonatomic) NSString *interval;

@end

@interface XHGreendyModel : NSObject

@property (strong, nonatomic) NSString *ids;
@property (assign, nonatomic) CGFloat cnnValue;
@property (strong, nonatomic) NSString *createTime;
@property (assign, nonatomic) CGFloat price;

@end

@interface XHLiquidationModel : NSObject

@property (strong, nonatomic) NSString *baseCoin;
@property (strong, nonatomic) NSString *exchangeName;
@property (strong, nonatomic) NSString *interval;
@property (assign, nonatomic) CGFloat totalTurnover;
@property (assign, nonatomic) CGFloat longTurnover;
@property (assign, nonatomic) CGFloat shortTurnover;
@property (assign, nonatomic) int percentage;
@property (assign, nonatomic) int longRatio;
@property (assign, nonatomic) int shortRatio;

@end

@interface XHLongShortRateModel : NSObject

@property (assign, nonatomic) CGFloat OkexRatio;
@property (assign, nonatomic) CGFloat binanceRatio;
@property (strong, nonatomic) NSString *interval;
@property (strong, nonatomic) NSString *baseCoin;

@end

@interface XHTopLabelModel : NSObject

@property (assign, nonatomic) CGFloat shortRatio;
@property (assign, nonatomic) CGFloat longRatio;
@property (assign, nonatomic) CGFloat liquidation;
@property (assign, nonatomic) CGFloat ticker;
@property (assign, nonatomic) CGFloat openInterest;

@property (assign, nonatomic) CGFloat OIChange;
@property (assign, nonatomic) CGFloat binancePersonChange;
@property (assign, nonatomic) CGFloat binancePersonValue;
@property (assign, nonatomic) CGFloat cnnChange;
@property (assign, nonatomic) CGFloat cnnValue;
@property (assign, nonatomic) CGFloat liquidationChange;
@property (assign, nonatomic) CGFloat liquidationLong;
@property (assign, nonatomic) CGFloat liquidationShort;
@property (assign, nonatomic) CGFloat marketCpaChange;
@property (assign, nonatomic) CGFloat marketCpaValue;
@property (assign, nonatomic) CGFloat okexPersonChange;
@property (assign, nonatomic) CGFloat okexPersonValue;
@property (assign, nonatomic) CGFloat tickerChange;
@property (assign, nonatomic) CGFloat btcProfit;


@end

NS_ASSUME_NONNULL_END
