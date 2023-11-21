//
//  HttpHeader.h
//  UUKR
//
//  Created by ZXH on 2022/6/20.
//  Copyright © 2022 ZHX. All rights reserved.
//

#ifndef HttpHeader_h
#define HttpHeader_h

#define HOST @"https://coinsoto.com"
//#define HOST @"http://47.57.9.238"

#define WEBSOCKET @"wss://coinsoto.com/wsKline/wsKline"

#define DEPTHURL @"https://coinsoho.s3.us-east-2.amazonaws.com/mview/nested/depth.html"

#define IMAGEHOST @"https://cdn01.coinsoto.com/image/coin/64/"

//K线图数据
#define HTTP_GET_KLING_URL @"/api/kline/list"

//登录
#define HTTP_POST_LOGIN_URL @"/api/User/login"

//获取验证码
#define HTTP_POST_SEND_CODE_URL @"/api/User/sendVerifyCode"

//退出登录
#define HTTP_POST_LOGINOUT_URL @"/api/User/logOut"

//注册
#define HTTP_POST_REGISTRT_URL @"/api/User/register"

//忘记密码
#define HTTP_RESETPASSWORD_URL @"/api/User/updatePassWord"

//资金费率
#define HTTP_GET_FUNDINGRATE_URL @"/api/fundingRate/currentByCoin"

//资金费率
#define HTTP_GET_FUNDINGRATE_URL2 @"/api/fundingRate/current"

//首页资金费率
#define HTTP_GET_HOME_FUNDINGRATE_URL @"/api/fundingRate/top"

//多空比
#define HTTP_GET_SHORTRATE_URL @"/api/longshort/realtimeAll"

//获取多空比js交互数据
#define HTTP_GETSHORTRATE_JS_URL @"/api/longshort/realtime"

//持仓
#define HTTP_GET_POSITION_URL @"/api/openInterest/all"

//获取持仓js交互数据
#define HTTP_GETPOSITION_JS_URL @"/api/openInterest/chart"

//贪婪恐惧指数
#define HTTP_GET_GREEDY_URL @"/indicatorapi/getCnnEntityLast"

//爆仓数据
#define HTTP_GET_LIQUIDATION_URL @"/api/liquidation/allExchange/intervals"

//合约持仓
#define HTTP_GET_INSTRUMENTS_URL @"/api/instruments/agg"

//合约持仓2
#define HTTP_GET_INSTRUMENTS2_URL @"/api/instruments/aggForIos"

//查询交易对
#define HTTP_POST_SYMBLOS_URL @"/api/baseCoin/symbols"

//多空人數比
#define HTTP_LONGSHORTRATIOMINA_URL @"/api/longshort/longShortRatioMini"

//首页滚动内容
#define HTTP_STATISTICS_URL @"/api/Statistics/all"

//行情添加关注
#define HTTP_ADDFLOWER_URL @"/api/userFollow/addOrUpdateFollow"

//行情删除关注
#define HTTP_DELETEFLOWER_URL @"/api/userFollow/delFollow"

//删除账号
#define HTTP_DELETE_ACCOUNT_URL @"/api/User/logOff"

//保存用户信息
#define HTTP_POST_USERINFO_SAVE_URL @"/api/User/saveSetting"

//查询图表列表
#define HTTP_GET_CHART_LIST_URL @"/api/app/indicationMain"

//查询图表左侧列表
#define HTTP_GET_CHART_LEFT_LIST_URL @"/api/app/indicationNavs"

//持仓变化/价格变化
#define HTTP_GET_PRICE_CHARGE_URL @"/api/instruments/aggRank"

//获取所有币种
#define HTTP_GET_ALL_CURRENCY_URL @"/api/baseCoin"

//合约市场
#define  HTTP_GET_CONTRACTMARKET_URL @"/api/tickers"


/*----WebUrl----*/
//资金费率
#define WEB_FUNDINGRATE_URL @"/index.html#/pages/fundingRate/index"

//多空比
#define WEB_LONGSHORT_URL @"/longshort/realtime"

//多空比持仓人数
#define WEB_LONGSHORTNUMBER_URL @"/longshort/longShortPersonRatio"

//合约持仓
#define WEB_OPENINTEREST_URL @"/index.html#/pages/index/index"

//爆仓数据
#define WEB_LIQUIDSTION_URL @"/index.html#/pages/liquidation/index"

//图标charts
#define WEB_CHARTS_URL @"/m/charts"

//关于我们
#define WEB_ABOUT_URL @"/about"

//隐私条款
#define WEB_PRIVACY_URL @"/privacy"

//使用条款
#define WEB_DISCLAIMER_URL @"/disclaimer"

//贪婪恐惧
#define WEB_FEARGREED_URL @"/indexdata/feargreedIndex"

//首页提醒
#define WEB_NOTICECONFIG_URL @"/users/noticeConfig"

//投资组合
#define WEB_PORTFOLIO_URL @"/users/portfolio"

//合约市场
#define WEB_INSTRUMENTS_URL @"/m/contracts/instruments"

//比特币市值占比
#define WEB_BTC_MARKET_CAP_URL @"/indexdata/btcMarketCap"

//24小时成交量
#define WEB_VOL_24H_URL @"/indexdata/oivol/vol24h"

//BTC投资回报率
#define  WEB_BTC_INVESTMENT_RATE_URL @"/indexdata/profit"

//灰度数据
#define  WEB_BTC_GRAYSCALE_URL @"/grayscale"

//清算地图
#define WEB_LIQ_MAP_CHAR_URL @"/liqMapChart"

#endif /* HttpHeader_h */
