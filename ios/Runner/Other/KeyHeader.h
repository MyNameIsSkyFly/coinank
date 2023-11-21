//
//  KeyHeader.h
//  UUKR
//
//  Created by ZXH on 2022/7/19.
//  Copyright © 2022 ZHX. All rights reserved.
//

#ifndef KeyHeader_h
#define KeyHeader_h

#define KLINE_HEIGHT 260


#define HOST @"https://coinsoto.com"


#define kObjForKey(key)     [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define kValueForKey(key)   [[NSUserDefaults standardUserDefaults] valueForKey:key]
#define kBoolForKey(key)    [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define kAccount            ((kObjForKey(@"userName")) ? kObjForKey(@"userName") : @"")
#define kPassword            ((kObjForKey(@"passWord")) ? kObjForKey(@"passWord") : @"")
#define kDeviceID            ((kObjForKey(@"deviceID")) ? kObjForKey(@"deviceID") : @"")

#define kIslogin            ((kBoolForKey(@"isLogin")) ? YES : NO)
#define kIsRedGreen         ((kBoolForKey(@"isRedGreen")) ? YES : NO)

#define kTheme              kObjForKey(@"theme")
#define kToken              ((kObjForKey(@"token")) ? kObjForKey(@"token") : @"")
#define kLoginData          ((kObjForKey(@"loginData")) ? kObjForKey(@"loginData") : @"")
#define kIsDark            ([kTheme isEqualToString:@"night"] ? YES : NO)

//url
#define kUrlDepth           ((kObjForKey(@"urlDepth")) ? kObjForKey(@"urlDepth") : DEPTHURL)
#define kStrDomain          ((kObjForKey(@"strDomain")) ? kObjForKey(@"strDomain") : @"coinsoto.com")
#define kWebsocketUrl          ((kObjForKey(@"websocketUrl")) ? kObjForKey(@"websocketUrl") : WEBSOCKET)
#define kApiPrefix          ((kObjForKey(@"apiPrefix")) ? kObjForKey(@"apiPrefix") : HOST)
#define kH5Prefix          ((kObjForKey(@"h5Prefix")) ? kObjForKey(@"h5Prefix") : HOST)
#define kUniappDomain      ((kObjForKey(@"uniappDomain")) ? kObjForKey(@"uniappDomain") : @"coinsoto-h5.s3.ap-northeast-1.amazonaws.com")

//kLine
#define kLineTime           ((kObjForKey(@"klineTime")) ? kObjForKey(@"klineTime") : @"")
#define kLineMainType       ((kObjForKey(@"kLineMainType")) ? kObjForKey(@"kLineMainType") : @"")
#define kLineMACD           ((kBoolForKey(@"kLineMACD")) ? YES : NO)
#define kLineKDJ           ((kBoolForKey(@"kLineKDJ")) ? YES : NO)
#define kLineRSI           ((kBoolForKey(@"kLineRSI")) ? YES : NO)


#define kMAValue            @"MAValue"
#define kBOLLValue          @"BOLLValue"
#define kEMAValue           @"EMAValue"
#define kMACDValue          @"MACDValue"
#define kKDJValue           @"KDJValue"
#define kRSIValue           @"RSIValue"

#define KCollectionArray    @"CollectionArray"
#define KCloseLeftView      @"CloseLeftView"

#endif /* KeyHeader_h */
