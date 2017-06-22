//
//  ETTRedisDataHouseManageInterface.h
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2016/12/15.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETTRedisWorkerManageInterface.h"
#import "ETTRedisHeader.h"

#import "ObjCHiredis.h"
@class ETTRedisDataWarehouse;
@protocol ETTRedisDataHouseManageInterface <NSObject>
@optional
@property (nonatomic,weak)id<ETTRedisWorkerManageInterface>      EDManager;
@property (nonatomic,weak,readonly)ETTRedisDataWarehouse     *   EDDataHouse;

///用于非频道消息监听以外的其他操作。
@property (nonatomic,strong) ObjCHiredis                     *   EDCocoaRedis;
///用于监听频道消息
@property (nonatomic,strong) ObjCHiredis                     *   EDChannelRedis;


@property (nonatomic,copy)   NSString                        *   EDServerHost;
@property (nonatomic,assign) int                                 EDServerPort;

@property (nonatomic,assign) NSInteger                           EDHeartTime;

@property (nonatomic,assign)BOOL                                 EDHasRegChannel;
-(instancetype)init:(id<ETTRedisWorkerManageInterface>) manger withHouse:(ETTRedisDataWarehouse *)dataHouse;

-(void)setConnectResponHandler:(RespondHandler)responHandler;

/**
 Description 获取密码
 
 @return 密码字符串
 */
-(NSString *)getWorkPassword;

-(void)setWorkPassword:(NSString *)pwd;

-(NSString *)getWorkHost;

-(int)getWorkServerPort;

-(void)updateTime:(NSDate *)redisDate;



-(NSTimeInterval )getRedisTime;

-(NSTimeInterval )getLoginTime;

-(RespondHandler)getRespondBackHandle;
/**
 Description 放入订阅的频道数组
 
 */
-(void)putinChannelWithArr:(NSArray<NSString *> *)channelArr;
/**
 Description 放入频道
 
 */
-(void)putinChannelWithChannelName:(NSString *)channelName;

-(void)removeChannelWithArr:(NSArray<NSString *> *)channelArr;

-(void)removeChannelWithChannelName:(NSString *)channelName;


-(void)removeOberServer;

-(void)registerOberServer:(void (^)(NSString *message))subscribeMessage;


-(void)endWork;

-(void)dataWarehousing:(id)info;

////////////////////////////////////////////////////////
/*
 new      : ADD
 time     : 2017.4.21  11:26
 modifier : 康晓光
 version  ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920
 branch   ：hotfix/develop-1.20-NewRedis-AIXUEPAIOS-920／Epic-0421-AIXUEPAIOS-1206
 problem  : 大课件redis验证权限处理
 describe : 向数据管理报告
 */
-(void)reportProblem:(id<ETTRedisWorkerInterface>) worker withFault:(ObjCHiredis *)redis withError:(NSError *)err withHandle:(ErrorMaintenanceBlock)block ;
////////////////////////////////////////////////////////

@end


