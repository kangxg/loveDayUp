//
//  ETTRedisHeader.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/16.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#ifndef ETTRedisHeader_h
#define ETTRedisHeader_h

#define ETTREDIS_INLINE static inline
typedef void (^RespondHandler) (id value,id error);
////////////////////////////////////////////////////////
/*
 new      : ADD
 time     : 2017.4.21  11:15
 modifier : 康晓光
 version  ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 branch   ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920／Epic-0421-AIXUEPAIOS-1206
 problem  : 大课件redis验证权限处理
 describe : 错误处理维护枚举
 */
typedef NS_ENUM(NSInteger, ETTErrorMaintenanceState)
{
    /**
     *  Description   无维护
     */
    ETTERRORMAINTENANCENONE = 0x00000,
    /**
     *  Description   维护成功 根据需要自行处理
     */
    ETTERRORMAINTENANCESUCESS,
    /**
     *  Description   维护失败 根据需要自行处理
     
     */
    ETTERRORMAINTENANCEFAILT,
    /**
     *  Description   维护忙，正在维护中
     
     */
    
    ETTERRORMAINTENANCEBUSY,
    
};


/**
 Description  redis 维修记录
 */
typedef struct ETTRedisMaintenanceRecord
{
    ETTErrorMaintenanceState state;
    //维护状态
    BOOL     maintenancing;
    
    //维护最大时间间隔
    NSInteger  maxInterval;
    
    NSInteger  lastMainten;
    
} ETTRedisMaintenanceRecord;
ETTREDIS_INLINE  ETTRedisMaintenanceRecord
ETTRedisMaintenanceRecordMake(BOOL isMaintenance,NSInteger interval,NSInteger maintentime, ETTErrorMaintenanceState state)
{
    ETTRedisMaintenanceRecord            record ;
    record.maintenancing      = isMaintenance;
    record.maxInterval        = interval;
    record.lastMainten        = maintentime;
    record.state              = state;
    return record;
}

typedef void (^ErrorMaintenanceBlock) (ETTErrorMaintenanceState state);
////////////////////////////////////////////////////////


typedef void (^RespondHandler) (id value,id error);
/**
 Description reids 监听频道消息 getReplay  KEY
 */
#define  ETTReciveRedisChannelMsg @"ReciveRedisChannelMsg"

/**
 Description redis set 类型错误
 */
#define ETTRedisCommondSetError @"RedisCommondSetError"

/**
 Description redis get 类型错误
 */
#define ETTRedisCommondGetError @"RedisCommondGetError"

/**
 Description redis 订阅频道 类型错误
 */
#define ETTRedisCommondSubscribeError @"RedisCommondSubscribeError"
/**
 Description redis 向频道推送 类型错误
 */

#define ETTRedisCommondPushChannelError @"RedisCommondPushChannelError"
/**
 Description redis 退订频道 类型错误
 */
#define ETTRedisCommondUNSubscribError  @"RedisCommondUNSubscribError"


/**
 Description redis 频道监听错误类型  add Epic-0421-AIXUEPAIOS-1206

 */
#define ETTRedisCommondGetReplyError    @"RedisCommondGetReplyError"

typedef NS_ENUM(NSInteger,ETTRedisErrorType)
{
    ETTREDISERRORTYPENONE = 1700,
    
    //单次设置哈希 数据错误
    ETTREDISERRORTYPESINGLEHMSET = 1701,
    //连续设置哈希 数据错误
    ETTREDISERRORTYPECONHMSET,
    
    
     //单次设置 数据错误
    ETTREDISERRORTYPESINGSET,
    
    //redis 没有权限认证
    ETTREDISERRORTYPENOAUTH,
    
    //单次 Get哈希数据 错误类型
    ETTREDISERRORTYPEHGET,
    //连续 Get哈希数据 错误类型
    ETTREDISERRORTYPCONHGET,
    //单次 Get数据 错误类型
    ETTREDISERRORTYPEGET,
    //单次 Get数据 key值不存在
    ETTREDISERRORTYPEGETWITHNOKEY,
    
     //单次 Get All哈希数据  错误类型
    ETTREDISERRORTYPHGETALL,
    
    //连续 Get All哈希数据  错误类型
    ETTREDISERRORTYPCONHGETALL,
    
    //向频道推送消息错误
    ETTREDISERRORTYPUBLISH,
     //连续向频道推送消息错误
    ETTREDISERRORTYCONPUBLISH,
    
    //退订频道
    ETTREDISERRORTYUNSUBSCRIBE,
    //redis 实例对象为空
    ETTREDISERRORTYPEREDISNULL,
    
    
    //getreply返回空
    ETTREDISERRORTYPEREPLYNULL,
    ETTREDISERRORTYPEERROR,
    
};
#endif /* ETTRedisHeader_h */
